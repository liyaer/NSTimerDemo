//
//  WeakTimer.h
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


/*
 *   写在前面：基于NSTimer的一个简单封装，解决和控制器的循环引用问题，用法除了初始化方式之外，其他和NStimer一模一样
 
 *   原始的NSTimer和控制器之前存在循环引用的问题（即不能在控制器的dealloc中执行【timer invalidate】，只能在viewWillDisappear中执行）；这份代码解决了循环引用的问题，当控制器pop时，因为弱引用的关系，可以dealloc控制器
 
 *   如果我们需要在控制器dealloc时，结束定时任务的执行，那么原始的NSTimer就无法实现（因为循环引用），此时可以用这份自定义的timer来实现该过程（因为不存在循环引用）
 */

#import <Foundation/Foundation.h>


@interface WeakTimer : NSObject

//将NSTimer和控制器的引用关系变成弱引用
+ (NSTimer *) scheduledTimerWithTimeInterval:(NSTimeInterval)interval
                                      target:(id)aTarget
                                    selector:(SEL)aSelector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

@end
