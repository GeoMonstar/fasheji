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

    rectBtn =  CGRectMake(Popviewwidth/8-10, Popviewheight*0.008, 25, 25);

    return rectBtn;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectZero;
    
    if (iPhone6plus) {
        rectTitle = CGRectMake(Popviewwidth/8-10, Popviewheight*0.01 +Popviewheight*0.025,30, 30);
    }
    else{
      rectTitle = CGRectMake(Popviewwidth/8-10, Popviewheight*0.008 +Popviewheight*0.03,30, 25);
    }
    return rectTitle;
}
@end
