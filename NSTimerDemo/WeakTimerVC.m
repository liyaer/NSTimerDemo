//
//  WeakTimerVC.m
//  NSTimerDemo
//
//  Created by 杜文亮 on 2017/9/21.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "WeakTimerVC.h"
#import "WeakTimer.h"




@interface WeakTimerVC ()

@property (nonatomic,weak/*strong也是可以的*/) NSTimer *timer;
@property (nonatomic,assign) int index;

@end




@implementation WeakTimerVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _timer = [WeakTimer scheduledTimerWithTimeInterval:2.0 target:self selector:@selector(dylog:) userInfo:@"Fire" repeats:YES];

    //除了初始化之外，一切用法都和原始的NSTimer一样
//    [_timer setFireDate:[NSDate distantPast]];
//    [_timer fire];
}

-(void)dylog:(id)userInfo
{
    NSLog(@"====%@:%d",userInfo,_index++);
}

- (IBAction)startTimer:(id)sender
{
    [_timer setFireDate:[NSDate distantPast]];
}
- (IBAction)pauseTimer:(id)sender
{
    [_timer setFireDate:[NSDate distantFuture]];
}
- (IBAction)deallocTimer:(id)sender
{
    [_timer invalidate];
    _timer = nil;
}




//封装后的timer可以写在dealloc中释放（因为不存在循环引用了）
-(void)dealloc
{
    if (_timer)
    {
        if ([_timer isValid])
        {
            [_timer invalidate];
        }
        _timer = nil;
    }
    NSLog(@"控制器被释放！=====index:%d",_index);
}


@end
