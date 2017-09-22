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
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes/*UITrackingRunLoopMode*/];
    
    /*
     *                           介绍下runLoop中的几种mode
     
     *  Default mode（NSDefaultRunLoopMode）
        默认模式中几乎包含了所有输入源(NSConnection除外),一般情况下应使用此模式。
     
     *  Connection mode（NSConnectionReplyMode）
        处理NSConnection对象相关事件，系统内部使用，用户基本不会使用。
     
     *  Modal mode（NSModalPanelRunLoopMode）
        处理modal panels事件。
     
     *  Event tracking mode（UITrackingRunLoopMode）
        在拖动loop或其他user interface tracking loops时处于此种模式下，在此模式下会限制输入事件的处理。例如，当手指按住UITableView拖动时就会处于此模式。
     
     *  Common mode（NSRunLoopCommonModes）
        这是一个伪模式，其为一组run loop mode的集合，将输入源加入此模式意味着在Common Modes中包含的所有模式下都可以处理。在Cocoa应用程序中，默认情况下Common Modes包含default modes,modal modes,event Tracking modes.可使用CFRunLoopAddCommonMode方法想Common Modes中添加自定义modes。
     
     */
    
    //根据上面mode的介绍，写个有意思的小例子。将上面代码mode设置为【UITrackingRunLoopMode】，实现当滑动tableView时，才执行定时器任务；停止滑动，也会停止执行
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
