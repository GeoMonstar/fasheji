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
    
    
    NSInteger BtnWidth;
    FSJJKPopView *popview;
}
@property (strong,nonatomic) HMSegmentedControl *segmentedControl;
@property (strong,nonatomic) FSJTitleBtn *titleBtn;

@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIImageView *titleImg;
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
                [self shuanxinViewFirstWith:@"1" andWith:NO andfrom:@"device"];
            }
            navTitle = @"前置放大单元";
            break;
        case Moji:
            if (first) {
                [self creatViewFirstWith:@"cnu" andWith:YES];
            }
            else{
                [self shuanxinViewFirstWith:index andWith:YES andfrom:@"device"];
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
        [self shuanxinViewFirstWith:index andWith:YES andfrom:@"db"];
    }
}
- (void)creatViewWithModel:(FSJGongxiaoDetail *)model and:(FSJGongxiao *)basemodel and:(BOOL)show and:(NSString *)str{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }

    NSArray *arr = [self getfirstWith:model.status];
    NSArray *arr5 = @[MergeStr(@"过流保护",arr[1]),MergeStr(@"温度保护", arr[2]),MergeStr(@"驻波保护",arr[3])];
   
     NSArray *arr6 = @[MergeStr(@"类型", [model.type isEqualToString:@"1"]?@"前级":@"末级"),MergeStr(@"型号", model.modelNum),MergeStr(@"程序版本号",model.softwareVersion)];

    NSDictionary *dic = basemodel.table[0];
    NSArray *arr7 = @[@"取样电流表",MergeStr(@"电流索引",[dic objectForKey:@"currentIndex"])];
    NSArray *arr8 = @[@"",MergeStr(@"取样值", [dic objectForKey:@"value"])];
    UIView *view1;
    if (show) {
        NSArray *arr1 =@[MergeStr(@"输出功率(dBm)", model.outputPower),MergeStr(@"工作电流(A)", model.current),MergeStr(@"AC/DC1电压(V)", model.voltage1),MergeStr(@"风扇转速(RPM)", model.fan)];
        NSArray *arr2 =@[MergeStr(@"输出功率(W)", model.outputPowerW),MergeStr(@"电压驻波比", model.vswr),MergeStr(@"工作温度(A)", model.temperature),@""];
         view1 = [self creatViewWith:4 and:54 and:arr1 and:arr2];
    }
    else{
        NSArray *arr1 =@[MergeStr(@"输出功率(dBm)", model.outputPower),MergeStr(@"工作电流(A)", model.current),MergeStr(@"过激电压(V)", model.extreVol),MergeStr(@"AC/DC1电压(V)", model.voltage1)];
        NSArray *arr2 =@[MergeStr(@"输出功率(W)", model.outputPowerW),MergeStr(@"工作温度(A)", model.temperature),MergeStr(@"AGC电压(V)", model.agcVol),MergeStr(@"AC/DC2电压(V)", model.voltage2)];
        view1 = [self creatViewWith:4 and:10 and:arr1 and:arr2];
    
    }
 

    UIView *view3 = [self creatViewWith:3 and:(viewSpace+view1.frame.origin.y + view1.frame.size.height) and:arr5 and:arr6];
    UIView *view4 ;
    if (dic) {
        
        view4 = [self creatViewWith:2 and:(viewSpace+view3.frame.origin.y + view3.frame.size.height) and:arr7 and:arr8];
        [subviewArr addObject:view4];
    }
