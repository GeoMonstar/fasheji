//
//  FSJPopHeadview.m
//  FSJ
//
//  Created by Monstar on 16/5/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJPopHeadview.h"

@implementation FSJPopHeadview

- (instancetype) init {
    if (self = [super init]) {
        
        
    }
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame and:(NSString *)name{
    if (self = [super initWithFrame:frame]) {
        
        CGRect rect = frame;
        rect.size.height = rect.size.height *0.85;
        UIView *bgview = [[UIView alloc]initWithFrame:rect];
        bgview.backgroundColor = SystemLightBlueColor;
        bgview.layer.cornerRadius = rect.size.height/4;
        bgview.layer.borderWidth = 0;
        CGRect rect1 = rect;
        rect1.origin.x =  rect1.origin.x + rect1.size.width *0.1;
        rect1.size.width = rect1.size.width *0.8;
        //rect1.size.height = rect1.size.height *0.8;
        UILabel *label = [[UILabel alloc]initWithFrame:rect1];
        label.text = name;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:13];
        label.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:13];
        label.textColor = SystemWhiteColor;
        label.layer.borderWidth = 0;
        [bgview addSubview:label];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:bgview];
        
    }
    return self;
    
}

- (void)drawRect:(CGRect)rect

{
    // 设置背景色
    [[UIColor whiteColor] set];
    //拿到当前视图准备好的画板

    CGContextRef  context = UIGraphicsGetCurrentContext();

    //利用path进行绘制三角形

    CGContextBeginPath(context);//标记
   // CGFloat location = [UIScreen mainScreen].bounds.size.width-55;
    CGFloat location = self.frame.origin.x + self.frame.size.width/2 +5;
    CGContextMoveToPoint(context,
                         location , self.frame.origin.y +self.frame.size.height *0.85);//设置起点

    CGContextAddLineToPoint(context,
                            location -5 ,  self.frame.origin.y +self.frame.size.height);

    CGContextAddLineToPoint(context,
                            location -10, self.frame.origin.y +self.frame.size.height *0.85);

    CGContextClosePath(context);//路径结束标志，不写默认封闭

    [SystemLightBlueColor setFill];  //设置填充色

    [SystemLightBlueColor setStroke]; //设置边框颜色

    CGContextDrawPath(context,
                      kCGPathFillStroke);//绘制路径path

}

@end
