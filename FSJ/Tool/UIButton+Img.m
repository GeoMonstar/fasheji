//
//  UIButton+Img.m
//  FSJ
//
//  Created by Monstar on 16/4/15.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "UIButton+Img.h"
#import <objc/runtime.h>
@implementation UIButton (Img)

- (UIImageView *)btnimagView{

    return objc_getAssociatedObject(self, @"img");
}

- (void)setBtnimagView:(UIImageView *)btnimagView{
     objc_setAssociatedObject(self, @"img", btnimagView, OBJC_ASSOCIATION_COPY);

}
@end
