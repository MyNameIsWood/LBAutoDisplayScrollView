//
//  LBAutoDisplayScrollView.m
//  AutoScrollViewDemo
//
//  Created by aios on 15/8/31.
//  Copyright (c) 2015年 BlueMobi. All rights reserved.
//

#import "LBAutoDisplayScrollView.h"
#import "UIImageView+WebCache.h"
#define Width  self.frame.size.width
#define Height self.frame.size.height
@implementation LBAutoDisplayScrollView
{
    __weak UIScrollView* _scrollView;
    NSTimer* _timer;
}

// 从xib初始化 走这个方法
- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self=[super initWithCoder:aDecoder]) {
        //初始化并添加一个scrollView
        UIScrollView* scrollView =[[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.delegate=self;
        _scrollView=scrollView;
        [self addSubview:_scrollView];
        
        //创建并设置PageControl
        UIPageControl* pageControl= [[UIPageControl alloc]init];
        pageControl.center=CGPointMake(0.5*Width, 0.9*Height);
        pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        pageControl.currentPage=0;
        
        _pageControl=pageControl;
        [self addSubview:pageControl];
        
        //默认的方向是右
        _AutoScrollDirection=LBScrollDirectionRight;
        
    }
    return self;
 }

// 手码初始化 走这个方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        //初始化并添加一个scrollView
        UIScrollView* scrollView =[[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.delegate=self;
        _scrollView=scrollView;
        [self addSubview:_scrollView];
        
        //创建并设置PageControl
        UIPageControl* pageControl= [[UIPageControl alloc]init];
        pageControl.center=CGPointMake(0.5*Width, 0.9*Height);
        pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        pageControl.currentPage=0;
        
        _pageControl=pageControl;
        [self addSubview:pageControl];
        
        //默认的方向是右
        _AutoScrollDirection=LBScrollDirectionRight;
    }
    return self;
}

- (void)setInterval:(NSTimeInterval)interval {
    _interval=interval;
    //设置一个定时器
    NSTimer* timer=[NSTimer timerWithTimeInterval:interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    _timer=timer;
}

//NStimer触发的方法
- (void)autoScroll {
    
    if (_scrollView.isDragging) {
        return;
    }
    
    if (_AutoScrollDirection==LBScrollDirectionRight) {
        CGPoint point=_scrollView.contentOffset;
        [UIView animateWithDuration:_duration animations:^{
            [_scrollView setContentOffset:CGPointMake(point.x+Width, 0)];
        } completion:^(BOOL finished) {
            [self loop];
        }];
                
    }else {
        CGPoint point=_scrollView.contentOffset;
        [UIView animateWithDuration:_duration animations:^{
            [_scrollView setContentOffset:CGPointMake(point.x-Width, 0)];
        } completion:^(BOOL finished) {
            [self loop];
        }];
        
    }
}

//本地图片
- (void)setImageNames:(NSArray *)imageNames {
    _imageNames=imageNames;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake((imageNames.count+2)*Width, Height);
    _scrollView.contentOffset=CGPointMake(Width, 0);
    
    //创建imageView 创建并添加手势
    [imageNames enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        //创建imageView
        UIImageView* imageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:obj]];
        imageView.userInteractionEnabled=YES;
        imageView.frame=CGRectMake((idx+1)*Width, 0, Width, Height);
        imageView.tag=idx;
        [_scrollView addSubview:imageView];
        
        //创建并添加手势
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        
    }];

    
    //前后各贴两张图
    UIImageView* imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    
    imageView.image=[UIImage imageNamed:[imageNames lastObject]];
    
    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake((imageNames.count+1)*Width, 0, Width, Height)];
    imageView1.image=[UIImage imageNamed:[imageNames firstObject]];

    
    [_scrollView addSubview:imageView];
    [_scrollView addSubview:imageView1];
    
    //设置其余属性
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    //设置PageControl的属性
    _pageControl.numberOfPages=imageNames.count;
}

//网络图片
- (void)setImageURLs:(NSArray *)imageURLs {
    _imageURLs=imageURLs;
    //设置contentSize
    _scrollView.contentSize=CGSizeMake((imageURLs.count+2)*Width, Height);
    _scrollView.contentOffset=CGPointMake(Width, 0);
    
    
    //前后各贴两张图
    UIImageView* imageView1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    
    UIImageView* imageView2=[[UIImageView alloc]initWithFrame:CGRectMake((imageURLs.count+1)*Width, 0, Width, Height)];
    
    imageView1.image=_imageHolder;
    imageView2.image=_imageHolder;
    
    [_scrollView addSubview:imageView1];
    [_scrollView addSubview:imageView2];
    
    //创建imageView 创建并添加手势
    [imageURLs  enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        //创建imageView
        UIImageView* imageView=[[UIImageView alloc]init];
        imageView.frame=CGRectMake((idx+1)*Width, 0, Width, Height);
        imageView.tag=idx;
        imageView.userInteractionEnabled=YES;
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj]
                     placeholderImage:_imageHolder
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                if (idx==0) {
                                    imageView2.image=image;
                                }
                                if (idx==imageURLs.count-1) {
                                    imageView1.image=image;
                                }
                     }];
        [_scrollView addSubview:imageView];
        
        //创建并添加手势
        UITapGestureRecognizer* tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewClicked:)];
        [imageView addGestureRecognizer:tap];
        
    }];
    
    //设置其余属性
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    //设置PageControl的属性
    _pageControl.numberOfPages=imageURLs.count;
}

- (void)imageViewClicked:(UIGestureRecognizer*)sender {
    
    [_delegate imageClickedWithIndex:sender.view.tag];
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
    }
}


#pragma mark - UIScrollViewDelegate


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loop];
}


//操作pageControl 和 控制循环 设置contentOffset
- (void)loop {
    float page = _scrollView.contentOffset.x/Width;
    
    NSUInteger count;
    if (_imageNames.count==0) {
        count=_imageURLs.count;
    }else {
        count=_imageNames.count;
    }
    
    if (page==count+1) {//最后一张
        
        [_scrollView setContentOffset:CGPointMake(Width, 0) animated:NO];
        
        
        _pageControl.currentPage=0;
        
    }else if (page==0) {//最前一张
        
        [_scrollView setContentOffset:CGPointMake(count*Width, 0) animated:NO];
        
        _pageControl.currentPage=count-1;
        
    }else {//中间张
        _pageControl.currentPage=page-1;
    }
}

@end
