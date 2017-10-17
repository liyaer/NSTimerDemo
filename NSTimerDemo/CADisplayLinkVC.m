//
//  CADisplayLinkVC.m
//  ThreeTypesTimer
//
//  Created by 杜文亮 on 2017/10/16.
//  Copyright © 2017年 杜文亮. All rights reserved.
//

#import "CADisplayLinkVC.h"




@interface CADisplayLinkVC ()

@property (nonatomic,strong) CADisplayLink *display;
@property (weak, nonatomic) IBOutlet UIImageView *AnimationImg;

@end




@implementation CADisplayLinkVC
{
    int _index;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _display = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayRun:)];
     //设置大概1s执行一次的两种写法，从默认值和写法上来看，二者数值设置刚好相反
    _display.frameInterval = 20;//默认值1
//    _display.preferredFramesPerSecond = 1;// 默认值60，取值范围 1--100, 值越大, 频率越高
    [_display addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

//实测：APP进入后台定时任务依然进行（如果需要进入后台停止定时任务，请另做设置）
- (void)displayRun:(CADisplayLink *)link
{
    _index++;
    
    //不太合适的Demo
//    if (_index > 4)
//    {
//        [link invalidate];//或者[link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//        _display = nil;
//        NSLog(@"end%@---%@",link,_display);
//    }
//    
    //合适的Demo
    if (_index > 4)
    {
        _index = 1;
        self.AnimationImg.image = [UIImage imageNamed:@"1"];
    }
    else
    {
        self.AnimationImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",_index]];
    }
    
    NSLog(@"%d", _index);
}




#pragma mark - 关于控制

- (IBAction)pause:(id)sender
{
    if (_display)
    {
        if (!_display.isPaused)
        {
            _display.paused = YES;
        }
    }
}

- (IBAction)start:(id)sender
{
    if (_display)
    {
        if (_display.isPaused)
        {
            _display.paused = NO;
        }
    }
}




#pragma mark - 关于释放

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (_display)
    {
        [_display invalidate];//或者[link removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _display = nil;//这里可以不释放_display,因为VC释放了，_display自然也就释放了。但是实际应用中并不一定就是这种需求，所以建议写上
    }
}

-(void)dealloc
{
    /*
     *   1,这里不释放_display，无法终止定时任务，待任务执行完毕dealloc
     *   2,这里即使写上释放_display的代码，也无法终止定时任务，待任务执行完毕dealloc
     *   总结：所以释放_display的代码写在这里不合适（注意和NSTimer的区别，NSTimer因为循环引用的关系根本不能在dealloc中释放timer，会影响dealloc;而_display虽然不影响dealloc,但是无法及时停止定时任务）
     */
//    if (_display)
//    {
//        [_display invalidate];
//        _display = nil;
//    }
    
    NSLog(@"%@释放了！",[self class]);
}


@end
