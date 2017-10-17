//
//  CADisplayLinkVC.h
//  ThreeTypesTimer
//
//  Created by 杜文亮 on 2017/10/16.
//  Copyright © 2017年 杜文亮. All rights reserved.
//


/*
 *   屏幕刷新时调用：
        CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。CADisplayLink以特定模式注册到runloop后，每当屏幕显示内容刷新结束的时候，runloop就会向CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。所以通常情况下，按照iOS设备屏幕的刷新率60次/秒
    延迟：
        iOS设备的屏幕刷新频率是固定的，CADisplayLink在正常情况下会在每次刷新结束都被调用，精确度相当高。但如果调用的方法比较耗时，超过了屏幕刷新周期，就会导致跳过若干次回调调用机会。
        如果CPU过于繁忙，无法保证屏幕60次/秒的刷新率，就会导致跳过若干次调用回调方法的机会，跳过次数取决CPU的忙碌程度。
        （话句话说，iOS设备的刷新频率事60HZ也就是每秒60次。那么每一次刷新的时间就是1/60秒 大概16.7毫秒。当我们的frameInterval 值为1的时候我们需要保证的是 CADisplayLink调用的target的函数计算时间不应该大于 16.7否则就会出现严重的丢帧现象，此时可以设置大一点的frameInterval值）
    使用场景：
        从原理上可以看出，CADisplayLink适合做界面的不停重绘，比如视频播放的时候需要不停地获取下一帧用于界面渲染。
 
    CADisplayLink的一些属性变量：（1，2常用，3，4不常用）
 
        1，是否暂停，控制CADisplayLink的运行
            @property(getter=isPaused, nonatomic) BOOL paused;
 
        2，间隔多少帧调用一次selector 方法，默认1（每帧都调用一次）=60次，2=30次
            @property(nonatomic) NSInteger frameInterval;
 
        3，每帧之间的时间，readOnly类型的CFTimeInterval值，表示两次屏幕刷新之间的时间间隔。需要注意的是，该属性在target的selector被首次调用以后才会被赋值。selector的调用间隔时间计算方式是：调用间隔时间 = duration × frameInterval
            @property(readonly, nonatomic) CFTimeInterval duration;
 
        4，屏幕显示的上一帧的时间戳，只读的CFTimeInterval值。
            @property(readonly, nonatomic) CFTimeInterval timestamp;
 */

#import <UIKit/UIKit.h>

@interface CADisplayLinkVC : UIViewController

@end
