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

@interface LBAutoDisplayScrollView()
@property (strong, nonatomic) UIPageControl*  pageControl;
@property (strong, nonatomic) UIScrollView*   scrollView;
@property (strong, nonatomic) NSMutableArray* imageViewArr;
@property (strong, nonatomic) NSMutableArray* labelArr;
@end

@implementation LBAutoDisplayScrollView
{
    NSTimer* _timer;
}

// 懒加载
- (NSMutableArray *)imageViewArr {
    if (_imageViewArr == nil) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

- (NSMutableArray *)labelArr {
    if (_labelArr == nil) {
        _labelArr = [NSMutableArray array];
    }
    return _labelArr;
}

// 从xib初始化 走这个方法
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self=[super initWithCoder:aDecoder]) {
//        //初始化并添加一个scrollView
//        UIScrollView* scrollView =[[UIScrollView alloc]initWithFrame:self.bounds];
//        scrollView.delegate=self;
//        self.scrollView = scrollView;
//        [self addSubview:_scrollView];
//        
//        //创建并设置PageControl
//        UIPageControl* pageControl = [[UIPageControl alloc]init];
//        pageControl.center = CGPointMake(0.5*Width, 0.9*Height);
//        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//        pageControl.currentPage = 0;
//        
//        self.pageControl = pageControl;
//        [self addSubview:pageControl];
//        
//        //默认的方向是右
//        _AutoScrollDirection=LBScrollDirectionRight;
//        
//    }
//    return self;
// }

// 手码初始化 走这个方法
- (instancetype)initWithFrame:(CGRect)frame {
    if (self=[super initWithFrame:frame]) {
        // 初始化并添加一个scrollView
        UIScrollView* scrollView =[[UIScrollView alloc]initWithFrame:self.bounds];
        scrollView.delegate=self;
        _scrollView=scrollView;
        [self addSubview:_scrollView];
        
        // 创建并设置PageControl
        UIPageControl* pageControl= [[UIPageControl alloc]init];
        pageControl.center=CGPointMake(0.5*Width, 0.9*Height);
        pageControl.currentPageIndicatorTintColor=[UIColor whiteColor];
        pageControl.currentPage=0;
        
        _pageControl=pageControl;
        [self addSubview:pageControl];
        
        // 默认的方向是右
        self.AutoScrollDirection = LBScrollDirectionRight;
        self.font = [UIFont systemFontOfSize:13];
        self.textColor = [UIColor whiteColor];
        self.textBackgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        self.textHorizontalInset = 5;
        self.textVerticalInset = 5;
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
    
    // 清除
    for (UIImageView* imageView in self.imageViewArr) {
        [imageView removeFromSuperview];
    }
    self.imageViewArr = nil;
    
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
        
        // 添加到imageView数组里去
        [self.imageViewArr addObject:imageView];
        
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
    
    // 添加到imageView数组里去
    [self.imageViewArr addObject:imageView];
    [self.imageViewArr addObject:imageView1];
    
    //设置其余属性
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    //设置PageControl的属性
    _pageControl.numberOfPages=imageNames.count;
}

//网络图片
- (void)setImageURLs:(NSArray *)imageURLs {
    _imageURLs=imageURLs;
    
    // 清除
    for (UIImageView* imageView in self.imageViewArr) {
        [imageView removeFromSuperview];
    }
    self.imageViewArr = nil;
    
    //设置contentSize
    _scrollView.contentSize=CGSizeMake((imageURLs.count+2)*Width, Height);
    _scrollView.contentOffset=CGPointMake(Width, 0);
    
    
    //前后各贴两张图 并添加进数组
    UIImageView* imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, Width, Height)];
    
    UIImageView* imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake((imageURLs.count+1)*Width, 0, Width, Height)];
    
    imageView1.image=_imageHolder;
    imageView2.image=_imageHolder;
    
    [self.imageViewArr addObject:imageView1];
    [self.imageViewArr addObject:imageView2];
    
    [_scrollView addSubview:imageView1];
    [_scrollView addSubview:imageView2];
    
    //创建imageView 创建并添加手势
    [imageURLs  enumerateObjectsUsingBlock:^(NSString* obj, NSUInteger idx, BOOL *stop) {
        //创建imageView
        UIImageView* imageView = [[UIImageView alloc]init];
        imageView.frame = CGRectMake((idx+1)*Width, 0, Width, Height);
        imageView.tag = idx;
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
        
        [self.imageViewArr addObject:imageView];
        
    }];
    
    //设置其余属性
    _scrollView.pagingEnabled=YES;
    _scrollView.showsHorizontalScrollIndicator=NO;
    
    //设置PageControl的属性
    _pageControl.numberOfPages=imageURLs.count;
}

