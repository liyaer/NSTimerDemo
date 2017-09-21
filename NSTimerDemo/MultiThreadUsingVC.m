//
//  MultiThreadUsingVC.m
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


#import "MultiThreadUsingVC.h"

@interface MultiThreadUsingVC ()
{
    int _index;
}
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSThread* timerThread;

@end

@implementation MultiThreadUsingVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"查看主线程ID号");
    //通过GCD创建一个子线程
//    dispatch_async(dispatch_get_global_queue(0, 0), ^
//   {
//       NSLog(@"查看子线程【1】ID号码");
//       _timerThread = [NSThread currentThread];
//       
//       _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dylog) userInfo:@{@"key":@"value"} repeats:true];
//       [[NSRunLoop currentRunLoop] run];//虽然每个线程都有一个runLoop，但只有主线程runLoop默认开启，子线程runLoop需要手动开启
//   });
    
    _timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(creatTimer) object:nil];
    [_timerThread start];
}

-(void)dylog
{
    NSLog(@"timer创建在子线程，那么timer中方法执行也在子线程：%d",_index++);
}

-(void)creatTimer
{
   _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dylog) userInfo:@{@"key":@"value"} repeats:true];
   [[NSRunLoop currentRunLoop] run];//虽然每个线程都有一个runLoop，但只有主线程runLoop默认开启，子线程runLoop需要手动开启
}

-(void)timerInvalidate
{
    [_timer invalidate];
}

#pragma mark - NSTimer的释放测试

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer)
    {
        if ([_timer isValid])//如果timer还在runLoop中
        {
            [self performSelector:@selector(timerInvalidate) onThread:_timerThread withObject:nil waitUntilDone:YES];
            NSLog(@"查看invalidate的执行是否和timer的创建在同一个线程！");
        }
        _timer = nil;
    }
    NSLog(@"MultiThreadUsingVC -- dealloc timertimertimertimertimertimertimer!");
}

-(void)dealloc
{
    NSLog(@"MultiThreadUsingVC -- dealloc!");
}

@end
