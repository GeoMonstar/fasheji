//
//  FSJJKPopBtn.m
//  FSJ
//
//  Created by Monstar on 16/6/6.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJJKPopBtn.h"

@implementation FSJJKPopBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rectBtn = CGRectZero;
    rectBtn = CGRectMake(130,10,20, 15);
    
    return rectBtn;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectZero;
    rectTitle =  CGRectMake(10, 0, 130, 40);
    return rectTitle;
}

@end
