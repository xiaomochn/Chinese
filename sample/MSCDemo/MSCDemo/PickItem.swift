//
//  PickItem.swift
//  Chinese
//
//  Created by xiaomo on 16/3/10.
//
//

import UIKit

class PickItem: NSObject {
    var title:String!
    var content:String!
    required init (title: String,content:String) {
        super.init()
        self.title = title
        self.content = content
    }

}
