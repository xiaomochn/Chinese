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
    

    var startButton:DeformationButton!
    //    http://www.haha365.com/rkl/index_2.htm
    
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
        updateDatas()
    }
    func initView(){
        let frame = CGRect(x: self.view.frame.size.width/2 - 40, y: self.view.frame.size.height - 60, width: 80, height: 40)
        
        startButton = DeformationButton(frame: frame, withColor: MaterialColor.pink.base)
         self.view.addSubview(startButton)
        startButton.forDisplayButton.setTitle("开始", forState: UIControlState.Normal)
        startButton.forDisplayButton.setTitleColor(MaterialColor.blue.base, forState: UIControlState.Normal)
        startButton.addTarget(self, action: "beginClick:", forControlEvents: UIControlEvents.TouchUpInside)
//       startButton.forDisplayButton.setTitleEdgeInsets
        
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
        let tempPage = self.currentPage
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            
            //这里写需要大量时间的代码
            self.datas.appendContentsOf(self.loadPage(tempPage))
            self.isLoading = false;
            dispatch_async(dispatch_get_main_queue(), {
                if(tempPage == 1 ){
                    self.swipeableView.discardViews()
                    self.swipeableView.loadViews()
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
        cardView.lable.text="正在加载中"
        if self.datas.count > currentIndex{
            cardView.itemDate=self.datas[currentIndex]
            currentIndex++
        }
        if (self.datas.count < (self.currentIndex + 10)){
            self.updateDatas()
        }
        return cardView
    }
    func didSwip(direction:Direction){
        
    }
    
    @IBAction func beginClick(sender: AnyObject) {
        let card = (swipeableView.topView()) as! CardView
        if self.startButton.isLoading{
            self.start(card.contenText)
            swipeableView.allowedDirection = .None
        }else{
            swipeableView.allowedDirection = .All
            self.onBtnCancel()
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
    func onResultJson(result:NSString? = nil)
    {
        if (result == nil){
            self.startButton.isLoading = false
            swipeableView.allowedDirection = .All
            return
        }
        let card = (swipeableView.topView()) as! CardView
        //        UIView.animateWithDuration(3) { () -> Void in
        //            let attributeString = NSMutableAttributedString(string: "你是我的按时发生的发生 1asdfasdfs")
        //            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(),range: NSMakeRange(0, 7))
        //
        //            card.lable.attributedText = attributeString
        //        }
        
    }
    
    
}
