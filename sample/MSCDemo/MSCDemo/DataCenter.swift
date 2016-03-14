//
//  DataCenter.swift
//  CYFP
//
//  Created by xiaomo on 16/1/14.
//  Copyright © 2016年 umoney. All rights reserved.
//  用来全局传值的

import UIKit

class DataCenter: NSObject {
    
    static let dataCenterObj:DataCenter = DataCenter()
    var datas=NSMutableDictionary()
    class func getDataCenter() ->DataCenter {
        return dataCenterObj
    }
//    func getValue(key:String)->String{
//        return datas.objectForKey(key) as! String
//    }
    func removeStringValue(key:String)->String?{
        let value=datas.objectForKey(key) as? String
        if value != nil
        {datas.removeObjectForKey(key)}
        return value
    }
    func putStringValue(key:String,value:String){
        datas.setObject(value, forKey: key)
    }
    func removePickItemValue(key:String)->PickItem?{
        let value=datas.objectForKey(key) as? PickItem
        if value != nil
        {datas.removeObjectForKey(key)}
        return value
    }
    func putPickItemValue(key:String,value:PickItem){
        datas.setObject(value, forKey: key)
    }
}
