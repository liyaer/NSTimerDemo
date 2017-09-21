//
//  ViewController.h
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/19.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


#warning 如果用了多线程，timer在哪个线程创建，就应该在哪个线程释放，否则会造成内存泄漏（具体查看MultiThreadUsingVC）
/*
 *   NSTimer的使用和释放
 
 *   NSTimer可以精确到50-100毫秒.NSTimer不是绝对准确的,而且中间耗时或阻塞错过下一个执行点，那么就pass继续执行下一个执行点.
 
 *   由于NSTimer和控制器存在循环引用关系，所以不能在控制的dealloc中执行【timer invalidate】操作，对timer的释放我们写在viewWillDisappear，解除循环引用关系，随后控制器可以dealloc
 */

#import <UIKit/UIKit.h>

@interface NSTimerVC : UIViewController


@end

