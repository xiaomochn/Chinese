//
//  MyLoveViewCell.swift
//  meizi
//
//  Created by xiaomo on 15/8/31.
//  Copyright (c) 2015年 Muhammad Bassio. All rights reserved.
//

import UIKit

class MyLoveViewCell: UITableViewCell {
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    
    var data:PickItem{
        get{
            return PickItem(title: "", content: "")
        }
        set(newValue){
            title.text = newValue.title
            content.text = newValue.content
            score.text = newValue.score
        }
    }
}
