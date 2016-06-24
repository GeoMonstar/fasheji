//
//  FSJChangePersonInfoViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/17.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJChangePersonInfoViewController.h"

@interface FSJChangePersonInfoViewController ()<UITextFieldDelegate>{
    UITextField *firstInput;
    UITextField *secondInput;
    UITextField *thirdInput;
    UIButton * codeBtn;
    UIButton * returnBtn;
    NSString *placeholerStr;
    NSString *titleStr;
    NSString *dicStr;
    NSString *jwtStr;
}
@end

@implementation FSJChangePersonInfoViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self createNav];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    firstInput = nil;
    secondInput = nil;
    thirdInput = nil;
    returnBtn = nil;
    codeBtn = nil;
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SystemLightGrayColor;
    self.navigationController.navigationBarHidden = NO;
    firstInput.delegate = self;
    jwtStr = [[EGOCache globalCache]stringForKey:@"jwt"];
//    if(self.changeType == Username){
//        [self createUIwith:@"姓名"];
//        titleStr = @"更改姓名";
//        dicStr = @"name";
//    }
//    if (self.changeType == Usermobile) {
//        [self createUIwith:@"手机号"];
//        titleStr = @"更改手机号";
//        dicStr = @"mobile";
//    }
    switch (self.changeType ) {
        case 0:
            [self createUIwith:@"姓名"];
            titleStr = @"更改姓名";
            dicStr = @"name";
            break;
        case 1:
            [self createUIwith:@"手机号"];
            titleStr = @"更改手机号";
            dicStr = @"mobile";
            break;
        case 2:
            [self createUIwith:@"固话号"];
            titleStr = @"更改固话号";
            dicStr = @"phone";
            break;
        case 3:
            [self createUIwith:@"邮箱"];
            titleStr = @"更改邮箱";
            dicStr = @"email";
            break;
        case 4:
            [self createUI];
             titleStr = @"更改密码";
            break;
        default:
            break;
    }
    self.title = titleStr;
}
- (void)createUI{
    firstInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    firstInput.placeholder = @"  请输入原密码";
    
    secondInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 45, WIDTH, 44)];
    secondInput.placeholder = @"  请输入新密码";
    
    thirdInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 90, WIDTH, 44)];
    thirdInput.placeholder = @"  请再次输入新密码";
    
    firstInput.backgroundColor = SystemWhiteColor;
    secondInput.backgroundColor = SystemWhiteColor;
    thirdInput.backgroundColor = SystemWhiteColor;
    returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(WIDTH *0.1, 160, WIDTH *0.8, 35);
    [returnBtn setTitle:@"确  认" forState:UIControlStateNormal];
    [returnBtn setTitleColor:SystemWhiteColor forState:UIControlStateNormal];
    [returnBtn setBackgroundColor:SystemBlueColor];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        returnBtn.layer.cornerRadius = 4;
    [returnBtn setBackgroundImage:[self createImageWithColor:SystemGrayColor] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(changePwd:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:firstInput];
    [self.view addSubview:secondInput];
    [self.view addSubview:returnBtn];
    [self.view addSubview:thirdInput];
    
}
- (void)createUIwith:(NSString *)str{
    firstInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    firstInput.placeholder = [NSString stringWithFormat:@"  请输入%@",str];
    secondInput = [[UITextField alloc]initWithFrame:CGRectMake(0, 45, WIDTH, 44)];
    secondInput.placeholder = @"  请输入验证码";
    firstInput.backgroundColor = SystemWhiteColor;
    secondInput.backgroundColor = SystemWhiteColor;
    firstInput.font = [UIFont systemFontOfSize:14];
    secondInput.font = [UIFont systemFontOfSize:14];
    codeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    codeBtn.frame = CGRectMake(WIDTH - 70 , 4, 60, 30);
    codeBtn.layer.cornerRadius = 3;
    codeBtn.layer.borderColor = SystemBlueColor.CGColor;
    codeBtn.layer.borderWidth = 0.5;
    [codeBtn setTitleColor:SystemBlueColor forState:UIControlStateNormal];
    [codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    codeBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    //[secondInput addSubview:codeBtn];
    returnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    returnBtn.frame = CGRectMake(WIDTH *0.1, firstInput.frame.origin.y + firstInput.frame.size.height +18 , WIDTH *0.8, 35);
    [returnBtn setTitle:@"确认" forState:UIControlStateNormal];
    [returnBtn setTitleColor:SystemWhiteColor forState:UIControlStateNormal];
    [returnBtn setBackgroundColor:SystemBlueColor];
    returnBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    returnBtn.layer.cornerRadius = 4;
    [returnBtn setBackgroundImage:[self createImageWithColor:SystemGrayColor] forState:UIControlStateHighlighted];
    [returnBtn addTarget:self action:@selector(changeInfo:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstInput];
    //[self.view addSubview:secondInput];
    [self.view addSubview:returnBtn];
}
- (void)changePwd:(UIButton *)sender{
    if (firstInput.text && secondInput.text && thirdInput.text  ) {
        if ([secondInput.text isEqualToString:thirdInput.text]) {
        NSDictionary *dic = @{@"jwt":jwtStr,@"oldPassword":firstInput.text,@"newPassword":secondInput.text};
         [FSJNetworking networkingPOSTWithActionType:UserPwdChange requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
             FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
                         if ([model.status isEqualToString:@"200"]) {
                             [SVProgressHUD showSuccessWithStatus:model.message];
                         }
             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                 [self.navigationController popViewControllerAnimated:YES];
             });
         } failure:^(NSURLSessionDataTask *operation, NSError *error) {
             [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
         }];
        }
        else{
            [SVProgressHUD showErrorWithStatus:@"二次输入密码不一致"];
        }
    }
    else{
        [SVProgressHUD showErrorWithStatus:@"请补全信息"];
    }

}
- (void)changeInfo:(UIButton *)sender{
    
    switch (self.changeType) {
        case 1:
            if (![firstInput.text isMobileNumber]) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确手机号"];
               firstInput.text = @"";
                return;
            };
            break;
        case 3:
            if (![firstInput.text isEmailAddress]) {
                [SVProgressHUD showErrorWithStatus:@"请输入正确邮箱地址"];
                firstInput.text = @"";
                return;
            };
            break;
            
        default:
            break;
    }
    if ([firstInput.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"补全信息"];
    }
    else{
//        if ([secondInput.text isEqualToString:@""]) {
//            [SVProgressHUD showErrorWithStatus:@"请输入验证码"];
//        }else{
            NSDictionary *dic = @{@"jwt":jwtStr,dicStr:firstInput.text};
            [FSJNetworking networkingPOSTWithActionType:UserInfoChange requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
                FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
                        if ([model.status isEqualToString:@"200"]) {
                            [SVProgressHUD showSuccessWithStatus:model.message];
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [self.navigationController popViewControllerAnimated:YES];
                     });
                }
            } failure:^(NSURLSessionDataTask *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
            }];
        }
 //   }
}

- (void)createNav{
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    [SVProgressHUD dismiss];
}
- (UIImage*) createImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
