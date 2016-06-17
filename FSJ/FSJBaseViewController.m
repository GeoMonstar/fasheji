//
//  FSJBaseViewController.m
//  FSJ
//
//  Created by Monstar on 16/5/6.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJBaseViewController.h"
#import "FSJLogInViewController.h"
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

    RealReachability   *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
        [MBProgressHUD showSuccess:@"网络连接断开，请检查网络"];
    }
    
    if (status == RealStatusViaWiFi)
    {
        [MBProgressHUD showSuccess:@"您正使用wifi网络"];
    }
    
    if (status == RealStatusViaWWAN)
    {
        WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
        
        if (status == RealStatusViaWWAN)
        {
            if (accessType == WWANType2G)
            {
                [MBProgressHUD showSuccess:@"您正在使用2G网络"];
               
            }
            else if (accessType == WWANType3G)
            {
                [MBProgressHUD showSuccess:@"您正在使用3G网络"];
              
            }
            else if (accessType == WWANType4G)
            {
                [MBProgressHUD showSuccess:@"您正在使用4G网络"];
            }
            else
            {
                [MBProgressHUD showSuccess:@"Unknown RealReachability WWAN Status, might be iOS6"];
            }
        }
        
        //   self.flagLabel.text = @"Network WWAN! In charge!";
    }

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
- (void)pop{
    FSJLogInViewController *vc = [[FSJLogInViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
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
