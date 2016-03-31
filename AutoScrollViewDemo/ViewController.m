//
//  ViewController.m
//  AutoScrollViewDemo
//
//  Created by aios on 15/8/31.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import "ViewController.h"
#import "LBAutoDisplayScrollView.h"
@interface ViewController ()<LBAutoDisplayScrollViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    LBAutoDisplayScrollView* autoDisplayScrollView=[[LBAutoDisplayScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height*0.5)];
    autoDisplayScrollView.delegate=self;
    autoDisplayScrollView.imageNames=@[@"1",@"2",@"3",@"4"];
//    autoDisplayScrollView.imageURLs=@[
//       @"http://img.hb.aicdn.com/1f2acbecdc6ac6187a9b02bffe4a5dedc9fe45ff15a44-D6LjC1_fw580",
//       @"http://img4.duitang.com/uploads/item/201411/30/20141130160518_FzGfQ.jpeg",
//       @"http://img5.duitang.com/uploads/item/201405/31/20140531174431_KPuf2.thumb.700_0.jpeg",
//       @"http://img5.duitang.com/uploads/item/201405/31/20140531174207_hH5u4.thumb.700_0.jpeg"
//       ];
    autoDisplayScrollView.imageHolder=[UIImage imageNamed:@"bg"];
    autoDisplayScrollView.interval=5;
    autoDisplayScrollView.duration=2;
    autoDisplayScrollView.textHorizontalInset = 30;
    autoDisplayScrollView.textVerticalInset = 30;
    autoDisplayScrollView.texts = @[@"哈地方可垃圾房地哦啊见佛啊就饿哦附近进来撒大家佛啊佛啊的佛啊打击偶发房间哦啊见佛iII代搜集发哦",@"哈地方可垃圾房地",@"哈地方可垃圾房地哦啊见佛啊就饿哦附近",@"哈地方可垃圾房地哦啊见佛啊就饿哦附发生地偶发噢IFA叫法第四佛啊近"];
    
//    autoDisplayScrollView.AutoScrollDirection=LBScrollDirectionLeft;
    [self.view addSubview:autoDisplayScrollView];
    
}

- (void)imageClickedWithIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}

@end
