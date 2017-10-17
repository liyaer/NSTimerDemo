//
//  GCDTimerVC.m
//  ThreeTypesTimer
//
//  Created by 杜文亮 on 2017/10/16.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "GCD_TimerVC.h"




@interface GCD_TimerVC ()

@property (nonatomic,strong) dispatch_source_t timer;//注意用strong关键字（copy也可以）

@end




@implementation GCD_TimerVC
{
//    dispatch_source_t _timer;//在这里声明也可以
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self sentPhoneCodeTimeMethod:10];
}

//倒计时  ---  实测：APP进入后台定时任务依然进行（如果需要进入后台停止定时任务，请另做设置）
- (void)sentPhoneCodeTimeMethod:(NSInteger)seconds
{
    //倒计时时间 - 60S
    __block NSInteger timeOut = seconds - 1;
    //执行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //计时器 -》 dispatch_source_set_timer自动生成
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
//    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);或者写成下面这样，区别就是前者在系统休眠时还会继续计时, 而后者在系统休眠时就停止计时, 待系统重新激活时, 接着继续计时
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1.0, 0);
    dispatch_source_set_event_handler(_timer, ^
    {
        if (timeOut <= 0)// 倒计时结束
        {
            // 关闭定时器,完全销毁定时器, 重新开启的话需要重新创建，关闭后需要置为nil
            dispatch_source_cancel(_timer);
            NSLog(@"%@",_timer);
            _timer = nil;
            NSLog(@"%@",_timer);
            
            //主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^
            {
            });
        }
        else//倒计时中
        {
            NSInteger needSecond = timeOut % seconds;//剩余秒数 needSecond
            NSLog(@"距离下次提交评论还有----%ld",needSecond);
            
            //主线程更新UI
            dispatch_async(dispatch_get_main_queue(), ^
            {
            });
            timeOut--;
        }
    });
    dispatch_resume(_timer);
}




#pragma mark - 关于控制

//暂停（注意：如果点击了2次暂停，那么需要点击2次开启，才能重新启动）
- (IBAction)pause:(id)sender
{
    // 暂停定时器,可使用dispatch_resume(_timer)再次开启,全局变量, 暂停后不能置为nil, 否则不能重新开启
    if (_timer)
    {
        dispatch_suspend(_timer);
        //    _timer = nil;会crash，不能写也不需要写
    }
}

//开启
- (IBAction)resume:(id)sender
{
    if (_timer)
    {
        dispatch_resume(_timer);
    }
}




#pragma mark - 关于释放

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_timer)
    {
        dispatch_source_cancel(_timer);
        _timer = nil;//这里可以不释放_timer,因为VC释放了，_timer自然也就释放了。但是实际应用中并不一定就是这种需求，所以建议写上(注意：如果点击了暂停，在popVC，会因为这句话crash,原因在上面暂停点击事件中有提到)
    }
}

-(void)dealloc
{
    /*
     *   1,这里不释放_timer，无法终止定时任务，待任务执行完毕dealloc
     *   2,这里即使写上释放_timer的代码，也无法终止定时任务，待任务执行完毕dealloc
     *   总结：所以释放_timer的代码写在这里不合适（注意和NSTimer的区别，NSTimer因为循环引用的关系根本不能在dealloc中释放timer，会影响dealloc;而_timer虽然不影响dealloc,但是无法及时停止定时任务）
     */
//    if (_timer)
//    {
//        dispatch_source_cancel(_timer);
//       _timer = nil;//这里可以不释放_timer,因为VC释放了，_timer自然也就释放了。但是实际应用中并不一定就是这种需求，所以建议写上
//    }
    
    NSLog(@"%@---释放了！",[self class]);
}

@end
