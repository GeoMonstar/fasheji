//
//  FSJPageView.h
//  FSJ
//
//  Created by Monstar on 2017/4/7.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSJPageView : UIView
- (instancetype)initWithFrame:(CGRect)mainframe
                andLabelArray:(NSArray *)labelArrays
                 andColumnNum:(NSInteger)columnNum
                   andRownNum:(NSInteger)rowNum
                  anditemSize:(CGSize)itemSize;
@end
