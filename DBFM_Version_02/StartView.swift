//
//  StartView.swift
//  DBFM_Version_02
//
//  Created by Edward on 14-9-14.
//  Copyright (c) 2014 Edward. All rights reserved.
//

import UIKit


class StartView:UIViewController ,LeftButtonProtocol ,UIGestureRecognizerDelegate {
    
    var viewController:ViewController = ViewController()
    var setParameterView:LeftSideViewController=LeftSideViewController()
    var setParameterViewValid:Bool = false //判断左侧边栏状态
    var preVelocity:CGPoint = CGPointMake(0,0)
    var slideEffective:Bool = false //判断滑动是否生效
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewController = ViewController(nibName: "MainViewController",bundle: nil)
        println("Hello")
        self.view.addSubview(self.viewController.view)
        self.addChildViewController(self.viewController)
        viewController.didMoveToParentViewController(self)
        viewController.delegate = self
        self.setupGesture()
//        self.presentViewController(self.viewController,
//                          animated: false,
//                          completion: nil)
    }
    
    init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        //        var array:NSArray = NSBundle.mainBundle().loadNibNamed("CustomTabBarView", owner: self, options: nil)
    }
    
    init(coder aDecoder: NSCoder!)
    {
        super.init(coder: aDecoder)
    }
    
    //获取左边栏
    func getLeftView() -> UIView{
        println("left view is \(self.setParameterViewValid)")
        if (!self.setParameterViewValid)
        {
            println("setParameterView")
            //this is where you define the view for the left panel
            self.setParameterView = LeftSideViewController(nibName: "LeftViewController",bundle: nil)
            self.setParameterView.delegate = viewController
            self.setParameterView.view.tag = LEFT_PANEL_TAG;
            //self.setParameterView.view.backgroundColor = UIColor.whiteColor()
            //setParameterView.delegate = self;
            
            self.view.addSubview(self.setParameterView.view)
            self.addChildViewController(self.setParameterView)
            
            setParameterView.didMoveToParentViewController(self)
            
            viewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            //println("tttt")
        }
        
        self.setParameterViewValid = true
        var leftView:UIView = self.setParameterView.view
        
        // Set up view shadows
        self.showCenterViewWithShadow(true,withOffset:-2)
        return leftView;
    }
    
    //显示阴影
    func showCenterViewWithShadow(value:Bool, withOffset offset:Double){
        if (value){
            viewController.view.layer.cornerRadius = CORNER_RADIUS
            viewController.view.layer.shadowColor = UIColor.blackColor().CGColor
            viewController.view.layer.opacity = 0.8
            viewController.view.layer.shadowOffset = CGSizeMake(offset,offset)
        }
        else{
            viewController.view.layer.cornerRadius = 0.0
            viewController.view.layer.shadowOffset = CGSizeMake(offset,offset)
        }
    }
    
    
    //回归主界面
    func backToOriginalPosition(){
        UIView.animateWithDuration(SLIDE_TIMING,
            animations: { () -> Void in
                self.viewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
            },
            completion: { (finished: Bool) -> Void in
                if (finished) {
                    self.resetMainView()
                    //self.setParameterViewValid = false
                    self.viewController.leftButton.tag = 1
                }})
        
    }
    
    
    //划出左边栏
    func moveToLeftView(){
        var childView = self.getLeftView()
        //self.view.sendSubviewToBack(self.view)
        //self.view.addSubview(childView)
        //self.view.insertSubview(childView, atIndex:2)
        self.view.sendSubviewToBack(childView)
        println("the num of subview is \(self.view.subviews.count)")
        
        //self.view.bringSubviewToFront(childView)
        UIView.animateWithDuration(SLIDE_TIMING,
            delay: 0.0,
            options: UIViewAnimationOptions.BeginFromCurrentState,
            animations: { () -> Void in
                //self.setParameterView.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
                self.viewController.view.frame = CGRectMake(self.view.frame.size.width - PANEL_WIDTH - 100.0, 0, self.view.frame.size.width, self.view.frame.size.height)
                //println("1111")
            },
            completion: { (finished : Bool) -> Void in
                if (finished) {
                    self.viewController.leftButton.tag = 0
                    self.setParameterViewValid = true
                    //self.CycleType = self.setParameterView.cycleType
                }
            })
    }
    
    //删除子视图并重设各标识位
    func resetMainView(){
            //println("\(setParameterViewValid)")
        if(setParameterViewValid){
            println("reset")
            self.setParameterView.view.removeFromSuperview()
            self.setParameterView = LeftSideViewController()
            setParameterViewValid = false
            viewController.leftButton.tag = 1
        }
        
        self.showCenterViewWithShadow(false,withOffset:0)
    }
    
    //添加手势
    func setupGesture(){
        var panRecognizer:UIPanGestureRecognizer = UIPanGestureRecognizer(target:self,action:Selector("movePanel:"))
        panRecognizer.minimumNumberOfTouches = 1
        panRecognizer.maximumNumberOfTouches = 1
        panRecognizer.delegate = self
        
        self.viewController.view.addGestureRecognizer(panRecognizer)
    }
    
    //处理手势划出左边栏
    func movePanel(sender: AnyObject){
        //println("Hello")
        var panGesture:UIPanGestureRecognizer = sender as UIPanGestureRecognizer
        var translatedPoint:CGPoint = panGesture.translationInView(self.view)
        var velocity:CGPoint = panGesture.velocityInView(panGesture.view)
        panGesture.view.layer.removeAllAnimations()
        //手势开始
        if(panGesture.state == UIGestureRecognizerState.Began){
             var childView:UIView
            if(velocity.x > 0){
                if(!setParameterViewValid){
                    childView = self.getLeftView()
                    self.view.sendSubviewToBack(childView)
                }
            }else{
                println("起始滑动方向为左滑")
            }
            
            //self.view.sendSubviewToBack(childView)
            panGesture.view.bringSubviewToFront(panGesture.view)
        }
        //手势结束时
        if(panGesture.state == UIGestureRecognizerState.Ended){
//            if(velocity.x > 0){
//                println("Gesture went right")
//            }else{
//                println("Gesture went left")
//            }
            
            if(!slideEffective){
                self.backToOriginalPosition()
            }else{
                if(!setParameterViewValid){
                    self.moveToLeftView()
                }else{
                    println("ee")
                }
            }
        }
        //手势变化中
        if(panGesture.state == UIGestureRecognizerState.Changed){
//            if(velocity.x > 0){
//                println("Gesture went right")
//            }else{
//                println("Gesture went left")
//            }
            //Are you more than halfway? If so, show the panel when done dragging by setting this value to true
            slideEffective = (abs(panGesture.view.center.x - self.viewController.view.frame.size.width/2) > (self.viewController.view.frame.size.width/2))
            
            //Allow dragging only in x-coordinates by only updating the x-coordinate with translation position..description..description.
            panGesture.view.center = CGPointMake(panGesture.view.center.x+translatedPoint.x, panGesture.view.center.y)
            panGesture.setTranslation(CGPointMake(0,0),inView:self.view)
            
            //If you needed to check for a change in direction, you could use this code to do so.
            if((velocity.x * preVelocity.x + velocity.y * preVelocity.y) > 0){
                println("same direction")
            }else{
                println("opposite direction")
            }
            preVelocity = velocity            
        }
    }
}
