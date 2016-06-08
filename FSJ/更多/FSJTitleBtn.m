//
//  FSJTitleBtn.m
//  FSJ
//
//  Created by Monstar on 16/6/6.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJTitleBtn.h"

@implementation FSJTitleBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rectBtn = CGRectZero;
    rectBtn = CGRectMake(130,15,15, 10);
    
    return rectBtn;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectZero;
    rectTitle =  CGRectMake(0, 0, 125, 40);
    return rectTitle;
}
@end
