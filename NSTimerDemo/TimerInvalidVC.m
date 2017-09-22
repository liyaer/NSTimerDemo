//
//  TimerInvalidVC.m
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/22.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "TimerInvalidVC.h"




@interface TimerInvalidVC ()
{
    int _index;
    NSTimer *timer;
}
@property (nonatomic,strong) UITableView *tableView;

@end




@implementation TimerInvalidVC


-(UITableView *)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:0];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.tableView];
    //直接这样写，当滑动tableView的时候，会发现定时器不会执行了
//    timer = [NSTimer scheduledTimerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer)
//     {
//         NSLog(@"========%d",_index++);
//     }];

    /*
     *                              下面提供两种解决办法
     
     *  1，修改runLoop的mode（简单快捷,默认NSDefaultRunLoopMode，修改为NSRunLoopCommonModes）
     
     *  2，将定时器放在子线程（参考上面多线程中的使用，这里不再举例，但是亲测可用）
     
     */
    timer = [NSTimer timerWithTimeInterval:2.0 repeats:YES block:^(NSTimer * _Nonnull timer)
    {
         NSLog(@"========%d",_index++);
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}




#pragma mark - NSTimer的释放测试

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (timer)
    {
        if ([timer isValid])//如果timer还在runLoop中
        {
            [timer invalidate];
        }
        timer = nil;
    }
    NSLog(@"TimerInvalidVC  ----- dealloc timer!");
}

-(void)dealloc
{
    NSLog(@"控制器被释放！");
}

@end
