//
//  FSJTongjiViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/17.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJTongjiViewController.h"

@interface FSJTongjiViewController ()<UIWebViewDelegate>{

    UIWebView *myWeb;
    NSString *userName;
}

@end

@implementation FSJTongjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWeb];
    [self createUI];
    [SVProgressHUD showInfoWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeGradient];
}
- (void)createWeb{
    [myWeb removeFromSuperview];
    myWeb = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH)];
    myWeb.delegate = self;
    userName = [[EGOCache globalCache]stringForKey:@"userId"];
    NSString *urlStr =  BaseTongjiurl(userName);
    NSURL *url = [[NSURL alloc] initWithString:urlStr];
    myWeb.scalesPageToFit = YES;
    myWeb.scrollView.contentSize = CGSizeMake(WIDTH, HEIGH*1.5);
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [myWeb loadRequest:[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0]];
    [self.view addSubview:myWeb];
}
- (void)createUI{
    self.title = @"统计";
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item1;
}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       [SVProgressHUD dismiss];
    });
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [SVProgressHUD dismiss];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{

    [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
    [self createUI];
}
@end
