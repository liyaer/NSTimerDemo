//
//  GCDTimer.h
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//



/*
 *   写在前面：这份代码完全和原始的NSTimer无任何关系
 
 *   通过GCD来模拟NSTimer的底层实现原理（但是这份代码的定时不如NSTimer准确，可以看成一个自定义类型的NSTimer，帮助我们更好的理解实现原理）
 
 *   原始的NSTimer和控制器之前存在循环引用的问题（即不能在控制器的dealloc中执行【timer invalidate】，只能在viewWillDisappear中执行）；这份代码解决了循环引用的问题，当控制器pop时，因为弱引用的关系，可以dealloc控制器
 
 *   如果我们需要在控制器dealloc时，结束定时任务的执行，那么原始的NSTimer就无法实现（因为循环引用），此时可以用这份自定义的timer来实现该过程（因为不存在循环引用）
 */

#import <Foundation/Foundation.h>

@interface GCDTimer : NSObject

/*
 *   属性
 */
@property  NSTimeInterval ti;
@property (nullable,weak) id atarget;
@property (nullable,nonatomic, assign) SEL aSelector;
@property (nullable, retain) id userInfo;

/*
 *   初始化方法
 */
+ (nullable GCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(nullable id)aTarget selector:(nullable SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;

/*
 *   控制开启、暂停、销毁的方法
 */
- (void)reStart;//模拟[NSDate distantPast]
- (void)stop;//模拟[NSDate distantFuture]
- (void)invalidate;//模拟[_timer invalidate]

@end
