//
//  FSJTabbarViewController.m
//  FSJ
//
//  Created by Monstar on 16/4/13.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJTabbarViewController.h"
#import "FSJHomeViewController.h"
@interface FSJTabbarViewController (){
    UIView *tabbarBg;
    NSMutableArray *btnArr;
   
}
@property (nonatomic, strong)FSJHomeViewController *firstVC;

@property (nonatomic ,strong) UIViewController *currentVC;
@end

@implementation FSJTabbarViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    btnArr = @[].mutableCopy;
    [self addController];
    [self customTabbar];
    [self.view addSubview:self.firstVC.view];
    self.currentVC = self.firstVC;
}
- (void)customTabbar{
    tabbarBg = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGH *0.93, WIDTH,  HEIGH *0.07)];
    tabbarBg.backgroundColor = SystemLightGrayColor;
    self.view.backgroundColor = SystemWhiteColor;
    NSArray *norimg = @[@"ditu",@"jiankong",@"shebei",@"tbgaojing"];
    NSArray *seletedimg = @[@"ditu1",@"jiankong1",@"shebei1",@"tbgaojing1"];
    NSArray *titleArr  = @[@"地图",@"监控",@"设备",@"告警"];
    for (int i = 0; i<4; i ++) {
       UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i * WIDTH/4+WIDTH*0.08 , HEIGH* 0.01, WIDTH/9.8, HEIGH *0.03);
        btn.enabled =YES;
        [btn setBackgroundImage:[UIImage imageNamed:norimg[i]] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:seletedimg[i]] forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setFont:[UIFont systemFontOfSize: 10.0]];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(HEIGH *0.055, 0, 0, 0)];
        [btn setTitleColor:SystemGrayColor forState:UIControlStateNormal];
        [btn setTitleColor:SystemBlueColor forState:UIControlStateSelected];
        btn.contentMode = UIViewContentModeCenter;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 600 + i;
        [btnArr addObject:btn];
        [tabbarBg addSubview:btn];
    }
    for (UIButton *btn in btnArr) {
        if (btn.tag == 600) {
            btn.selected = YES;
        }
    }
    [self.view addSubview:tabbarBg];
}
- (void)btnClicked:(UIButton *)sender{
    NSLog(@"clicked");
    if (sender.selected == YES) {
        return;
    }
    else{
        for (UIButton *btn in btnArr) {
            btn.selected =NO;
        }
        sender.selected = YES;
        switch (sender.tag - 600) {
            case 0:
                [self replaceController:self.currentVC newController:self.firstVC];
                break;
                
            default:
                break;
        }
    }
}
- (void)addController{
    self.firstVC = [[FSJHomeViewController alloc]init];
    [self.firstVC.view setFrame:CGRectMake(0, 0, WIDTH, HEIGH)];

}
- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    /**
     *
     *  transitionFromViewController:toViewController:duration:options:animations:completion:
     *  fromViewController	  当前显示在父视图控制器中的子视图控制器
     *  toViewController		将要显示的姿势图控制器
     *  duration				动画时间(这个属性,old friend 了 O(∩_∩)O)
     *  options				 动画效果(渐变,从下往上等等,具体查看API)
     *  animations			  转换过程中得动画
     *  completion			  转换完成
     */
    
    [self addChildViewController:newController];
    [self transitionFromViewController:oldController toViewController:newController duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:^(BOOL finished) {
        
        if (finished) {
            [newController didMoveToParentViewController:self];
            [oldController willMoveToParentViewController:nil];
            [oldController removeFromParentViewController];
            self.currentVC = newController;
            
        }else{
            self.currentVC = oldController;
            
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
