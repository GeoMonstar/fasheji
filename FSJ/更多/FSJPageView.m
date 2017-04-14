//
//  FSJPageView.m
//  FSJ
//
//  Created by Monstar on 2017/4/7.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJPageView.h"
#import <objc/message.h>

@interface FSJPageView()<UIScrollViewDelegate>{

    UIScrollView *mainScroView;
    UIPageControl *pageCtrl;
    NSInteger pageNum;
    NSInteger maxNum;
}
@property (nonatomic, assign) CFRunLoopTimerRef timer;

@end
@implementation FSJPageView

- (instancetype)initWithFrame:(CGRect)mainframe
                andLabelArray:(NSArray *)labelArrays
               andStatusArray:(NSArray *)statusArrays
                 andColumnNum:(NSInteger)columnNum
                   andRownNum:(NSInteger)rowNum
                  anditemSize:(CGSize)itemSize
                    andiamgeX:(CGFloat)imageX{
    if (self = [super initWithFrame:mainframe]){
        //总页数
        self.timer = nil;
        pageNum= 0;
        
        if (labelArrays.count/(columnNum*rowNum)>1 && labelArrays.count%(columnNum*rowNum)>0) {
            maxNum = labelArrays.count/(columnNum*rowNum)+1;
        }else{
            maxNum = labelArrays.count/(columnNum*rowNum);
        }
        
        mainScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainframe.size.width, mainframe.size.height)];
        [mainScroView setContentSize:CGSizeMake(mainframe.size.width * maxNum, mainframe.size.height)];
        mainScroView.backgroundColor = SystemWhiteColor;
        mainScroView.pagingEnabled = YES;
        mainScroView.delegate = self;
        mainScroView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < labelArrays.count; i ++) {
            
            UILabel *pagelabel = [[UILabel alloc]initWithFrame:CGRectMake(15  + i/rowNum * mainframe.size.width/2, 10 + i%rowNum*(itemSize.height+5),itemSize.width, itemSize.height)];
            

            if ([statusArrays[i] isEqualToString:@"3"] ) {
                
            }else{
                UIImage *statusimage = [UIImage imageWithColor:[statusArrays[i] isEqualToString:@"0"]?SystemGreenColor:[UIColor redColor]];
                UIImageView *statusimageView = [[UIImageView alloc]initWithFrame:CGRectMake(pagelabel.frame.origin.x + imageX,pagelabel.frame.origin.y +5,itemSize.height-10, itemSize.height-10)];
                statusimageView.image = statusimage;
                statusimageView.layer.cornerRadius = (itemSize.height-10)/2;
                statusimageView.clipsToBounds = YES;
                [mainScroView addSubview:statusimageView];
            }
            pagelabel.text = labelArrays[i];
            pagelabel.font = [UIFont systemFontOfSize:14];
            [mainScroView addSubview:pagelabel];
        }
        pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, mainframe.size.height-10, mainframe.size.width, 10)];
        pageCtrl.numberOfPages = maxNum;
        pageCtrl.currentPage = 0;
        pageCtrl.pageIndicatorTintColor = SystemLightGrayColor;
        pageCtrl.currentPageIndicatorTintColor = SystemBlueColor;
        [pageCtrl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:mainScroView];
        [self addSubview:pageCtrl];
    }
    return self;



}

- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //更新UIPageControl的当前页
    CGPoint offset = scrollView.contentOffset;
    CGRect bounds = scrollView.frame;
    [pageCtrl setCurrentPage:offset.x / bounds.size.width];
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = mainScroView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [mainScroView scrollRectToVisible:rect animated:YES];
}

- (void)startTimer{
    [self configTimer];
}
- (void)pauseTimer{
    if (self.timer) {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
    }
}
- (void)configTimer {
    
    if (self.timer) {
        CFRunLoopTimerInvalidate(self.timer);
        CFRunLoopRemoveTimer(CFRunLoopGetCurrent(), self.timer, kCFRunLoopCommonModes);
    }
    
    THWeakSelf(weakself);
    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, CFAbsoluteTimeGetCurrent() + self.timeInterval, self.timeInterval, 0, 0, ^(CFRunLoopTimerRef timer) {
        [weakself autoScroll];
    });
    self.timer = timer;
    CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, kCFRunLoopCommonModes);
}
- (void)autoScroll{
    pageNum++;
    
    //更新UIPageControl的当前页
    if (pageNum < maxNum) {
        mainScroView.contentOffset = CGPointMake(pageNum*WIDTH, 0);
    }else{
        mainScroView.contentOffset = CGPointMake(0, 0);
        pageNum=0;
    }

     [mainScroView setContentOffset:mainScroView.contentOffset animated:YES];
    [pageCtrl setCurrentPage:mainScroView.contentOffset.x / mainScroView.bounds.size.width];
}

- (void)dealloc{
    [self pauseTimer];
}
@end

