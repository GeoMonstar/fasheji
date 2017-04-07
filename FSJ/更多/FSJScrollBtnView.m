//
//  FSJScrollBtnView.m
//  FSJ
//
//  Created by Monstar on 2017/4/5.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJScrollBtnView.h"
@interface FSJScrollBtnView(){

    NSMutableArray  *btnArr;
    NSMutableArray  *viewArr;
    NSInteger aviewTag;
   
    NSInteger currentIndex;
}
@property (nonatomic, assign)NSInteger selectedIndex;
@end
@implementation FSJScrollBtnView

- (instancetype)initWithFrame:(CGRect)mainframe
                 andItemFrame:(CGRect)itemFrame
                andtitleColor:(UIColor *)titlecolor
             andselTitleColor:(UIColor *)selTitlecolor
                   andbgColor:(UIColor *)bgColor
                andselBgColor:(UIColor *)selBgColor
                   andviewTag:(NSInteger)viewTag
                andtitleArray:(NSArray *)titleArray
             andViewDirection:(NSInteger)direction{

    if (self = [super initWithFrame:mainframe]){
        aviewTag = viewTag;
        btnArr = @[].mutableCopy;
        viewArr = @[].mutableCopy;
        
        UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:mainframe];
        
        if (direction == 0) {
             scroView.contentSize = CGSizeMake(mainframe.size.width/4*titleArray.count, mainframe.size.height);
        }else{
             scroView.contentSize = CGSizeMake(mainframe.size.width, mainframe.size.height/4*titleArray.count);
        }
       
       // scroView.backgroundColor = SystemLightGrayColor;
        scroView.scrollEnabled = YES;
        scroView.backgroundColor = SystemWhiteColor;
      
        for (int i = 0; i < titleArray.count; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            //根据方向布局按钮
            if (direction == 0) {
                btn.frame = CGRectMake( mainframe.size.width/4 *i, 0, mainframe.size.width/4, mainframe.size.height);
            }else{
                btn.frame = CGRectMake( 0, mainframe.size.height/4 *i, mainframe.size.width, mainframe.size.height/4);
            }
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            
            [btn setTitle:[NSString stringWithFormat:@"%@", titleArray[i]] forState:UIControlStateNormal];
            
            [btn setTitleColor:titlecolor forState:UIControlStateNormal];
            [btn setTitleColor:selTitlecolor  forState:UIControlStateSelected];
            [btn setBackgroundImage:[UIImage imageWithColor:bgColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageWithColor:selBgColor] forState:UIControlStateSelected];
            btn.tag  = 600 + i +1;
            [btn addTarget:self action:@selector(changIndex:) forControlEvents:UIControlEventTouchUpInside];
            
            [btnArr addObject:btn];
            if (btn.tag == 601) {
                btn.selected =YES;
            }
            [scroView addSubview:btn];
        }
        self.selectedIndex = 1;
        
        self.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius  = 1;
        [self addSubview:scroView];
       
    }
     return self;
}

- (void)changIndex:(UIButton *)sender{
    
    if (sender.tag-600 == self.selectedIndex) {
        return;
    }
    else{
         self.selectedIndex = sender.tag -600;
        for (UIButton *btn in btnArr) {
            
            if (btn.tag - 600  == self.selectedIndex) {
                btn.selected = YES;
            }else{
                btn.selected = NO;
            }
        }
       // VVDLog(@"%d", self.selectedIndex);
        [self reloadInputViews];
        if (self.delegate && [self.delegate respondsToSelector:@selector(scrollviewDidselectdWithSeletedIndex:andViewTag:)])
        {
           [self.delegate scrollviewDidselectdWithSeletedIndex:sender.tag-600 andViewTag:aviewTag];
        }
       
    }
}
- (instancetype) init {
    if (self = [super init]) {
        
    }
    return self;
}
@end
