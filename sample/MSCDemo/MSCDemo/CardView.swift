//
//  CardView.swift
//  ZLSwipeableViewSwiftDemo
//
//  Created by Zhixuan Lai on 5/24/15.
//  Copyright (c) 2015 Zhixuan Lai. All rights reserved.
//

import UIKit

class CardView: UIView {
    var lable:UILabel!
    var title:UILabel!
    var itemDate:PickItem{
        set(newValue){
            lable.text=newValue.content
            title.text=newValue.title
        }
        get{return self.itemDate}
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        // Shadow
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOpacity = 0.25
        layer.shadowOffset = CGSizeMake(0, 1.5)
        layer.shadowRadius = 4.0
        layer.shouldRasterize = true
        layer.rasterizationScale = UIScreen.mainScreen().scale
        
        // Corner Radius
        layer.cornerRadius = 10.0;
        lable=UILabel(frame: self.frame)
        lable.numberOfLines=0
        var frame = self.frame
        frame.size.height=40
        title=UILabel(frame: frame)
        self.addSubview(lable)
        self.addSubview(title)
    }
}
