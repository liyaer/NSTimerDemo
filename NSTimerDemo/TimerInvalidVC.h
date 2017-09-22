//
//  TimerInvalidVC.h
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/22.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


/*
 *   介绍一种常见的情况，使定时器暂时停止计时。
 
 *   当界面上存在scrollView(包括它的子类)，滑动scrollView时，timer失效
 */

#import <UIKit/UIKit.h>

@interface TimerInvalidVC : UIViewController

@end
