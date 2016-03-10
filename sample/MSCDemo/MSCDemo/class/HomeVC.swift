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
class HomeVC: ISEViewController {
    var colorIndex = 0
    var currentIndex = 0
    var currentPage = 1
    var datas:[PickItem] = [PickItem]()
//    http://www.haha365.com/rkl/index_2.htm
      var colors = ["Turquoise", "Green Sea", "Emerald", "Nephritis", "Peter River", "Belize Hole", "Amethyst", "Wisteria", "Wet Asphalt", "Midnight Blue", "Sun Flower", "Orange", "Carrot", "Pumpkin", "Alizarin", "Pomegranate", "Clouds", "Silver", "Concrete", "Asbestos"]
    @IBOutlet weak var swipeableView: ZLSwipeableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        swipeableView.nextView = {
            return self.nextCardView()
        }
        swipeableView.didSwipe = {view, direction, vector in
            self.didSwip(direction)
            print("Did swipe view in direction: \(direction), vector: \(vector)")
        }
        self.datas.appendContentsOf(loadPage(currentPage))
        
//        swipeableView.topView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func nextCardView() -> UIView? {
        if colorIndex >= colors.count {
            colorIndex = 0
        }
        
        let cardView = CardView(frame: swipeableView.bounds)
        cardView.backgroundColor = UIColor.greenColor()
        colorIndex++
        let attributeString = NSMutableAttributedString(string: "你是我的按时发生的发生 1asdfasdfs")
        attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blueColor(),range: NSMakeRange(0, 3))
        
        cardView.lable.attributedText = attributeString
        if self.datas.count > currentIndex{
            cardView.itemDate=self.datas[currentIndex]
            currentIndex++
        }
        
        return cardView
    }
    func didSwip(direction:Direction){
    
    }
    
    @IBAction func beginClick(sender: AnyObject) {
       let card = (swipeableView.topView()) as! CardView
       
        UIView.animateWithDuration(3) { () -> Void in
            let attributeString = NSMutableAttributedString(string: "你是我的按时发生的发生 1asdfasdfs")
            attributeString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(),range: NSMakeRange(0, 7))
            
            card.lable.attributedText = attributeString
        }
        
        self.start("你是谁")
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
}
