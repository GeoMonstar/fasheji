//
//  UIView+LoadFromNib.m
//  FSJ
//
//  Created by Monstar on 16/3/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "UIView+LoadFromNib.h"

@implementation UIView (LoadFromNib)


+ (id)loadFromNib{
    id view = nil;
    NSString *str = NSStringFromClass([self class]);
    UIViewController *temporaryController = [[UIViewController alloc]initWithNibName:str bundle:nil];
    if (temporaryController) {
        view = temporaryController.view;
    }
    return view;
}
@end
