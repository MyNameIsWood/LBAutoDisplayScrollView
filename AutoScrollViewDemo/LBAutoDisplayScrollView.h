//
//  LBAutoDisplayScrollView.h
//  AutoScrollViewDemo
//
//  Created by aios on 15/8/31.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    LBScrollDirectionRight,
    LBScrollDirectionLeft,
} LBScrollDirection;


@protocol LBAutoDisplayScrollViewDelegate <NSObject>
@required
/**
 *  处理点击时间
 *
 *  @param index 从0开始 图片的下表
 */
- (void)imageClickedWithIndex:(NSInteger)index;

@end


@interface LBAutoDisplayScrollView : UIView<UIScrollViewDelegate>
/** 设置图片名字数值 可以设定此控件显示内容 */
@property (nonatomic, strong) NSArray* imageNames;
/** 图片自动滚动的方向 默认是LBScrollDirectionRight */
@property (nonatomic, assign) LBScrollDirection AutoScrollDirection;
/** 间隔时间 多长时间滚动一张 不设置即为静态展示 */
@property (nonatomic, assign) NSTimeInterval interval;
/** 滚动动画需要的时间 */
@property (nonatomic, assign) NSTimeInterval duration;
/** 把pageControl暴露给你 可以给你自己定义 */
@property (nonatomic, weak  ) UIPageControl* pageControl;
/** 读取网络中图片 */
@property (nonatomic, strong) NSArray* imageURLs;
/** 占位图片 */
@property (nonatomic, strong) UIImage* imageHolder;
/** 代理 处理回调的点击时间 */
@property (nonatomic, weak)   id<LBAutoDisplayScrollViewDelegate> delegate;
@end
