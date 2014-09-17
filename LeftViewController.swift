//
//  LeftViewController.swift
//  DBFM_Version_02
//
//  Created by Edward on 14-9-11.
//  Copyright (c) 2014年 Edward. All rights reserved.
//

import Foundation
import UIKit

enum CycleType {
    case fullCycle //全部循环
    case singleCycle //单曲循环
    case randomCycle //随机循环
}

protocol CycleTypeProtocol{
    func setCycleType(cycleType:CycleType)
}

class LeftSideViewController: UIViewController {
    var cycleType:CycleType=CycleType.fullCycle //默认全部循环
    var delegate:CycleTypeProtocol?
    
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //        var array:NSArray = NSBundle.mainBundle().loadNibNamed("CustomTabBarView", owner: self, options: nil)
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    @IBAction func fullCycle(sender: AnyObject) {
        cycleType = CycleType.fullCycle
        println("current Cycle Type is \(cycleType)")
        self.delegate?.setCycleType(cycleType)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func singleCycle(sender: AnyObject) {
        cycleType = CycleType.singleCycle
        println("current Cycle Type is \(cycleType)")
        self.delegate?.setCycleType(cycleType)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func randomCycle(sender: AnyObject) {
        cycleType = CycleType.randomCycle
        println("current Cycle Type is \(cycleType)")
        self.delegate?.setCycleType(cycleType)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}