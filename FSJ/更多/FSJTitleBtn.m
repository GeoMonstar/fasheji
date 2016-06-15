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
    rectBtn = CGRectMake(self.BtnX+self.Btnwidth-2,15,15, 10);
    
    return rectBtn;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectZero;
    
    rectTitle =  CGRectMake(self.BtnX, 0, self.Btnwidth, 40);
    return rectTitle;
}
@end
