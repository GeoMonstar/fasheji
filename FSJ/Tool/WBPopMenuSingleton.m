//
//  WBPopMenuSingleton.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuSingleton.h"
#import "WBPopMenuView.h"

@interface WBPopMenuSingleton ()
@property (nonatomic, strong) WBPopMenuView * popMenuView;
@end

@implementation WBPopMenuSingleton

+ (WBPopMenuSingleton *) shareManager {
    static WBPopMenuSingleton *_PopMenuSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _PopMenuSingleton = [[WBPopMenuSingleton alloc]init];
    });
    return _PopMenuSingleton;
}

- (void) showPopMenuSelecteWithFrame:(CGFloat)width
                                item:(NSArray *)item
                              action:(void (^)(NSInteger))action
                             TopView:(UIView *)topview
{
    __weak __typeof(&*self)weakSelf = self;
    if (self.popMenuView != nil) {
        [weakSelf hideMenu];
    }
    UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
    CGRect rect = CGRectMake(0, Popviewheight * 0.06 + 20, Popviewwidth, Popviewheight * 0.87 -20);
    self.popMenuView = [[WBPopMenuView alloc]initWithFrame:rect
                                             menuWidth:width
                                                 items:item
                                                action:^(NSInteger index) {
                                                    action(index);
                                                    [weakSelf hideMenu];
                                                }];
    self.popMenuView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];
    [topview addSubview:self.popMenuView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3 animations:^{
            self.popMenuView.tableView.transform = CGAffineTransformMakeTranslation(0, 0);
       
        }];
    });

}

- (void) hideMenu {
    if (self.popMenuView) {
        [UIView animateWithDuration:0.1 animations:^{
            self.popMenuView.tableView.transform = CGAffineTransformMakeTranslation(0, Popviewheight);
        } completion:^(BOOL finished) {
            //dispatch_async(dispatch_get_main_queue(), ^{
                [self.popMenuView.tableView removeFromSuperview];
                [self.popMenuView removeFromSuperview];
                self.popMenuView.tableView = nil;
                
                self.popMenuView = nil;
           // });
        }];
        
    }
    else{
        return;
    }
   
}



@end
