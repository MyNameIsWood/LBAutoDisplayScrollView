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
//    autoDisplayScrollView.imageNames=@[@"1",@"2",@"3",@"4"];
    autoDisplayScrollView.imageURLs=@[
       @"http://img.hb.aicdn.com/1f2acbecdc6ac6187a9b02bffe4a5dedc9fe45ff15a44-D6LjC1_fw580",
       @"http://img4.duitang.com/uploads/item/201411/30/20141130160518_FzGfQ.jpeg",
       @"http://img5.duitang.com/uploads/item/201405/31/20140531174431_KPuf2.thumb.700_0.jpeg",
       @"http://img5.duitang.com/uploads/item/201405/31/20140531174207_hH5u4.thumb.700_0.jpeg"
       ];
    autoDisplayScrollView.imageHolder=[UIImage imageNamed:@"bg"];
    autoDisplayScrollView.interval=5;
    autoDisplayScrollView.duration=2;
//    autoDisplayScrollView.AutoScrollDirection=LBScrollDirectionLeft;
    [self.view addSubview:autoDisplayScrollView];
    
}

- (void)imageClickedWithIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}

@end
