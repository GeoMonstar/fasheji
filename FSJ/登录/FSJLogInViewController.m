//
//  FSJLogInViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/9.
//  Copyright © 2016年 Monstar. All rights reserved.
//
#import "FSJLogInViewController.h"
#define leftMagrin  30
#define rightMagrin 30
#define viewHeight  36
#import "FSJMapViewController.h"
@interface FSJLogInViewController ()<UITextFieldDelegate>{
    UIImageView *mainImgview;
    UITextField *userName;
    UITextField *userPwd;
    UIButton *loginBtn;
    UIView *firstView;
    UIView *secondView;
    FSJUserInfo * model;
}
@end
@implementation FSJLogInViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     self.navigationController.navigationBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
    [self createUI];
}
- (void)createUI{
    mainImgview = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, WIDTH, HEIGH)];
    mainImgview.image = [UIImage imageNamed:@"denglu"];
    [self.view addSubview:mainImgview];
    userName = [[UITextField alloc]initWithFrame:CGRectMake(leftMagrin, HEIGH/2, WIDTH - leftMagrin-rightMagrin, viewHeight)];
    userName.delegate =self;
    userName.placeholder = @"用户名";
    userName.borderStyle = UITextBorderStyleNone;
    userName.backgroundColor = [UIColor clearColor];
    userName.text =@"admin";
    [self.view addSubview:userName];

    userPwd = [[UITextField alloc]initWithFrame:CGRectMake(leftMagrin, HEIGH/2 + viewHeight + 24, WIDTH - leftMagrin-rightMagrin, viewHeight)];
    userPwd.delegate =self;
    userPwd.placeholder = @"密码";
    userPwd.borderStyle = UITextBorderStyleNone;
    userPwd.backgroundColor = [UIColor clearColor];
    userPwd.secureTextEntry = YES;
    [self.view addSubview:userPwd];
    
    loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(leftMagrin, HEIGH/2+viewHeight*2+48, WIDTH-leftMagrin-rightMagrin, viewHeight);
    [loginBtn setBackgroundColor:SystemBlueColor];
    [loginBtn setTitleColor:SystemWhiteColor forState:UIControlStateNormal];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    loginBtn.layer.cornerRadius = 5;
    loginBtn.layer.masksToBounds = YES;
    loginBtn.selected = NO;
    [self.view addSubview:loginBtn];
    firstView = [[UIView alloc]initWithFrame:CGRectMake(leftMagrin, HEIGH/2+viewHeight, WIDTH - leftMagrin-rightMagrin, 2)];
    firstView.backgroundColor = SystemBlueColor;
    [self.view addSubview:firstView];
    
    secondView = [[UIView alloc]initWithFrame:CGRectMake(leftMagrin, HEIGH/2+viewHeight + 24 + viewHeight, WIDTH - leftMagrin-rightMagrin, 2)];
    secondView.backgroundColor = SystemWhiteColor;
    [self.view addSubview:secondView];
}
#pragma mark -- Textfield
- (void)endEditing:(UIGestureRecognizer *)tap{
    [self.view endEditing:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES; //会进入编辑状态
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (userName.editing) {
        firstView.backgroundColor = SystemBlueColor;
        secondView.backgroundColor = SystemWhiteColor;
    }
    if (userPwd.editing) {
        secondView.backgroundColor = SystemBlueColor;
        firstView.backgroundColor = SystemWhiteColor;
    }
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[UITextField class]] ||[tempView isKindOfClass:[UIButton class]] ||[tempView isKindOfClass:[UIImageView class]] ||[tempView isKindOfClass:[UIView class]])
        {
            CGRect frame = tempView.frame;
            frame.origin.y -= 80;
            [UIView animateWithDuration:0.3 animations:^{tempView.frame = frame;}];
           // NSLog(@"%f,%@",tempView.frame.origin.y,NSStringFromClass(tempView.class));
        }
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    for (UIView *tempView in self.view.subviews) {
        if ([tempView isKindOfClass:[UITextField class]] ||[tempView isKindOfClass:[UIButton class]] ||[tempView isKindOfClass:[UIImageView class]] ||[tempView isKindOfClass:[UIView class]])
        {
            CGRect frame = tempView.frame;
            frame.origin.y += 80;
            [UIView animateWithDuration:0.3 animations:^{tempView.frame = frame;}];
            // NSLog(@"%f,%@",tempView.frame.origin.y,NSStringFromClass(tempView.class));
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- Login
- (void)login:(UIButton *)sender{
    //userName.text =@"province";
    userPwd.text  =@"admin";
    if ([userName.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入账号"];
        return;
    }
    if ([userPwd.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入密码"];
        return;
    }
    [self.view endEditing:YES];//键盘退出
    NSDictionary *loginDict = @{@"userName":userName.text,@"password":userPwd.text};
   
    [FSJNetworking networkingPOSTWithActionType:LoginAction requestDictionary:loginDict success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        
        [[EGOCache globalCache]setObject:responseObject forKey:@"userinfo" withTimeoutInterval:LoginTime];
        
        model = [FSJUserInfo initWithDictionary:responseObject];
       
        if ([model.status isEqualToString: @"200"]) {
            
            [[EGOCache globalCache]setObject:[NSNumber numberWithBool:YES] forKey:@"Login" withTimeoutInterval:LoginTime];
            
            [[EGOCache globalCache]setString:model.jwt      forKey:@"jwt" withTimeoutInterval:LoginTime];
            [[EGOCache globalCache]setString:model.areaType forKey:@"areaType"withTimeoutInterval:LoginTime];
            [[EGOCache globalCache]setString:model.areaId   forKey:@"areaId" withTimeoutInterval:LoginTime];
            [[EGOCache globalCache]setString:model.topic    forKey:@"topic" withTimeoutInterval:LoginTime];
            [[EGOCache globalCache]setString:model.areaName forKey:@"areaname"withTimeoutInterval:LoginTime];
            [[EGOCache globalCache]setString:model.officeName forKey:@"officeName" withTimeoutInterval:LoginTime];
             FSJMapViewController *vc = [[FSJMapViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else{
           [MBProgressHUD showError:model.message];
           
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSLog(@"error = %@",error);
        [SVProgressHUD showInfoWithStatus:@"登录失败"];
    }];
  //  }
    
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    userName.text =@"";
    userPwd.text  =@"";
    [SVProgressHUD dismiss];
}
@end

