//
//  HomeVC.swift
//  Chinese
//
//  Created by xiaomo on 16/3/9.
//
//

import UIKit
import ZLSwipeableViewSwift
class HomeVC: ISEViewController {
    var colorIndex = 0
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
    }
    
}
