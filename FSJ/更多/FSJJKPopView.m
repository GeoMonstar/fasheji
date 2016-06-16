//
//  FSJJKPopView.m
//  FSJ
//
//  Created by Monstar on 16/6/6.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJJKPopView.h"
#import "FSJJKPopBtn.h"
@interface FSJJKPopView()<UIGestureRecognizerDelegate>{
    UIView *bgview;
    UITapGestureRecognizer *singleTap;
}

@end
@implementation FSJJKPopView


-  (instancetype)initPopWith:(CGRect)frame andDataSource:(NSArray *)data{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        singleTap.delegate = self;
        singleTap.cancelsTouchesInView = NO;
        singleTap.delaysTouchesEnded = NO;
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        bgview = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-80,10 , 160,data.count *40)];
        bgview.backgroundColor = SystemWhiteColor;
        [self addSubview:bgview];
        bgview.layer.cornerRadius = 10;
        bgview.layer.masksToBounds = YES;
        bgview.layer.borderColor = SystemBlueColor.CGColor;
        bgview.layer.borderWidth = 1;
        
        for (int i = 0; i<data.count; i++) {
            FSJJKPopBtn *button =  [FSJJKPopBtn buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(0, 40*i, 160, 40);
            [button setTitle:data[i] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:@"gou"] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(clicked:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [button setTitleColor:SystemBlueColor forState:UIControlStateSelected];
            button.titleLabel.font = [UIFont systemFontOfSize:14];
            button.tag = 500+i;
            [bgview addSubview:button];
        }
    }
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(self.frame.size.width*0.5-11, 10, 22, 2)];
    coverView.backgroundColor = SystemWhiteColor;
    coverView.userInteractionEnabled = NO;
    
    [self addSubview:coverView];
    
    return self;
}
- (void)clicked:(UIButton *)button{
    
    button.selected = YES;
    for (UIButton *btn in bgview.subviews) {
        btn.selected = NO;
        button.selected = YES;

        
    }
    if (self.selectIndex) {
        self.selectIndex(button.tag);
    }
    [self hiddn];
}
- (void)handleSingleTap:(UIGestureRecognizer *)pan{
    
    if (self.popshow) {
        self.popshow(NO);
    }
    [self hiddn];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 判断是不是UIButton的类
    if ([touch.view isKindOfClass:[UIButton class]] )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
- (void)hiddn{
    [self removeFromSuperview];
}

#pragma mark 绘制三角形
- (void)drawRect:(CGRect)rect

{
    
    
    //    [colors[serie] setFill];
    // 设置背景色
    //[[UIColor whiteColor] set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    
    CGContextBeginPath(context);//标记
    
    CGContextMoveToPoint(context,
                         self.frame.size.width*0.5 + 10 , 10);//设置起点
    
    CGContextAddLineToPoint(context,
                              self.frame.size.width*0.5,  2);
    
    CGContextAddLineToPoint(context,
                              self.frame.size.width*0.5-10, 10);
    
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    
    [[UIColor whiteColor] setFill];  //设置填充色
    
    [[UIColor whiteColor] setStroke]; //设置边框颜色
    
    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path
}
@end
