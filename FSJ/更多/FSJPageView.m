//
//  FSJPageView.m
//  FSJ
//
//  Created by Monstar on 2017/4/7.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJPageView.h"
@interface FSJPageView()<UIScrollViewDelegate>{

    UIScrollView *mainScroView;
    UIPageControl *pageCtrl;
}

@end
@implementation FSJPageView

- (instancetype)initWithFrame:(CGRect)mainframe
                andLabelArray:(NSArray *)labelArrays
                 andColumnNum:(NSInteger)columnNum
                   andRownNum:(NSInteger)rowNum
                  anditemSize:(CGSize)itemSize{
    if (self = [super initWithFrame:mainframe]){
        //总页数
        NSInteger  pageNum = labelArrays.count/(columnNum*rowNum)+1;
        mainScroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainframe.size.width, mainframe.size.height)];
        [mainScroView setContentSize:CGSizeMake(mainframe.size.width * pageNum, mainframe.size.height)];
        mainScroView.backgroundColor = SystemWhiteColor;
        mainScroView.pagingEnabled = YES;
        mainScroView.delegate = self;
        mainScroView.showsHorizontalScrollIndicator = NO;
        for (int i = 0; i < labelArrays.count; i ++) {
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15  + i/2 * mainframe.size.width/2, 10 + i%2*(itemSize.height+5),itemSize.width, itemSize.height)];
            label.text = [NSString stringWithFormat:@"测试第%d条数据",i];
            [mainScroView addSubview:label];
        }
        pageCtrl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, mainframe.size.height-10, mainframe.size.width, 10)];
        pageCtrl.numberOfPages = pageNum;
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
    VVDLog(@"%f",offset.x / bounds.size.width);
}

- (void)pageTurn:(UIPageControl*)sender
{
    //令UIScrollView做出相应的滑动显示
    CGSize viewSize = mainScroView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage * viewSize.width, 0, viewSize.width, viewSize.height);
    [mainScroView scrollRectToVisible:rect animated:YES];
}
@end

