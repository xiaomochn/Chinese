//
//  MyLoveViewController.swift
//  meizi
//
//  Created by xiaomo on 15/8/31.
//  Copyright (c) 2015年 Muhammad Bassio. All rights reserved.
//

import UIKit
class MyLoveViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
 
    @IBOutlet weak var itemTableview: UITableView!
    var itemArray:NSMutableArray!
    var picItems:NSMutableArray!
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableview.delegate=self
        itemTableview.dataSource=self
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initdata()
        self.itemTableview.reloadData()
    }
    func initdata(){
            picItems=NSMutableArray()
         itemArray = NSMutableArray(contentsOfFile: GlobalVariables.getMyLovePlistPath())
        for  str in itemArray!{
            let tempResult = str.componentsSeparatedByString(GlobalVariables.splitTag)
            if tempResult.count > 2{
            picItems.addObject(PickItem(title: tempResult[0], content: tempResult[1], score:tempResult[2]))
            }else if tempResult.count > 1{
             picItems.addObject(PickItem(title: tempResult[0], content: tempResult[1]))
            }
        }
    }
    // tableveiew
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return picItems.count
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

          let  cell = tableView.dequeueReusableCellWithIdentifier("MyLoveViewCell") as! MyLoveViewCell
            cell.data = picItems[indexPath.row] as! PickItem
            return cell
    }
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        DataCenter.getDataCenter().putPickItemValue("item", value: picItems[indexPath.row] as! PickItem)
        self.tabBarController!.selectedIndex=0
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.endEditing(true)
        if editingStyle  == UITableViewCellEditingStyle.Delete
        {
            itemArray.removeObjectAtIndex(indexPath.row)
            picItems.removeObjectAtIndex(indexPath.row)
            let array=NSMutableArray()
            array.addObject(indexPath)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Bottom)
            itemArray.writeToFile(GlobalVariables.getMyLovePlistPath(), atomically: true)
        }
    }
    
    
   
    
}
