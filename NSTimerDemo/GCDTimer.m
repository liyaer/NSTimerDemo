//
//  GCDTimer.m
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "GCDTimer.h"

@implementation GCDTimer
{
    BOOL isValid;
    BOOL isOn;
}



#pragma mark - 初始化

- (id)init
{
    self = [super init];
    if (self)
    {
        isValid = YES;
        isOn = YES;
    }
    return self;
}

+ (nullable GCDTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(nullable id)aTarget selector:(nullable SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo
{
    GCDTimer *timer = [[GCDTimer alloc]init];
    timer.ti = ti;
    timer.atarget = aTarget;
    timer.aSelector = aSelector;
    timer.userInfo = userInfo;
    
    if (yesOrNo)//repeat = YES,重复执行的timer（其实就是一个重复性延时调用的实现）
    {
        [timer repeatSelector];//使用GCD实现重复性timer的效果
    }
    else//repeat = NO，一次性的timer（其实就是一个延时调用的实现）
    {
        //使用GCD实现一次性timer的效果
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ti * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
       {
           [aTarget performSelectorOnMainThread:aSelector withObject:userInfo waitUntilDone:NO];
       });
    }
    return timer;
}




//使用GCD实现重复性timer的效果
-(void)repeatSelector
{
    //和上面一次性timer本质一样，只不过多用了一个isValid参数来控制是否重复执行
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.ti * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
   {
       isOn ? [self.atarget performSelectorOnMainThread:self.aSelector withObject:self.userInfo waitUntilDone:NO] : NSLog(@"模拟timer暂停状态！");
       
       isValid ? [self repeatSelector] : NSLog(@"通过属性控制，模拟【timer invaildate】");
   });
}




#pragma mark - 模拟暂停、开启、销毁定时器

- (void)reStart
{
    isOn = YES;
}

- (void)stop
{
    isOn = NO;
}

- (void)invalidate
{
    isValid = NO;
}

@end
