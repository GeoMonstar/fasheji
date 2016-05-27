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
    if (iPhone4) {
        rectBtn =  CGRectMake(Popviewwidth/8-10, Popviewheight*0.005, 19, 19);
    }
   else if (iPhone5) {
         rectBtn =  CGRectMake(Popviewwidth/8-10, Popviewheight*0.007, 23, 23);
    }
    else{
       rectBtn =  CGRectMake(Popviewwidth/8-10, Popviewheight*0.008, 25, 25);
    }
   
    
    return rectBtn;
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rectTitle = CGRectZero;
    
    if (iPhone6plus) {
        rectTitle = CGRectMake(Popviewwidth/8-10, Popviewheight*0.01 +Popviewheight*0.025,30, 30);
    }
    else if (iPhone5){
     rectTitle = CGRectMake(Popviewwidth/8-12, Popviewheight*0.008 +Popviewheight*0.03,30, 25);
    }
    else if(iPhone4){
     rectTitle = CGRectMake(Popviewwidth/8-6, Popviewheight*0.006 +Popviewheight*0.025,30, 25);
    }
    else{
      rectTitle = CGRectMake(Popviewwidth/8-10, Popviewheight*0.008 +Popviewheight*0.03,30, 25);
    }
    return rectTitle;
}
@end
