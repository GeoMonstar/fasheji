//
//  FSJTabbarBtn.m
//  FSJ
//
//  Created by Monstar on 16/4/15.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJTabbarBtn.h"

@implementation FSJTabbarBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rectBtn = CGRectZero;

    rectBtn =  CGRectMake(Popviewwidth/8-10, Popviewheight*0.01, 20, 20);

    return rectBtn;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectZero;
    rectTitle = CGRectMake(Popviewwidth/8-10, Popviewheight*0.01 +18,30, 20);
    return rectTitle;
}
@end
