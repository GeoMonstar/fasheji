//
//  FSJBaseViewController.m
//  FSJ
//
//  Created by Monstar on 16/5/6.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJBaseViewController.h"

@interface FSJBaseViewController ()

@end

@implementation FSJBaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(networkChanged:)
                                                 name:kRealReachabilityChangedNotification
                                               object:nil];
}
- (void)networkChanged:(NSNotification *)notification
{
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH/2-WIDTH*0.35, HEIGH*0.75, WIDTH*0.7, 35)];
    alertLabel.layer.cornerRadius = 5;
    alertLabel.layer.masksToBounds = YES;
    alertLabel.backgroundColor = [UIColor grayColor];
    alertLabel.textColor = [UIColor whiteColor];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
        alertLabel.text = @"网络连接断开，请检查网络";
    }
    
    if (status == RealStatusViaWiFi)
    {
        alertLabel.text = @"您正使用wifi网络";
    }
    
    if (status == RealStatusViaWWAN)
    {
        WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
        
        if (status == RealStatusViaWWAN)
        {
            if (accessType == WWANType2G)
            {
                alertLabel.text = @"您正在使用2G网络";
            }
            else if (accessType == WWANType3G)
            {
                alertLabel.text = @"您正在使用3G网络";
            }
            else if (accessType == WWANType4G)
            {
                alertLabel.text = @"您正在使用4G网络";
            }
            else
            {
                alertLabel.text = @"Unknown RealReachability WWAN Status, might be iOS6";
            }
        }
        
        //   self.flagLabel.text = @"Network WWAN! In charge!";
    }
    [self.view addSubview:alertLabel];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alertLabel removeFromSuperview];
    });
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
