//
//  FSJMeViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/9.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMeViewController.h"
#import "FSJTopTableViewCell.h"
#import "FSJMineTableViewCell.h"
#import "FSJChangePersonInfoViewController.h"
@interface FSJMeViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>{
    FSJUserInfo *userInfomodel;
   // UITableView *myTableView;
    UITapGestureRecognizer *tap;
   // UIImage *iconImg;
}
@property (nonatomic, strong)UITableView *myTableView;
@end

@implementation FSJMeViewController
static NSString *MineInfoTableViewCell = @"MineInfoViewCell";
static NSString *MineHeaderViewCell = @"MineHeaderViewCell";
- (UITableView *)myTableView{
    if (_myTableView == nil) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH) style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _myTableView.scrollEnabled = NO;
        _myTableView.bounces = NO;
        [_myTableView registerNib:[UINib nibWithNibName:@"FSJTopTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:MineHeaderViewCell];
        [_myTableView registerNib:[UINib nibWithNibName:@"FSJMineTableViewCell" bundle:[NSBundle mainBundle]]forCellReuseIdentifier:MineInfoTableViewCell];
    }
    return  _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //iconImg = [UIImage imageNamed:@"yonghutouxiang.png"];
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    statusBarView.backgroundColor=SystemBlueColor;
    [self.view addSubview:statusBarView];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self getUserInfo];
    [self initTableview];
    self.navigationController.navigationBarHidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
    [SVProgressHUD dismiss];
}
- (void)getUserInfo{
    NSDictionary *dic = @{@"jwt":_jwtStr};
    [FSJNetWorking networkingGETWithActionType:UserInfoPreview requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (responseObject) {
            userInfomodel = [FSJUserInfo initWithDictionary:responseObject];
            if (userInfomodel.photo) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTableView reloadData];
                //NSLog(@"最终 == %@",userInfomodel.photo);
            });
           }
        }
        else{
            NSLog(@"返回数据为空");
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
- (void)initTableview{
   
    [self.view addSubview:self.myTableView];
}
#pragma mark UITableView Datasource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 120;
    }
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    switch (sectionIndex) {
        case 0:
            return 1;
            break;
        case 1:
            return 7;
            break;
        case 2:
            return 1;
            break;
        default:
            return 0;
            break;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        FSJTopTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:MineHeaderViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.BackBtn setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
        cell.BackBtn.contentMode = UIViewContentModeScaleAspectFit;
         cell.BackBtn.contentMode = UIViewContentModeScaleAspectFit;
        [cell.BackBtn addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
        cell.backgroundColor = SystemBlueColor;
        cell.BackBtn.tag = 600;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BaseImgURL,userInfomodel.photo]];
         cell.HeadBtn.layer.cornerRadius = 40;
        cell.HeadBtn.layer.masksToBounds = YES;
       // [cell.HeadBtn setBackgroundImage:iconImg forState:UIControlStateNormal];
        [cell.HeadBtn sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"yonghutouxiang.png"]];
        
        [cell.logoutBtn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];

        NSLog(@"图片地址url == %@",url);
        [cell.HeadBtn addTarget:self action:@selector(changeIcon:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
    NSArray* temp01 = @[@"用户名:",@"真实姓名:",@"工号:",@"手机号:",@"固机号:",@"邮箱:",@"归属机构:"];
    NSArray* temp02 = @[@"修改密码"];
    FSJMineTableViewCell *cell = [self.myTableView dequeueReusableCellWithIdentifier:MineInfoTableViewCell];
    cell.UserInfoIcon.contentMode = UIViewContentModeScaleAspectFit;
    cell.UserInfoname.font = [UIFont systemFontOfSize:14];
    cell.UserInfocontent.font = [UIFont systemFontOfSize:14];
    switch (indexPath.section) {
        case 1:
            cell.UserInfoname.text = temp01[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"yonghuming"];
                    cell.UserInfocontent.text = userInfomodel.loginName;
                    break;
                case 1:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"xingming"];
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                    cell.UserInfocontent.text = userInfomodel.name;
                    break;
                case 2:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"gonghao"];
                    cell.UserInfocontent.text = userInfomodel.no;
                    break;
                case 3:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"shouji"];
                    cell.UserInfocontent.text = userInfomodel.mobile;
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 4:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"gudingdianhua"];
                    cell.UserInfocontent.text = userInfomodel.phone;
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                    break;
                case 5:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"youxiang"];
                    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
                    cell.UserInfocontent.text = userInfomodel.email;
                    break;
                case 6:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"guishu"];
                    cell.UserInfocontent.text = userInfomodel.company;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            cell.UserInfoname.text = temp02[indexPath.row];
            switch (indexPath.row) {
                case 0:
                    cell.UserInfoIcon.image = [UIImage imageNamed:@"mima"];
                    cell.UserInfoname.text = @"修改密码";
                    cell.UserInfocontent.text = @"";
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FSJChangePersonInfoViewController *vc = [[FSJChangePersonInfoViewController alloc]init];
    if (indexPath.section == 0 ) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 2) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 6) {
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 1) {
      
        vc.changeType = Username;
    }
    if (indexPath.section == 1 && indexPath.row == 3) {
       
        vc.changeType = Usermobile;
    }
    if (indexPath.section == 1 && indexPath.row == 4) {
        
        vc.changeType = Userphone;
    }
    if (indexPath.section == 1 && indexPath.row == 5) {
      
        vc.changeType = Useemail;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
 
        vc.changeType = Userpwd;
    }
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- 按钮响应
- (void)logout:(UIButton *)sender{
    NSDictionary *dic = @{@"jwt":self.jwtStr};
    [FSJNetWorking networkingPOSTWithActionType:UserLogoutAction requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"]) {
            [SVProgressHUD showSuccessWithStatus:model.message];
            [[EGOCache globalCache]clearCache];
             [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"error"]];
    }];
}
- (void)changeIcon:(UIButton *)sender{
    UIActionSheet* mysheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照相",@"从相册中选择", nil];
    mysheet.delegate = self;
    mysheet.frame = CGRectMake(0, self.view.frame.size.height-200, ViewWidth, 200);
    [mysheet showInView:self.view];
}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
#pragma mark 头像选择上传
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
            //选择图片
        case 1:
            //NSLog(@"0");
        {
            UIImagePickerController*  picker = [[UIImagePickerController alloc] init];
            picker.delegate=self;
            [picker setSourceType:(UIImagePickerControllerSourceTypePhotoLibrary)];
            picker.allowsEditing = YES;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
            // 照相
        case 0:
            //NSLog(@"1");
        {
            UIImagePickerController* picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];
        }
            break;
        case 2:
            NSLog(@"2");
            break;
        default:
            break;
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage] ?: info[UIImagePickerControllerOriginalImage];
    //UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
   // iconImg = chosenImage;
    NSData *data;
    if (UIImagePNGRepresentation(chosenImage)) {
        //返回为png图像。
        data = UIImagePNGRepresentation(chosenImage);
    }else if(UIImageJPEGRepresentation((chosenImage), (0.9))) {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(chosenImage, 0.9);
    }
    [self doUpload:data];
     [picker dismissViewControllerAnimated:YES completion:nil];
}
//- (void)updateData:(NSData *)data{ 
//    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"/rs/user/upload/photo"];
//    NSString *filename = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
//    NSLog(@"filename = %@", filename);
//    NSDictionary *dict = @{@"jwt":self.jwtStr};
//    NSURLRequest * request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url parameters:dict   constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFileData:data name:@"file" fileName:@"user.png" mimeType:@"image/jpeg"];
//    }];
//       AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//           NSProgress *progress = nil;
//    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
//            NSLog(@"Error: %@", error);
//        } else {
//            FSJUserInfo * tempuser = [FSJUserInfo initWithDictionary:responseObject];
//            if ([tempuser.status isEqualToString:@"200"]) {
//                [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
//                    [self getUserInfo];
//            
//            }else{
//                [SVProgressHUD showErrorWithStatus:tempuser.message];
//                NSLog(@"上传头像错误信息 = %@",tempuser.message);
//                }
//            }
//        }];
//        [uploadTask resume];
//     
//}
- (void)doUpload:(NSData *) imageData {
    // [SVProgressHUD showWithStatus:@"头像修改中"];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
    [manager.requestSerializer willChangeValueForKey:@"timeOut"];
    manager.requestSerializer.timeoutInterval = 30.f;
    [manager.requestSerializer didChangeValueForKey:@"timeOut"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain",@"text/html",@"text/json",@"application/json",@"text/javascript", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",BaseURL,@"/rs/user/upload/photo"];
    //NSString *filename = [NSString stringWithFormat:@"%@.png", [[NSUUID UUID] UUIDString]];
   // NSLog(@"filename = %@", filename);
    //参数注意
    NSDictionary *dict = @{@"jwt":self.jwtStr};
        [manager
         POST:url
         parameters:dict
         constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
             [formData appendPartWithFileData:imageData name:@"file" fileName:@"user.png" mimeType:@"image/jpeg"];
         }
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             FSJUserInfo * tempuser = [FSJUserInfo initWithDictionary:responseObject];
             if ([tempuser.status isEqualToString:@"200"]) {
                 [SVProgressHUD showSuccessWithStatus:@"头像上传成功"];
                 [self getUserInfo];
             }else{
                 [SVProgressHUD showErrorWithStatus:tempuser.message];
                 NSLog(@"上传头像错误信息 = %@",tempuser.message);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"网络连接失败"];
                 NSLog(@"%@", error);
            }
     ];
}
@end

