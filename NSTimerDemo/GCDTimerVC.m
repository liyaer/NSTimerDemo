//
//  GCDTimerVC.m
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "GCDTimerVC.h"
#import "GCDTimer.h"

@interface GCDTimerVC ()
{
    GCDTimer *timer;
    int index;
}
@end

@implementation GCDTimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    timer = [GCDTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(XTimerSelector:) userInfo:@{@"key":@"value"} repeats:YES];
    
    //这部分纯属个人测试，介绍下【performSelectorOnMainThread】方法,waitUntilDone为NO，不等待【XTimerSelector:】执行完，继续向下执行代码【NSLog】（类似于异步操作，不阻塞当前线程）；waitUntilDone为YES，等待【XTimerSelector:】执行完，继续向下执行代码【NSLog】（类似于同步操作，阻塞当前线程）
    //    [self performSelectorOnMainThread:@selector(XTimerSelector:) withObject:@{@"key":@"value"} waitUntilDone:NO];
    //    NSLog(@"测试waitUntilDone参数设置！");//log1
}

-(void)XTimerSelector:(NSDictionary *)info
{
    //    sleep(3.0);//为了测试waitUntilDone的参数设置，模拟一个耗时操作，才能更清楚的看到效果。YES：等待3秒，先打印log1,在打印log2；NO：直接打印log1,3秒后打印log2
    NSLog(@"======%d",index++);//log2
}




#pragma mark - 控制方法

- (IBAction)reStart:(id)sender
{
    [timer reStart];
}

- (IBAction)stop:(id)sender
{
    [timer stop];
}

- (IBAction)invalidate:(id)sender
{
    [timer invalidate];
//    timer = nil; 这句话写与不写的区别就在于：提前手动释放timer的内存占用和ARC下timer随控制器dealloc而自动释放内存暂用
}




#pragma mark - dealloc

- (void)dealloc
{
    NSLog(@"不存在循环引用，控制器可以正常释放！");
}

@end
