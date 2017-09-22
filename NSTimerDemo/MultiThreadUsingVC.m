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
    
    _timerThread = [[NSThread alloc] initWithTarget:self selector:@selector(creatTimer) object:nil];
    [_timerThread start];
    
    //监听子线程的释放（为了证明下面@autoreleasepool{}的写法可以释放我们的子线程）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(threadfinishTask:) name:NSThreadWillExitNotification object:nil];
}
- (void)threadfinishTask:(NSNotification *)notification{
    
    NSLog(@"==============================子线程被释放了！");
}




#pragma mark - 封装方法调用集合

-(void)creatTimer
{
    @autoreleasepool//释放子线程
    {
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dylog) userInfo:@{@"key":@"value"} repeats:true];
        
        do
        {
            //PS:虽然每个线程都有一个runLoop，但只有主线程runLoop默认开启，子线程runLoop需要手动开启,下面是几种启动子线程runLoop的方式
            
            //1，直接启动 在这里不能这样写，因为没有参数限制，可以粗略的认为无法监测_timer的状态，导致无法释放线程和控制器
//            [[NSRunLoop currentRunLoop] run];
            
            //2，设置每隔2秒回到当前线程runLoop。效果:_timer释放后，等待2秒回到当前线程runLoop，可以监测到_timer的状态，从儿释放线程，最终控制器也可以被释放
//            [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:2.0]];
            
            //3，效果：可以实时监测到_timer的释放，从而实时的释放线程，最终控制器也可以被释放
//            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantPast]];
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

        } while (_timer);
    }
}

-(void)dylog
{
    NSLog(@"timer创建在子线程，那么timer中方法执行也在子线程：%d",_index++);
}

-(void)timerInvalidate
{
    if (_timer)
    {
        if ([_timer isValid])//如果timer还在runLoop中
        {
            [_timer invalidate];
            NSLog(@"查看invalidate的执行是否和timer的创建在同一个线程！");
        }
        _timer = nil;
    }
}




#pragma mark - NSTimer在子线程的释放测试

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self performSelector:@selector(timerInvalidate) onThread:_timerThread withObject:nil waitUntilDone:YES];//正确做法
//    [self timerInvalidate];这样写代表在主线程调用，是无法正常释放timer的，最终导致VC无法dealloc。错误做法
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"MultiThreadUsingVC -- dealloc!");
}


@end
