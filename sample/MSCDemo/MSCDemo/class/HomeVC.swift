//
//  HomeVC.swift
//  Chinese
//
//  Created by xiaomo on 16/3/9.
//
//

import UIKit
import ZLSwipeableViewSwift
import Alamofire
import Ji
import Material
import DeformationButton
class HomeVC: ISEViewController {
    var currentIndex = 0
    var currentPage = 0
    var datas:[PickItem] = [PickItem]()
    var isLoading = false
    var localPageF = 1

    var startButton:DeformationButton!
    //    http://www.haha365.com/rkl/index_2.htm
    
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        currentPage=loadLocalPage()
        localPageF = currentPage+1
        initView()
        updateDatas()
        }
   
    func loadLocalPage()->Int{
       
        let dic = NSMutableDictionary(contentsOfFile: GlobalVariables.getUserPage())
        if dic==nil || dic!["page"]  == nil
        {return 0}
        return dic!["page"] as! Int
    }
    func saveLocalPage(){
        
        let dic = NSMutableDictionary(contentsOfFile: GlobalVariables.getUserPage())
        dic?.setObject(currentPage, forKey: "page")
        dic?.writeToFile(GlobalVariables.getUserPage(), atomically: true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let item = DataCenter.getDataCenter().removePickItemValue("item")
        if item != nil{
            (self.swipeableView.topView() as! CardView).itemDate=item!
        }
    }
    func initView(){
        let frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height - 100, width: 80, height: 40)
        
        startButton = DeformationButton(frame: frame, withColor: MaterialColor.pink.base)
         self.view.addSubview(startButton)
        startButton.forDisplayButton.setTitle("开始", forState: UIControlState.Normal)
        startButton.forDisplayButton.setTitleColor(MaterialColor.white, forState: UIControlState.Normal)
        startButton.addTarget(self, action: "beginClick:", forControlEvents: UIControlEvents.TouchUpInside)
//       startButton.forDisplayButton.setTitleEdgeInsets
        swipeableView.allowedDirection = .None
        swipeableView.nextView = {
            return self.nextCardView()
        }
        swipeableView.didSwipe = {view, direction, vector in
            self.didSwip(direction)
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        
    }
    func updateDatas(){
        if (isLoading){
            return
        }
        isLoading = true
        self.currentPage++
        if self.currentPage >= 43{
        self.currentPage = 1
            self.localPageF = 1
        }
        saveLocalPage()
        let tempPage = self.currentPage
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            //这里写需要大量时间的代码
            self.datas.appendContentsOf(self.loadPage(tempPage))
            self.isLoading = false;
            dispatch_async(dispatch_get_main_queue(), {
                if self.datas.count > 0{
                     self.swipeableView.allowedDirection = .All
                }
                if(tempPage == self.localPageF){
                    self.swipeableView.discardViews()
                    self.swipeableView.loadViews()
                    self.tempCartC=self.getTopCard()
                }
                //这里返回主线程，写需要主线程执行的代码
            })
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func nextCardView() -> UIView? {
        let cardView = CardView(frame: swipeableView.bounds)
//        cardView.lable.text="正在加载中"
        if self.datas.count > currentIndex{
            cardView.itemDate=self.datas[currentIndex]
            cardView.pageNum=currentIndex
            currentIndex++
        }
        if (self.datas.count < (self.currentIndex + 10)){
            self.updateDatas()
        }
        return cardView
    }
    var tempCart:CardView!
    var tempCartC:CardView!
    func didSwip(direction:Direction){
        
        tempCart = tempCartC
        tempCartC = getTopCard()
        if direction != Direction.Right{
            return
        }
        if tempCart==nil{
            return
        }
        let array=NSMutableArray(contentsOfFile: GlobalVariables.getMyLovePlistPath())
//        getTopCard().title.text
        let content = "\(tempCart.title.text! as String)\(GlobalVariables.splitTag)\(tempCart.lable.text!as String)\(GlobalVariables.splitTag)\(tempCart.itemDate.score)"
        if array?.containsObject(content)==false
        {
            array?.insertObject(content, atIndex: 0)
            let issuccess = array?.writeToFile(GlobalVariables.getMyLovePlistPath(), atomically: true)
            print(issuccess)
        }
       
    }
    
    @IBAction func beginClick(sender: AnyObject) {
        let card = (swipeableView.topView()) as! CardView
        if self.startButton.isLoading{
            self.start(card.contenText)
            swipeableView.allowedDirection = .None
        }else{
            swipeableView.allowedDirection = .All
            self.onBtnStop()
        }
        
        
    }
    
    
    //    http://www.haha365.com/rkl/index_2.htm
    func loadPage(page:Int)->[PickItem]{
        var  datas = [PickItem]()
        let googleIndexData = NSData(contentsOfURL: NSURL(string: "http://www.haha365.com/rkl/index_\(page).htm")!)
        if let googleIndexData = googleIndexData {
            let jiDoc = Ji(htmlData: googleIndexData)!
            jiDoc.xPath("head")
            let htmlresult = jiDoc.xPath("//body/div[@id=\"main\"]/div[@class=\"content\"]/div[@class=\"left\"]/div[@class=\"r_c\"]/div[@class=\"cat_llb\"]")
            for var result in htmlresult!{
                datas.append(PickItem(title: (result.xPath("h3").first?.content)!, content:(result.xPath("div[@id=\"endtext\"]").first?.content)! ))
            }
        } else {
            print("google.com is inaccessible")
        }
        return datas
    }

    func onResultStr(result:String? = nil)
    {
        
        let card = (swipeableView.topView()) as! CardView
        if (result == nil){
            self.startButton.isLoading = false
            swipeableView.allowedDirection = .All
//            card.score.text=result.total_score
            return
        }

    
        
    }
    func getTopCard()->CardView{
        return self.swipeableView.topView() as! CardView
    }
//    func onResults(results:NSData,isLast:ObjCBool){
//        let a = isLast;
//        
//    }
    
}
