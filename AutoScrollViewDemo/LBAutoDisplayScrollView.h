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
#pragma mark - 设置图片的属性
/** 设置图片名字数值 可以设定此控件显示内容 */
@property (nonatomic, strong) NSArray* imageNames;
/** 读取网络中图片 */
@property (nonatomic, strong) NSArray* imageURLs;
/** 占位图片 */
@property (nonatomic, strong) UIImage* imageHolder;

#pragma mark - 设置滚动的属性
/** 图片自动滚动的方向 默认是LBScrollDirectionRight */
@property (nonatomic, assign) LBScrollDirection AutoScrollDirection;
/** 间隔时间 多长时间滚动一张 不设置即为静态展示 */
@property (nonatomic, assign) NSTimeInterval interval;
/** 滚动动画需要的时间 */
@property (nonatomic, assign) NSTimeInterval duration;

#pragma mark - 设置指示器的属性
/** 设置pageControl的位置 */
@property (nonatomic, assign) CGPoint pageControlCenter;
/** 设置pageControl的currentPageIndicatorTintColor属性 */
@property (nonatomic, strong) UIColor* currentPageIndicatorTintColor;

#pragma mark - 设置文字的属性
/** 图片下的文字 字符串数组 */
@property (nonatomic, strong) NSArray* texts;
/** 文字的字体 默认是系统字体13号 */
@property (nonatomic, strong) UIFont*  font;
/** 文字的颜色 默认是白色的 */
@property (nonatomic, strong) UIColor* textColor;
/** 标签背景的颜色 默认是黑色的 0.5的透明度 */
@property (nonatomic, strong) UIColor* textBackgroundColor;


/** 代理 处理回调的点击时间 */
@property (nonatomic, weak)   id<LBAutoDisplayScrollViewDelegate> delegate;
@end





