//
//    view1.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
//    view1.layer.shadowOpacity = 0;
    
    view1.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
    view1.layer.shadowOpacity = 0.5;
    view1.layer.shadowRadius  = 1;
    [subviewArr addObject:view1];

    [subviewArr addObject:view3];

    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view3 atIndex:0];
    [self.view insertSubview:view4 atIndex:0];
}
- (void)shuanxinViewFirstWith:(NSString *)str andWith:(BOOL)show andfrom:(NSString *)from{
    NSDictionary *dic= @{@"transId":self.fsjId,@"ip":self.addressId,@"from":from,@"jwt":jwtStr,@"index":str};
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
            NSDictionary *valueDic = [responseObject objectForKey:@"value"];
            NSString *agcStr = [valueDic objectForKey:@"agcVol"];
            NSString *guojiStr = [valueDic objectForKey:@"extreVol"];
            NSMutableArray *valueArr = @[].mutableCopy;
            
            for (NSString *str  in valueDic.allKeys) {
                if (str.integerValue > 0) {
                    [valueArr addObject:str];
                }
            }
            //返回数据处理
            [valueArr sortUsingComparator:^NSComparisonResult(__strong id obj1,__strong id obj2){
                return [obj1 intValue] > [obj2 intValue];
            }];
            [valueArr removeObjectAtIndex:0];
            NSArray *arr1 = @[MergeStr(@"发射功率(dBm)", model.po),MergeStr(@"反射功率(dBm)", model.pr),MergeStr(@"AGC状态",agcStr.integerValue == 1 ?@"告警":@"正常"),MergeStr(@"环境温度", model.temperature)];
            
            NSArray *arr2 = @[MergeStr(@"发射功率(W)", model.poW),MergeStr(@"驻波比", model.vswr),MergeStr(@"过激状态", guojiStr.integerValue == 1 ?@"告警":@"正常"),@""];
           
            NSMutableArray *arr3 = @[].mutableCopy;
            [arr3 addObject:MergeStr(@"前置放大单元工作温度)", ((NSString *)[valueDic objectForKey:@"1"]).integerValue ==1?@"告警":@"正常")];
            
            for (int i = 0; i<valueArr.count; i++) {
                NSInteger s  =   ((NSString *)valueArr[i]).integerValue;
                NSString *str = [NSString stringWithFormat:@"功率放大单元%ld工作状态",s-1];
                [arr3 addObject:MergeStr(str, ((NSString *)[valueDic objectForKey:valueArr[i]]).integerValue ==1?@"告警":@"正常") ];
            }
            
            NSArray *baohuArr = [self getfirstWith:[responseObject objectForKey:@"status"]];
            NSArray *arr4 = @[MergeStr(@"过流保护",baohuArr[1]),MergeStr(@"温度保护", baohuArr[2]),MergeStr(@"驻波保护",baohuArr[3])];
                UIView *view1 = [self creatViewWith:arr1.count and:viewSpace and:arr1 and:arr2];
                UIView *view2 = [self creatViewWith:arr3.count and:view1.frame.origin.y + view1.frame.size.height + viewSpace and:arr3 and:nil ];
                UIView *view3 = [self creatViewWith:3 and:view2.frame.origin.y +view2.frame.size.height+viewSpace and:arr4 and:nil];

            
            view1.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
            view1.layer.shadowOpacity = 0.5;
            view1.layer.shadowRadius  = 1;
                [self.view insertSubview:view1 atIndex:0];
                [self.view insertSubview:view2 atIndex:0];
                [self.view insertSubview:view3 atIndex:0];
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

            NSArray *arr8 = @[MergeStr(@"开机/关机状态", (model.onoffState.integerValue>0?@"关机":@"开机")),MergeStr(@"主机/备机状态", (model.autoSwitch.integerValue>0?@"备机":@"开机")),MergeStr(@"本控/遥控状态", (model.romoteState.integerValue > 0?@"遥控":@"本控")),MergeStr(@"天线/假负载", (model.anternaState.integerValue>0?@"负载":@"天线")),MergeStr(@"自动切换主设备",  (model.autoSwitch.integerValue>0?@"启用":@"禁用")),MergeStr(@"告警开关", (model.alarmSwitch.integerValue>1?(model.alarmSwitch.integerValue>2?@"清除设备的告警记录表":@"允许设备的告警检测"):@"禁用设备告警检测"))];
            
            UIView *first  = [self creatViewWith:arr8.count and:viewSpace and:arr8 and:nil];

            [self.view insertSubview:first atIndex:0];

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
        NSLog(@"%ld",a);
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
    self.titleBtn = [FSJTitleBtn buttonWithType:UIButtonTypeCustom];
    if (self.is1000W) {
        self.nameArr = @[@"整机",@"前置放大单元",@"功率放大单元",@"工作状态"];
        self.titleBtn.Btnwidth = 70;
        self.titleBtn.BtnX = 30;
    }else{
        self.nameArr = @[@"前置放大单元",@"工作状态"];
        self.titleBtn.Btnwidth = 130;
        self.titleBtn.BtnX = 0;
    }
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
        FSJWeakSelf(weakself);
        popview.selectIndex = ^(NSInteger arrindex){
             sender.selected = !sender.selected;
           [weakself.titleBtn setTitle:weakself.nameArr[arrindex-500] forState:UIControlStateNormal];
            
           // weakself.titleLabel.text = weakself.nameArr[arrindex-500];
           // [weakself.titleLabel sizeToFit];
            if (weakself.is1000W) {
            switch (arrindex-500) {
                case 0:
                    weakself.JiankongType = Zhengji;
                    weakself.titleBtn.Btnwidth = 70;
                    weakself.titleBtn.BtnX = 30;
                    break;
                case 1:
                    weakself.JiankongType = Qianji;
                    weakself.titleBtn.Btnwidth = 130;
                    weakself.titleBtn.BtnX = 0;
                    break;
                case 2:
                    weakself.JiankongType = Moji;
                    weakself.titleBtn.Btnwidth = 130;
                    weakself.titleBtn.BtnX = 0;
                    break;
                case 3:
                    weakself.JiankongType = Zhuangtai;
                    weakself.titleBtn.Btnwidth = 90;
                    weakself.titleBtn.BtnX = 20;
                    break;
                    
                default:
                    break;
            }
            }else{
                switch (arrindex-500) {
                    case 0:
                        weakself.JiankongType = Qianji;
                        weakself.titleBtn.Btnwidth = 130;
                        weakself.titleBtn.BtnX = 0;
                        break;
                    case 1:
                        weakself.JiankongType = Zhuangtai;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                        
                    default:
                        break;
                
                }
            }
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
