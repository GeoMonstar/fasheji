//
//  WBPopMenuSingleton.m
//  QQ_PopMenu_Demo
//
//  Created by Transuner on 16/3/17.
//  Copyright © 2016年 吴冰. All rights reserved.
//

#import "WBPopMenuSingleton.h"
#import "WBPopMenuView.h"

@interface WBPopMenuSingleton (){
    UITapGestureRecognizer *singleTap;
}
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
                               alpha:(double)num
{
    __weak __typeof(&*self)weakSelf = self;
    if (self.popMenuView != nil) {
        [weakSelf hideMenu];
    }
    //UIWindow * window = [[[UIApplication sharedApplication] windows] firstObject];
   // CGRect rect = CGRectMake(0, Popviewheight * 0.06 + 20, Popviewwidth, Popviewheight * 0.87 -20);
    CGRect rect = CGRectMake(0, 0, Popviewwidth, Popviewheight);
    self.popMenuView = [[WBPopMenuView alloc]initWithFrame:rect
                                             menuWidth:width
                                                 items:item
                                                action:^(NSInteger index) {
                                                    action(index);
                                                    [weakSelf hideMenu];
                                                }];
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    //[singleTap requireGestureRecognizerToFail:doubleTap];
    singleTap.numberOfTapsRequired = 2;
    [self.popMenuView addGestureRecognizer:singleTap];
    self.popMenuView.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:num];
    [topview addSubview:self.popMenuView];
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.32 animations:^{
           self.popMenuView.tableView.transform = CGAffineTransformMakeTranslation(0, 0);
           // self.popMenuView.tableView.transform = CGAffineTransformMakeScale(1, 1);
            
            //self.popMenuView.tableView.transform = CGAffineTransformScale(self.popMenuView.tableView.transform, 1, 1);
        }];
    });
}
- (void)handleSingleTap:(UIGestureRecognizer *)pan{
    [[WBPopMenuSingleton shareManager]hideMenu];
}
- (void) hideMenu {
    if (self.popMenuView) {
        [UIView animateWithDuration:0.1 animations:^{
            self.popMenuView.tableView.transform = CGAffineTransformMakeTranslation(0, Popviewheight);
            
        } completion:^(BOOL finished) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.popMenuView.tableView removeFromSuperview];
                [self.popMenuView removeFromSuperview];
                self.popMenuView.tableView = nil;
                self.popMenuView = nil;
           });
        }];
        
    }
    else{
        return;
    }
   
}



@end
