//
//  MultiThreadUsingVC.h
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


/*
 *   写在前面：在阅读这部分代码时我们假设
        1，已经对多线程有了一定的了解，如果不清楚，可以参考gitHub上的GCDDemo（当然多线程实现有多种方式，这里我们只讨论GCD的情况）
        2，对于NSTimer基本使用已经十分熟练
 
 *   1-NSTimerVC、2-GCDTimer、3-WeakTimer默认都是执行在主线程中，其中1，3都是基于NSTimer的操作，2是我们通过GCD手动模拟实现NSTimer功能的过程，不属于NSTimer的使用范畴，可以说和NSTimer毫无关系，只是为了帮助我们更好的理解底层原理。
 
 *   综上所述，对于多线程中NSTimer的使用，我们只考虑1，3两份代码的使用情况，因为3是对1的简单封装，二者本质上是一样的，都是对NSTimer的操作，所以我们只那NSTimer来做测试即可
 */

#import <UIKit/UIKit.h>

@interface MultiThreadUsingVC : UIViewController

@end
