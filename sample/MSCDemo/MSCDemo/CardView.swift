//
//  CardView.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 5/24/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit
import Material
//import LTMorphingLabel
class CardView: UIView {
    var lable:UILabel!
    var title:UILabel!
    var score:UILabel!
    var itemDate:PickItem{
        set(newValue){
            
            lable.text=newValue.content.stringByReplacingOccurrencesOfString("\r", withString: "").stringByReplacingOccurrencesOfString("\n", withString: "").stringByReplacingOccurrencesOfString(" ", withString: "").stringByReplacingOccurrencesOfString("　", withString: "")
            title.text=newValue.title
        }
        get{return self.itemDate}
    }
    var contenText:String{
        get{

            var str  = self.lable.text! as String
            str.stringByReplacingOccurrencesOfString("，", withString: "").stringByReplacingOccurrencesOfString("。", withString: "").stringByReplacingOccurrencesOfString("；", withString: "")
            if str.characters.count > 59 {
                return str.substringToIndex(str.startIndex.advancedBy(58))
            }
            return str
        }
        set(newValue){
            
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

   static let colors = [MaterialColor.red.base,MaterialColor.pink.base,MaterialColor.purple.base,MaterialColor.deepPurple.base,MaterialColor.indigo.base,MaterialColor.blue.base,MaterialColor.lightBlue.base,MaterialColor.cyan.base,MaterialColor.teal.base,MaterialColor.green.base,MaterialColor.lightGreen.base,MaterialColor.lime.base,MaterialColor.yellow.base,MaterialColor.amber.base,MaterialColor.orange.base,MaterialColor.brown.base,MaterialColor.grey.base,MaterialColor.blueGrey.base]
    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
         layer.cornerRadius = 10.0;
        // Corner Radius
        
        
       
        var frame = CGRect()
        frame.size.height=40
        frame.size.width=self.frame.size.width - 30
        frame.origin=CGPoint(x: self.frame.origin.x+15, y: self.frame.origin.y+15)
        title=UILabel(frame: frame)
        title.textColor=MaterialColor.blue.base
        
        
       
        var frameContent = CGRect()
        frameContent.size.height=self.frame.size.height-frame.size.height - 30
        frameContent.size.width=self.frame.size.width - 30
        frameContent.origin=CGPoint(x: self.frame.origin.x+15, y: self.frame.origin.y+frame.size.height+30)
        lable=UILabel(frame: frameContent)
        
         lable.textColor=MaterialColor.white
        lable.numberOfLines=0
        
        
//       let a = arc4random_uniform( CardView.colors.count)
         self.backgroundColor = CardView.colors[Int(arc4random()) % (CardView.colors.count)]
        
        
        var frameScore = CGRect()
        frameScore.size.height=100
        frameScore.size.width=100
        frameScore.origin=CGPoint(x: self.frame.size.width - 100, y: self.frame.size.height - 100)
        score=UILabel(frame: frameScore)
        score.textColor=MaterialColor.red.base
        score.text="3211分"
        
        self.addSubview(lable)
        self.addSubview(title)
        self.addSubview(score)
    }
}
