//
//  ViewController.m
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/19.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "NSTimerVC.h"



@interface NSTimerVC ()
{
    NSTimer *_timer;
    int _index;
}
@end



@implementation NSTimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    /*
     *                        Step.1 - 创建timer的三种初始化方式
     
     *  前言：-!- NSTimer想要执行，必须加入到runLoop中。
             -!- 关于runLoop:每个线程都有一个runLoop，只有主线程默认是开启状态，若要使用其他线程的runLoop，需要手动开启。runLoop无法创建，只能通过[NSRunLoop currentRunLoop]和[NSRunLoop mainRunLoop]来获取当前线程、主线程
     
     *  1，【scheduledTimerWithTimeInterval】创建timer并将其自动添加至当前线程（当前是主线程就加入到主线程runLoop中；是子线程就加入到子线程runLoop中。但是只有主线程的runLoop是默认开启的，其他线程的runLoop想要使用，必须手动开启。）的runLoop中
     
     *  2，【timerWithTimeInterval】创建timer，手动添加至runLoop
     
     *  3，【initWithFireDate】创建timer，手动添加至runLoop
     
     */
//    [self typeOne];
//    [self typeTwo];
//    [self typeThree];

    /*
     *                         Step.1中关于参数repeat的设置
     
     *  YES：重复的timer，将永生，直到你显式的调用invalidate它为止
     
     *  NO：一次性的timer，在完成调用以后会自动将自己invalidate（这个已经做过测试，说法正确）
     
     *  底层原理：repeats = YES时，self的引用计数会加1。因此可能会导致self（即viewController）不能release。所以必须在viewWillDisAppear的时候，将计数器timer销毁【invalidate + nil】，否则可能会导致内存泄露
                repeats = NO时，在完成调用以后会自动将自己invalidate
     
     *  总结：repeat的设置可以决定我们是否需要手动调用invalidate
     
     */
    
    
    /*
     *  Step.1之后，定时器已经处于激活态，已经开始每间隔一段设定的间隔时间，调用定时器中的方法。但是第一次执行定时器中的方法时，需要等待一个间隔时间，那么如何让第一次立刻执行呢？
     
     *  下面介绍两个方法，1，[NSDate distantPast]  2，[_timer fire]来实现上述需求
     
     *  typeOne、typeTwo可以通过1，2来实现上述需求；typeThree直接用[NSDate distantPast]初始化即可
     */
    //1
//    _timer.fireDate = [NSDate distantPast];//属性方式
//    [_timer setFireDate:[NSDate distantPast]];//消息方式
    //2
//    [_timer fire];
    /*
     *                              总结二者的异同
     *  1，二者在定时器是激活态时，效果完全一样，都可以立即执行一次定时器中的方法（上述需求的实现就是例子）
     *  2，但是在定时器是暂停态时，fire只能保证在暂停态下立即执行一次定时器中的方法，而前者除了保证立即执行一次定时器中的方法外，还可以将定时器从暂停态变成激活态（下面【startTimer】就是例子）
     */
    [self testFire];//DemoOne 说明二者的异同
}

-(void)typeOne
{
    //1 - selector方式
//    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(dylog) userInfo:nil repeats:YES];
    //1 - block方式
    _timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer)
      {
          NSLog(@"=======%d=======",_index++);
      }];
}

-(void)typeTwo
{
    //2 - selector方式
    //    _timer = [NSTimer timerWithTimeInterval:3.0 target:self selector:@selector(dylog) userInfo:nil repeats:YES];
    //2 - block方式
    _timer = [NSTimer timerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer)
      {
          NSLog(@"=======%d=======",_index++);
      }];
    
    //将timer加入runLoop(不加入runLoop timer不会执行)
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];//加入主线程runLoop
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];//加入当前线程(不一定是主线程)
}

-(void)typeThree
{
    //3 - selector方式
//    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]/*[NSDate distantPast]、[NSDate distantFuture] */ interval:2.0 target:self selector:@selector(dylog) userInfo:nil repeats:YES];
    //3 - block方式
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]/*[NSDate distantPast]、[NSDate distantFuture] */ interval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer)
    {
        NSLog(@"=======%d=======",_index++);
    }];
    
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
//    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

//证明上述对fire的理解 DemoOne
-(void)testFire
{
    //初始化时指定，5秒之后，激活timer
    _timer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0] interval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer)
      {
          NSLog(@"=======%d=======",_index++);
      }];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    
    //体验二者的不同之处
    [_timer setFireDate:[NSDate distantPast]];//越过5秒等待，提前执行一次定时器中的方法，直接激活timer（开始间隔2秒开始重复执行）
//    [_timer fire];//只能提前执行一次定时器中的方法，没有改变timer状态的能力；等待5秒后，定时器激活（开始间隔2秒开始重复执行）
}




#pragma mark - 点击事件集合

-(void)dylog
{
    NSLog(@"=======%d=======",_index++);
}

//立即开始
-(IBAction)startTimer:(id)sender
{
    [_timer setFireDate:[NSDate distantPast]];//消息方式
//    _timer.fireDate = [NSDate distantPast];//属性方式
    
    //也可以设置从现在起，几秒后开启定时器（[NSDate distantFuture]代表一个无限大的时间，所以可以代表暂停效果）
    [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:5.0]];
}

//立即暂停
- (IBAction)pauseTimer:(id)sender
{
    [_timer setFireDate:[NSDate distantFuture]];//消息方式
//    _timer.fireDate = [NSDate distantFuture];//属性方式
}

//从runLoop中移除
- (IBAction)deallocTimer:(id)sender
{
    /*
     *   之前的一个设想：只invalidate，但是不置nil,在【startTimer】中添加将timer添加至runLoop的代码，应该会接着打印，但是测试结果并没有！也就意味着，只要执行了invalidate，那么就算是销毁了定时器，此时_timer无法被再次利用，那么直接置nil，释放内存的占用。
     
     *   总结：以后说释放timer，只要invalidate，就立即置nil。
     */
    [_timer invalidate];//停止timer的运行，这个是永久的停止，这也是唯一一个可以将计时器从runloop中移出的方法
    _timer = nil;
}

//DemoOne 说明二者的异同（定时器处于激活态，点击【fireClick】和【startTimer】效果一样；暂停的时候分别点击【fireClick】和【startTimer】就能测试出二者的区别了）
- (IBAction)fireClick:(id)sender
{
    [_timer fire];
}




#pragma mark - NSTimer的释放测试

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer)
    {
        if ([_timer isValid])//如果timer还在runLoop中
        {
            [_timer invalidate];
        }
        _timer = nil;
    }
    NSLog(@"dealloc timer!");
}

-(void)dealloc
{
    NSLog(@"控制器被释放！");
}



@end
