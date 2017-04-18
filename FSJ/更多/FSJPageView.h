//
//  FSJPageView.h
//  FSJ
//
//  Created by Monstar on 2017/4/7.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSJPageView : UIView

@property (nonatomic, assign) NSTimeInterval timeInterval;



- (instancetype)initWithFrame:(CGRect)mainframe
                andLabelArray:(NSArray *)labelArrays
               andStatusArray:(NSArray *)statusArrays
                 andColumnNum:(NSInteger)columnNum
                   andRownNum:(NSInteger)rowNum
                  anditemSize:(CGSize)itemSize
                    andiamgeX:(CGFloat)imageX
                  andShowPage:(BOOL)showPage;
- (void)pauseTimer;

- (void)startTimer;

@end
