//
//  FSJJiankongVC.m
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//
#define MergeStr(str,model)  [NSString stringWithFormat:@"%@:%@",str,model]
#define rowHeight 28
#define viewSpace 17
#import "FSJJiankongVC.h"
#import "FSJJiankongBase.h"
#import "FSJGongzuoStatus.h"
#import "FSJZhengji.h"
#import "FSJGongxiao.h"
#import "FSJGongxiaoDetail.h"
#import "FSJTitleBtn.h"
#import "FSJJKPopView.h"
@interface FSJJiankongVC ()
{
    NSString *navTitle;
    UIScrollView *mainScro;
    NSString * url;
    NSString * jwtStr;
    NSMutableArray *btnArr;
    NSMutableArray *viewArr;
    NSMutableArray *subviewArr;
    NSMutableArray *indexArr;
    NSString *  index;
  
    NSInteger _currentDataIndex;
    
    FSJJKPopView *popview;
}
@property (strong,nonatomic) HMSegmentedControl *segmentedControl;
@property (strong,nonatomic) FSJTitleBtn *titleBtn;
@property (retain,nonatomic) NSArray *nameArr;
@end
@implementation FSJJiankongVC
- (void)viewDidLoad{
  [super viewDidLoad];
    btnArr  = @[].mutableCopy;
    viewArr = @[].mutableCopy;
    subviewArr = @[].mutableCopy;
    self.view.backgroundColor = SystemLightGrayColor;
  index = @"2";
  jwtStr = [[EGOCache globalCache]stringForKey:@"jwt"];
  mainScro  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH)];
  mainScro.backgroundColor = SystemLightGrayColor;
    
     [self createViewWith:@"db" andfirst:YES];
     [self createNav];
}
- (void)createViewWith:(NSString *)str andfirst:(BOOL)first{
   
    switch (self.JiankongType) {
        case Qianji:
            if (first) {
                 [self creatViewFirstWith:@"clt" andWith:NO];
            }
            else{
                [self shuanxinViewFirstWith:@"1" andWith:NO];
            }
            navTitle = @"前置放大单元";
            break;
        case Moji:
            if (first) {
                [self creatViewFirstWith:@"cnu" andWith:YES];
            }
            else{
                [self shuanxinViewFirstWith:index andWith:YES];
            }
             navTitle = @"功率放大单元";
            break;
        case Zhuangtai:
            [self creatViewFourwith:str];
            navTitle = @"工作状态详情";
            break;
        case Zhengji:
            [self creatViewThirdwith:str];
             navTitle = @"整机详情";
            break;
        default:
            break;
    }
}
- (void)creatHeadViewWith:(NSInteger) num{
   
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    scroView.contentSize = CGSizeMake(WIDTH/4*num, 44);
    scroView.backgroundColor = SystemLightGrayColor;
    scroView.scrollEnabled = YES;
    scroView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < num; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( WIDTH/4 *i, 0, WIDTH/4, 42);
        [btn setTitle:[NSString stringWithFormat:@"功放%d",i+1] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn setTitleColor:SystemBlueColor  forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.backgroundColor = SystemLightGrayColor;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/4 *i, 42, WIDTH/4, 2)];
        view.backgroundColor = SystemWhiteColor;
        view.tag = 500 + i;
        btn.tag  = 600 + i;
        [btn addTarget:self action:@selector(changIndex:) forControlEvents:UIControlEventTouchUpInside];
        [btnArr addObject:btn];
        [viewArr addObject:view];
        [scroView addSubview:view];
        [scroView addSubview:btn];
    }
    for (UIView *view in viewArr) {
        if (view.tag == 500) {
            view.backgroundColor = SystemBlueColor;
        }
    }
    for (UIButton *btn in btnArr) {
        if (btn.tag == 600) {
            btn.selected = YES;
        }
    }
    [self.view addSubview:scroView];
}
- (void)changIndex:(UIButton *)sender{
    if (sender.selected == YES) {
        return;
    }
    else{
        for (UIButton *btn in btnArr) {
            btn.selected = NO;
            sender.selected = YES;
        }
        for (UIView *view in viewArr) {
            view.backgroundColor = SystemWhiteColor;
            if ((sender.tag - 600) == (view.tag - 500)) {
                view.backgroundColor = SystemBlueColor;
            }
        }
        index = [NSString stringWithFormat:@"%ld",sender.tag-600+2];
        [self shuanxinViewFirstWith:index andWith:YES];
    }
}
- (void)creatViewWithModel:(FSJGongxiaoDetail *)model and:(FSJGongxiao *)basemodel and:(BOOL)show and:(NSString *)str{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
//    UILabel *label1;
//    if (show) {
//        label1  = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH *0.05, 54,  WIDTH *0.2, 35)];
//    }
//    else{
//        label1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH *0.05, 10,  WIDTH *0.2, 35)];
//    }
//    label1.font = [UIFont systemFontOfSize:14];
//    label1.textAlignment = NSTextAlignmentCenter;
//    label1.layer.cornerRadius = 5;
//    label1.layer.masksToBounds = YES;
//    label1.text =[NSString stringWithFormat:@"功放插件%@",str];
//    label1.textColor = SystemWhiteColor;
//    label1.backgroundColor = SystemBlueColor;
    
    NSArray *arr1 =@[MergeStr(@"输出功率(dBm)", model.outputPower),MergeStr(@"温度", model.temperature),MergeStr(@"电压1(V)", model.voltage1),MergeStr(@"AGC电压(V)", model.agcVol)];
    NSArray *arr2 =@[MergeStr(@"输出功率(W)", model.outputPowerW),MergeStr(@"电流(A)", model.current),MergeStr(@"电压2(V)", model.voltage2),MergeStr(@"过激电压(V)", model.extreVol)];
    NSArray *arr3 =@[MergeStr(@"类型", model.type),MergeStr(@"型号", model.modelNum),MergeStr(@"取样电流数样)", model.currentNum),MergeStr(@"驻波比", model.vswr)];
    NSArray *arr4 =@[MergeStr(@"风扇转速(RPM)", model.fan),MergeStr(@"程序版本号", model.softwareVersion),MergeStr(@"反射功率(dBm)", model.reflectPower),MergeStr(@"推动功率", model.drivePower)];
    NSArray *arr = [self getfirstWith:model.status];
    NSArray *arr5 = @[MergeStr(@"过激励保护", arr[0]),MergeStr(@"过流保护",arr[1]),MergeStr(@"驻波保护",arr[3])];
    NSArray *arr6 = @[MergeStr(@"AGC/MGC", arr[4]),MergeStr(@"温度保护", arr[2]),MergeStr(@"功率保护",arr[7])];
    NSDictionary *dic = basemodel.table[0];
    NSArray *arr7 = @[@"取样电流表",MergeStr(@"电流索引",[dic objectForKey:@"currentIndex"])];
    NSArray *arr8 = @[@"",MergeStr(@"取样值", [dic objectForKey:@"value"])];
    UIView *view1;
    if (show) {
         view1 = [self creatViewWith:4 and:54 and:arr1 and:arr2];
    }
    else{
        view1 = [self creatViewWith:4 and:10 and:arr1 and:arr2];
    }
   
    UIView *view2 = [self creatViewWith:4 and:(viewSpace+view1.frame.origin.y + view1.frame.size.height) and:arr3 and:arr4];
    UIView *view3 = [self creatViewWith:3 and:(viewSpace+view2.frame.origin.y + view2.frame.size.height) and:arr5 and:arr6];
    UIView *view4 ;
    if (!show) {
        view4 = [self creatViewWith:2 and:(viewSpace+view3.frame.origin.y + view3.frame.size.height) and:arr7 and:arr8];
        [subviewArr addObject:view4];
    }
    view1.layer.borderColor = [UIColor orangeColor].CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    view1.layer.shadowOpacity = 0;
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [subviewArr addObject:view3];
//    [subviewArr addObject:label1];
//    [self.view addSubview:label1];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];
    [self.view insertSubview:view3 atIndex:0];
    [self.view insertSubview:view4 atIndex:0];
}
- (void)shuanxinViewFirstWith:(NSString *)str andWith:(BOOL)show{
    NSDictionary *dic= @{@"transId":self.fsjId,@"ip":self.addressId,@"from":@"device",@"jwt":jwtStr,@"index":str};
    [FSJNetworking networkingGETWithActionType:GetGongxiaoDetail requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJGongxiao *basemodel = [FSJGongxiao initWithDictionary:responseObject];
        if ([basemodel.status isEqualToString:@"200"]  && basemodel.main != nil) {
            FSJGongxiaoDetail *model = [FSJGongxiaoDetail initWithDictionary:basemodel.main];
            [self creatViewWithModel:model and:basemodel and:show and:str];
        }

        else{
          
            [MBProgressHUD showError:@"无返回数据"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
- (void)creatViewFirstWith:(NSString *)str andWith:(BOOL)show{
    NSDictionary *dic = @{@"transId":self.fsjId,@"jwt":jwtStr,@"type":str};
    [FSJNetworking networkingGETWithActionType:GetGongxiao requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
         FSJGongxiao *basemodel = [FSJGongxiao initWithDictionary:responseObject];
        if ([basemodel.status isEqualToString:@"200"]   && basemodel.main != nil) {
            if (show) {
                for (NSDictionary *dic in basemodel.cnu) {
                 NSString *indexStr = [dic objectForKey:@"ampIndex"];
                    [indexArr addObject:indexStr];
                }
                [self creatHeadViewWith:basemodel.cnu.count];
            }
            FSJGongxiaoDetail *model = [FSJGongxiaoDetail initWithDictionary:basemodel.main];
            [self creatViewWithModel:model and:basemodel and:show and:str];
        }
       
        else{
         [MBProgressHUD showError:@"无返回数据"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
- (void)creatViewThirdwith:(NSString *)str{
    //NSDictionary *dic = @{@"transId":self.fsjId,@"ip":self.addressId,@"from":str,@"jwt":jwtStr};
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.fsjId,@"transId",self.addressId,@"ip",str,@"from",jwtStr,@"jwt", nil];
    
    [FSJNetworking networkingGETWithActionType:GetZhengji requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *basemodel = [FSJJiankongBase initWithDictionary:responseObject];
        if ([basemodel.status isEqualToString:@"200"]  && basemodel.data != nil){
            [SVProgressHUD dismiss];
            FSJZhengji *model = [FSJZhengji initWithDictionary:basemodel.data];
            NSArray *arr1 = @[MergeStr(@"发射功率(dBm)", model.po),MergeStr(@"驻波比", model.vswr),MergeStr(@"AGC电压(V)", model.agcVol)];
            NSArray *arr2 = @[MergeStr(@"发射功率(W)", model.poW),MergeStr(@"温度", model.temperature),MergeStr(@"过激指示电压", model.overloadVol)];
            NSArray *arr3 = @[MergeStr(@"反射功率(dBm)", model.pr),MergeStr(@"总电流", model.current),MergeStr(@"电压2(V)", model.voltage2),MergeStr(@"B相电流", model.currentB),MergeStr(@"A相电压", model.voltageA),MergeStr(@"C相电压", model.voltageC)];
            NSArray *arr4 = @[MergeStr(@"不平衡功率(dBm)", model.unbalacePower),MergeStr(@"电压1(V)", model.voltage1),MergeStr(@"A相电流", model.currentA),MergeStr(@"C相电流", model.currentC),MergeStr(@"B相电压", model.voltageB),MergeStr(@"CN", model.cn)];
            UIView *view1 = [self creatViewWith:3 and:viewSpace and:arr1 and:arr2];
            UIView *view2 = [self creatViewWith:6 and:view1.frame.origin.y + view1.frame.size.height + viewSpace and:arr3 and:arr4];
            view1.layer.borderColor = [UIColor orangeColor].CGColor;
            view1.layer.borderWidth = 1;
            view1.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
            view1.layer.shadowOpacity = 0;
            view1.layer.shadowRadius  = 0;
            [self.view insertSubview:view1 atIndex:0];
            [self.view insertSubview:view2 atIndex:0];
        }
        
        else{
            [MBProgressHUD showError:@"无返回数据"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
- (void)creatViewFourwith:(NSString *)str{
    NSDictionary *dic = @{@"transId":self.fsjId,@"ip":self.addressId,@"from":str,@"jwt":jwtStr };
    [FSJNetworking networkingGETWithActionType:GetGongzuo requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        
        FSJJiankongBase *basemodel = [FSJJiankongBase initWithDictionary:responseObject];
        if ([basemodel.status isEqualToString:@"200"] && basemodel.data != nil) {
             [SVProgressHUD dismiss];
            FSJGongzuoStatus *model = [FSJGongzuoStatus initWithDictionary:basemodel.data];
            NSArray *arr = [self getforthWith:model.status];
            NSArray *arr1 = @[MergeStr(@"过激励保护", arr[0]),MergeStr(@"温度保护", arr[2]),MergeStr(@"功率保护",arr[7])];
            NSArray *arr2 = @[MergeStr(@"过流保护",arr[1]),MergeStr(@"驻波保护",arr[3]),@""];
            NSArray *arr3 = @[MergeStr(@"风机状态", arr[4]),MergeStr(@"当前时间", model.nowDate)];
            NSArray *arr4 = @[MergeStr(@"机内温度(℃)", model.temperature),@""];
            NSArray *arr5 = @[MergeStr(@"缺相保护", arr[6])];
            NSArray *arr6 = @[MergeStr(@"视频保护", arr[5])];
            NSArray *arr7 =@[];
            if (self.showZidong == YES) {
               arr7 = @[MergeStr(@"自动切换主设备",  (model.autoSwitch.integerValue>0?@"可以使用":@"禁用")),MergeStr(@"警告开关", (model.alarmSwitch.integerValue>0?@"禁用设备告警检测":@"使用告警检测"))];
            }
            else{
               arr7 = @[MergeStr(@"警告开关", (model.alarmSwitch.integerValue>0?@"禁用设备告警检测":@"使用告警检测"))];
            }
            NSArray *arr8 = @[MergeStr(@"开机/关机状态", (model.onoffState.integerValue>0?@"关机":@"开机")),MergeStr(@"主机/备机状态", (model.autoSwitch.integerValue>0?@"启用自动切换主备机":@"禁用自动切换主备机")),MergeStr(@"本控/遥控状态", (model.romoteState.integerValue > 0?@"遥控状态":@"本控状态")),MergeStr(@"天线/假负载", (model.anternaState.integerValue>0?@"输出至负载":@"输出至天线"))];
            UIView *first  = [self creatViewWith:3 and:viewSpace and:arr1 and:arr2];
            UIView *second = [self creatViewWith:2 and:(first.frame.origin.y + first.frame.size.height +viewSpace) and:arr3 and:arr4];
            UIView *third  = [self creatViewWith:1 and:(second.frame.origin.y + second.frame.size.height +viewSpace) and:arr5 and:arr6];
            UIView *forth  = [self creatViewWith:2 and:(third.frame.origin.y + third.frame.size.height +viewSpace) and:arr7 and:nil];
            UIView *fifth  = [self creatViewWith:4 and:(forth.frame.origin.y + forth.frame.size.height +viewSpace) and:arr8 and:nil];
            [self.view insertSubview:first atIndex:0];
            [self.view insertSubview:second atIndex:0];
            [self.view insertSubview:third atIndex:0];
            [self.view insertSubview:forth atIndex:0];
            [self.view insertSubview:fifth atIndex:0];
        }
     
        else{
            [MBProgressHUD showError:@"无返回数据"];
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        NSArray *array = error.userInfo.allValues;
        NSHTTPURLResponse *response = array[0];
        if (response.statusCode ==401 ) {
            [SVProgressHUD showInfoWithStatus:AccountChanged];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
                [[EGOCache globalCache]clearCache];
                [[EGOCache globalCache]setObject:[NSNumber numberWithBool:NO] forKey:@"Login" withTimeoutInterval:0];
            });
        }
    }];
}
- (NSArray *)getfirstWith:(NSString*)str{
    NSMutableArray *arr = @[].mutableCopy;
    int num = 2;
    NSInteger b = str.integerValue;
    for (int i = 0; i < 8; i ++) {
        NSInteger a =  b%num;
        NSString *str;
        switch (i) {
            case 0:case 6:
                str = a>0?@"报警":@"正常";
                break;
            case 1: case 2: case 3:case 7:
                str = a>0?@"ON":@"OFF";
                break;
            case 5:
                str = a>0?@"无视频输入":@"有视频输入";
                break;
            case 4:
                str = a>0?@"AGC":@"MGC";
                break;
            default:
                break;
        }
        [arr addObject:str];
        //[arr addObject:[NSString stringWithFormat:@"%ld",a]];
        //num = num *2;
        b = b/2;
    }
    return arr;
}
- (NSArray *)getforthWith:(NSString*)str{
    NSMutableArray *arr = @[].mutableCopy;
    int num = 2;
    NSInteger b = str.integerValue;
    for (int i = 0; i < 8; i ++) {
        NSInteger a =  b%num;
        NSString *str;
        switch (i) {
            case 0:case 4:case 6:
            str = a>0?@"报警":@"正常";
            break;
            case 1: case 2: case 3:case 7:
                str = a>0?@"ON":@"OFF";
                break;
            case 5:
                str = a>0?@"无视频输入":@"有视频输入";
                break;
            default:
                break;
        }
        [arr addObject:str];
       
        b = b/2;
    }
    return arr;
}
- (UIView *)creatViewWith:(NSInteger)num and:(CGFloat)y and:(NSArray*)firstLabel and:(NSArray*) secondLabel{
    UIView *smallview = [[UIView alloc]initWithFrame:CGRectMake(WIDTH *0.05, y, WIDTH *0.9, rowHeight *num + 10)];
    smallview.backgroundColor = SystemWhiteColor;
    smallview.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
    smallview.layer.shadowOpacity = 0.5;
    smallview.layer.shadowRadius  = 1;
    for (int i = 0; i < num; i ++) {
        UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH *0.07,y+ 5+rowHeight*i , smallview.frame.size.width, rowHeight)];
        label1.text = firstLabel[i];
        
        UILabel  *label2 = [[UILabel alloc]initWithFrame:CGRectMake(smallview.frame.size.width/2+WIDTH*0.1,y+ 5+rowHeight*i, smallview.frame.size.width/2, rowHeight)];
        label2.text = secondLabel[i];
        label1.backgroundColor = label2.backgroundColor = [UIColor clearColor];
        label1.font = label2.font = [UIFont systemFontOfSize:14];
        [subviewArr addObject:label1];
        [subviewArr addObject:label2];
        [self.view addSubview:label1];
        [self.view addSubview:label2];
    }
     return smallview;
}

- (void)shuaxin:(UIButton *)sender{
    for (UIView *view in self.view.subviews) {
        if (view.frame.origin.y >10 || self.JiankongType!= Moji) {
             [view removeFromSuperview];
        }
    }
    [self createViewWith:@"device" andfirst:NO];
}
- (void)backTomain:(UIButton *)sender{
     [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createNav{
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 10, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIButton *rButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rButton.frame = CGRectMake(0, 0, 18, 18);
    [rButton setBackgroundImage:[UIImage imageNamed:@"shua"] forState:UIControlStateNormal];
    [rButton addTarget:self action:@selector(shuaxin:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:rButton];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item1;
    self.navigationItem.rightBarButtonItem = item2;
    self.nameArr = @[@"整机",@"前置放大单元",@"功率放大单元",@"工作状态"];
    self.titleBtn = [FSJTitleBtn buttonWithType:UIButtonTypeCustom];
    self.titleBtn.frame = CGRectMake(WIDTH/2-72.5, 20, 145, 40);
    self.titleBtn.titleLabel.textAlignment = 1;
    [self.titleBtn setTitle:self.nameArr[0] forState:UIControlStateNormal];
    
    [self.titleBtn setImage:[UIImage imageNamed:@"navshang"] forState:UIControlStateNormal];
    [self.titleBtn setImage:[UIImage imageNamed:@"navxia"] forState:UIControlStateSelected];
    [self.titleBtn addTarget:self action:@selector(showPop:) forControlEvents:UIControlEventTouchUpInside];
    self.titleBtn.enabled = YES;
    [self.titleBtn setTintColor:SystemWhiteColor];
    [[[UIApplication  sharedApplication]keyWindow] addSubview: self.titleBtn];
    popview = [[FSJJKPopView alloc]initPopWith:CGRectMake(0, 48, WIDTH, HEIGH) andDataSource:self.nameArr];
    FSJWeakSelf(weakself);
    popview.popshow = ^(BOOL hidden){
        if (hidden == NO) {
           weakself.titleBtn.selected = !weakself.titleBtn.selected;
        }
    };
}
- (void)showPop:(UIButton *)sender{
    sender.selected = !sender.selected;
    
    if (sender.selected == YES) {
        
       [[[UIApplication  sharedApplication]keyWindow] addSubview: popview];
       // [self.view addSubview:popview];
        FSJWeakSelf(weakself);
        popview.selectIndex = ^(NSInteger arrindex){
             sender.selected = !sender.selected;
            [weakself.titleBtn setTitle:weakself.nameArr[arrindex-500] forState:UIControlStateNormal];
            weakself.JiankongType = arrindex-500;
            for (UIView *view in weakself.view.subviews) {
                    [view removeFromSuperview];
            }
            [weakself createViewWith:@"db" andfirst:YES];
            NSLog(@"%ld",arrindex);
        };
    }
    else{
        
        [popview removeFromSuperview];
    }
    
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.titleBtn removeFromSuperview];
    [popview removeFromSuperview];
    [SVProgressHUD dismiss];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
@end