// 给新闻图片添加标题
- (void)setTexts:(NSArray *)texts {
    _texts = texts;
    
    // 清除
    for (UIView* view in self.labelArr) {
        [view removeFromSuperview];
    }
    self.labelArr = nil;
    
    // 首先 先创建label
    for (NSString* text in texts) {
        UILabel* label = [[UILabel alloc]init];
        
        label.font = self.font;
        label.textColor = self.textColor;
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.preferredMaxLayoutWidth = Width-2*self.textHorizontalInset;
        label.text = text;
        
        UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, Height-label.intrinsicContentSize.height-2*self.textVerticalInset, Width, label.intrinsicContentSize.height+2*self.textVerticalInset)];
        labelView.backgroundColor = self.textBackgroundColor;
        label.frame = CGRectMake(self.textHorizontalInset, self.textVerticalInset, Width-2*self.textHorizontalInset, label.intrinsicContentSize.height);
        [labelView addSubview:label];
        
//        NSLog(@"label.intrinsicContentSize:%@",NSStringFromCGSize(label.intrinsicContentSize));
//        NSLog(@"label.frame:%@",NSStringFromCGRect(label.frame));
        
        
        [self.labelArr addObject:labelView];
    }
    
    // 然后 给每个imageView添加label
    for (UIImageView* imageView in self.imageViewArr) {
        int index = imageView.frame.origin.x/Width;
        if (index == 0) {
            UILabel* label = [[UILabel alloc]init];
            
            label.font = self.font;
            label.textColor = self.textColor;
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.preferredMaxLayoutWidth = Width - 2*self.textHorizontalInset;
            label.text = [texts lastObject];
            
            UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, Height-label.intrinsicContentSize.height-2*self.textVerticalInset, Width, label.intrinsicContentSize.height+2*self.textVerticalInset)];
            labelView.backgroundColor = self.textBackgroundColor;
            label.frame = CGRectMake(self.textHorizontalInset, self.textVerticalInset, Width-2*self.textHorizontalInset, label.intrinsicContentSize.height);
            [labelView addSubview:label];
            
            [self.labelArr addObject:labelView];
            [imageView addSubview:labelView];
            
        }else if (index == self.imageViewArr.count-1) {
            UILabel* label = [[UILabel alloc]init];
            
            label.font = self.font;
            label.textColor = self.textColor;
            label.backgroundColor = [UIColor clearColor];
            label.numberOfLines = 0;
            label.lineBreakMode = NSLineBreakByWordWrapping;
            label.preferredMaxLayoutWidth = Width - 2*self.textHorizontalInset;
            label.text = [texts firstObject];
            
            UIView* labelView = [[UIView alloc] initWithFrame:CGRectMake(0, Height-label.intrinsicContentSize.height-2*self.textVerticalInset, Width, label.intrinsicContentSize.height+2*self.textVerticalInset)];
            labelView.backgroundColor = self.textBackgroundColor;
            label.frame = CGRectMake(self.textHorizontalInset, self.textVerticalInset, Width-2*self.textHorizontalInset, label.intrinsicContentSize.height);
            [labelView addSubview:label];
            
            [self.labelArr addObject:labelView];
            [imageView addSubview:labelView];
        }else {
            [imageView addSubview:self.labelArr[index-1]];
        }
    }
}



- (void)imageViewClicked:(UIGestureRecognizer*)sender {
    
    [_delegate imageClickedWithIndex:sender.view.tag];
}

// pageControl位置设置方法
- (void)setPageControlCenter:(CGPoint)pageControlCenter {
    _pageControlCenter = pageControlCenter;
    [_pageControl setCenter:pageControlCenter];
    [self setNeedsLayout];
}

// pageControl设置方法
- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor {
    _pageControl.currentPageIndicatorTintColor = currentPageIndicatorTintColor;
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
