//
//  FSJJiankong500W.m
//  FSJ
//
//  Created by Monstar on 2017/3/16.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJJiankong50W.h"
#import "FSJJiankongBase.h"
#import "FSJGongzuoStatus.h"
#import "FSJZhengji.h"
#import "FSJGongxiao.h"
#import "FSJGongxiaoDetail.h"
#import "FSJTitleBtn.h"
#import "FSJJKPopView.h"
#import "FSJShebeiInfo50W.h"
#define rowHeight 28
#define viewSpace 17
#define dbStr @"db"
#define deviceStr @"device"

@interface FSJJiankong50W ()
{
    NSString *navTitle;
    UIScrollView *mainScro;
    NSString * url;
    NSString * jwtStr;
    NSMutableArray *btnArr;
    NSMutableArray *viewArr;
    NSMutableArray *subviewArr;
    NSMutableArray *indexArr;
    NSInteger   index;
    NSInteger _currentDataIndex;
    NSInteger BtnWidth;
    FSJJKPopView *popview;
}

@property (strong,nonatomic) FSJTitleBtn *titleBtn;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIImageView *titleImg;
@property (retain,nonatomic) NSArray *nameArr;

@end

@implementation FSJJiankong50W

- (void)viewDidLoad{
    [super viewDidLoad];
    btnArr  = @[].mutableCopy;
    viewArr = @[].mutableCopy;
    subviewArr = @[].mutableCopy;
    self.view.backgroundColor = SystemLightGrayColor;
    index = 1;
    jwtStr = [[FSJUserInfo shareInstance] userAccount].jwt;
    mainScro  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH)];
    mainScro.backgroundColor = SystemLightGrayColor;
    
    [self getShebeiJiegou:dbStr];
    [self createViewWithFrom:dbStr];
    [self createNav];
}
- (void)createViewWithFrom:(NSString *)str {
    
    switch (self.jiankong50WType) {
        case ShebeiInfo:
            [self createShebeiInfoViewWith:str];
            navTitle = @"设备信息";
            break;
        case TongxinJiekou:
            [self createTongxinjiekouWith:str];
            navTitle = @"通信接口";
            break;
        case ZhengjiStatus:
            [self createZhengjistatusWith:str];
            navTitle = @"整机状态";
            break;
        case ZhengjiControl:
            [self createZhengjiControlwith:str];
            navTitle = @"整机详情";
            break;
        case Dianyuan:
            [self createDianyuanwith:str];
            navTitle = @"电源";
            break;
        case Gongfang:
            [self createGongfangwith:str];
            navTitle = @"功放";
            break;
        case Jiliqi:
            [self createJiliqiwith:str];
            navTitle = @"激励器";
            break;
        default:
            break;
    }
}
#pragma mark -- 获取设备结构
-(void)getShebeiJiegou:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    
    [FSJNetworking networkingGETWithActionType:ShebeiJiegou50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJShebeijiegoul50W *basemodel = [FSJShebeijiegoul50W initWithDictionary:model.data];
            self.outputNum    = [basemodel.outputNum integerValue];
            self.inputNum     = [basemodel.inputNum integerValue];
            self.actuatorNum  = [basemodel.actuatorNum integerValue];
            self.amplifierNum = [basemodel.amplifierNum integerValue];
            self.powerNum     = [basemodel.powerNum integerValue];
            VVDLog(@"%@",basemodel);
        }else{
            
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark -- 激励器
- (void)createJiliqiwith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str,@"index":[NSString stringWithFormat:@"%ld",index]};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:Jiliqi50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJJiliqi50W *basemodel = [FSJJiliqi50W initWithDictionary:model.data];
            
            NSArray *titleArr = @[@"参数",@"输出通道",@"解调",@"状态"];
            [self createHeadViewWith:titleArr];
            [self createJiliqiwithModel:basemodel andindex:index];
            
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}
- (void)createJiliqiwithModel:(FSJJiliqi50W *)FSJJiliqimodel andindex:(NSInteger)jiliqiIndex{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    //--激励器类型
    NSString *jlqType = @"";
    switch ([FSJJiliqimodel.eType integerValue]) {
        case 1:
            jlqType = @"DVB-T2激励器";
            break;
        case 2:
            jlqType = @"DTMB激励器";
            break;
        case 3:
            jlqType = @"DVB-C激励器";
            break;
        case 4:
            jlqType = @"DVB-S激励器";
            break;
            
        default:
            break;
    }
    NSArray *canshuarr = @[MergeStr(@"CPU序号",FSJJiliqimodel.eCpuNum),MergeStr(@"激励器温度",FSJJiliqimodel.eTemper),MergeStr(@"单频网地址",FSJJiliqimodel.eSingleFreNetAddr),MergeStr(@"当前模式最大输入码",FSJJiliqimodel.eInputCodeRate),MergeStr(@"射频输出总衰减",FSJJiliqimodel.eRFOutputAtte),MergeStr(@"激励器类型",jlqType),MergeStr(@"输出总开关",[FSJJiliqimodel.eRFOutputSwitch isEqualToString:@"0"]?@"关闭":@"打开")];
    UIView *canshuview = [self creatViewWith:canshuarr.count and:54 and:canshuarr and:nil];
    FSJJiliqi50W *statusModel = [FSJJiliqi50W initWithDictionary:FSJJiliqimodel.eStatus];


    NSArray *statusArr = @[MergeStr(@"恒温晶振是否失锁",[statusModel.str0 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"GPS模块状态",[statusModel.str1 isEqualToString:@"0"]?@"正常":@"异常"),
                           MergeStr(@"GPS是否锁定",[statusModel.str2 isEqualToString:@"0"]?@"锁定":@"失锁"),
                           MergeStr(@"过温状态",[statusModel.str3 isEqualToString:@"0"]?@"正常":@"过温"),
                           MergeStr(@"1pps是否丢失",[statusModel.str4 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输入通道1是否故障",[statusModel.str5 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输入通道2是否故障",[statusModel.str6 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输入通道3是否故障",[statusModel.str7 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输入通道4是否故障",[statusModel.str8 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输出通道1是否故障",[statusModel.str9 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输出通道2是否故障",[statusModel.str10 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输出通道3是否故障",[statusModel.str11 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"RF输出通道4是否故障",[statusModel.str12 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"总输出增益是否故障",[statusModel.str13 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"FPGA内存是否故障",[statusModel.str14 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"输入通道1 SIP包是否丢失",[statusModel.str15 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"输入通道2 SIP包是否丢失",[statusModel.str16 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"输入通道3 SIP包是否丢失",[statusModel.str17 isEqualToString:@"0"]?@"否":@"是"),
                           MergeStr(@"输入通道4 SIP包是否丢失",[statusModel.str18 isEqualToString:@"0"]?@"否":@"是")];
    UIView *statusView = [self creatViewWith:statusArr.count and:54 and:statusArr and:nil];
    
    
    switch (jiliqiIndex) {
        case 1:
            [subviewArr addObject:canshuview];
            [self.view insertSubview:canshuview atIndex:0];

            break;
        case 2:
          
            
            break;
        case 3:
           
            
            break;
        case 4:
            [subviewArr addObject:statusView];
            [self.view insertSubview:statusView atIndex:0];
            break;
        default:
            break;
    }
}
#pragma mark -- 电源
- (void)createDianyuanwith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str,@"index":[NSString stringWithFormat:@"%ld",index]};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:Dianyuan50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJDianyuan50W *basemodel = [FSJDianyuan50W initWithDictionary:model.data];
            NSMutableArray *titleArr = @[].mutableCopy;
            for (int i = 0;  i<self.powerNum; i++) {
                [titleArr addObject:[NSString stringWithFormat:@"电源%d",i+1]];
            }
            [self createHeadViewWith:titleArr];
            [self createDianyuanViewWithModel:basemodel];
            
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createDianyuanViewWithModel:(FSJDianyuan50W *)FSJDianyuanmodel{
    
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"电压",FSJDianyuanmodel.powersDirectVol),MergeStr(@"电流",FSJDianyuanmodel.powersDirectCurr)];
    
    UIView *view1 = [self creatViewWith:arr1.count and:54 and:arr1 and:nil];
   
    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];
}
#pragma mark -- 功放
- (void)createGongfangwith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str,@"index":[NSString stringWithFormat:@"%ld",index]};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:GongFang50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJGongfang50W *basemodel = [FSJGongfang50W initWithDictionary:model.data];
            
            
            NSMutableArray *titleArr = @[].mutableCopy;
            for (int i = 0;  i<self.powerNum; i++) {
                [titleArr addObject:[NSString stringWithFormat:@"功放%d",i+1]];
            }
            [self createHeadViewWith:titleArr];
            [self createGongfangViewWithModel:basemodel];
            
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createGongfangViewWithModel:(FSJGongfang50W *)FSJGongfangmodel{
    
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }

    NSArray *arr1 = @[MergeStr(@"输出功率",FSJGongfangmodel.ampOutputPow),MergeStr(@"功放温度",FSJGongfangmodel.ampTemperature),MergeStr(@"推动管电压",FSJGongfangmodel.ampDrivVol),MergeStr(@"功率管电流2",FSJGongfangmodel.ampCurr2),MergeStr(@"风扇转速2",FSJGongfangmodel.ampFan2),MergeStr(@"风扇转速4",FSJGongfangmodel.ampFan4)];
    NSArray *arr2 = @[MergeStr(@"输入功率",FSJGongfangmodel.ampInputPow),MergeStr(@"功率管电压",FSJGongfangmodel.ampPowVol),MergeStr(@"推动管电流",FSJGongfangmodel.ampDrivCurr),MergeStr(@"功率管电流1",FSJGongfangmodel.ampCurr1),MergeStr(@"风扇转速1",FSJGongfangmodel.ampFan1),MergeStr(@"风扇转速3",FSJGongfangmodel.ampFan3),@""];
    
    UIView *view1 = [self creatViewWith:arr1.count and:54 and:arr1 and:arr2];
    
    [subviewArr addObject:view1];
    
    [self.view insertSubview:view1 atIndex:0];
}
#pragma mark -- 整机控制
- (void)createZhengjiControlwith:(NSString *)str{
    
}
#pragma mark -- 整机状态
- (void)createZhengjistatusWith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:ZhengjiStatus50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJZhengjistatus50W *basemodel = [FSJZhengjistatus50W initWithDictionary:model.data];
            
            [self createZhengjistatusViewWithModel:basemodel];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createZhengjistatusViewWithModel:(FSJZhengjistatus50W *)Zhengjistatusmodel{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"温度异常保护",[Zhengjistatusmodel.tProtectTemp isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"反射异常保护",[Zhengjistatusmodel.tProtectreflect isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"控制响应延时",[Zhengjistatusmodel.tWorkLate isEqualToString:@"0"]?@"控制":@"未控制"),MergeStr(@"环境温度",Zhengjistatusmodel.tEnviTemp),MergeStr(@"射频输入矫正值",Zhengjistatusmodel.tRfInputVal),MergeStr(@"驻波比",Zhengjistatusmodel.tSwr)];
    NSArray *arr2 = @[MergeStr(@"输入功率阀值高",Zhengjistatusmodel.tInputPowThreHigh),MergeStr(@"输入功率阀值低",Zhengjistatusmodel.tInputPowThreLow),MergeStr(@"功率自动位",[Zhengjistatusmodel.tWorkAuto isEqualToString:@"0"]?@"手动":@"自动"),MergeStr(@"功放电流",Zhengjistatusmodel.tAmpCuur),MergeStr(@"射频输出矫正值",Zhengjistatusmodel.tRfOutputVal),MergeStr(@"AGC",Zhengjistatusmodel.tAGC),MergeStr(@"发射功率阀值上限",Zhengjistatusmodel.tRefPowTop)];
    NSArray *arr3 = @[MergeStr(@"温度阀值",Zhengjistatusmodel.tTempThre),MergeStr(@"cpu序列号",Zhengjistatusmodel.tCpuNo),MergeStr(@"实测输出功率",Zhengjistatusmodel.tOutputPow),MergeStr(@"实测反射功率",Zhengjistatusmodel.tRefPow),MergeStr(@"电流异常保护",[Zhengjistatusmodel.tProtectCurrent isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"过激励电压",Zhengjistatusmodel.tOverloadVol),MergeStr(@"前置电流",Zhengjistatusmodel.tFrontCurr)];
    
    NSArray *arr4 = @[MergeStr(@"主激励器通信",[Zhengjistatusmodel.tCommStatus isEqualToString:@"0"]?@"中断":@"正常"),MergeStr(@"过激励异常保护",[Zhengjistatusmodel.tProtect isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"设定输出功率",Zhengjistatusmodel.tSetOutputPow),MergeStr(@"功放电压",Zhengjistatusmodel.tAmpVol),MergeStr(@"前置电压",Zhengjistatusmodel.tFrontVol),MergeStr(@"射频反射矫正值",Zhengjistatusmodel.tRfRefVal),@""];
    
    
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:arr2];
    UIView *view2 = [self creatViewWith:arr3.count and:viewSpace+view1.frame.origin.y + view1.frame.size.height and:arr3 and:arr4];
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];
}
#pragma mark -- 设备基本信息
- (void)createShebeiInfoViewWith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:ShebeiInfo50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJShebeiInfo50W *basemodel = [FSJShebeiInfo50W initWithDictionary:model.data];
            
            [self createShebeiInfoViewWithModel:basemodel];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createShebeiInfoViewWithModel:(FSJShebeiInfo50W *)ShebeiInfomodel{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"站台编码",ShebeiInfomodel.addrNo),MergeStr(@"温度保护", ShebeiInfomodel.hardwareVersion),MergeStr(@"生成厂家",ShebeiInfomodel.manuFactory),MergeStr(@"发射机功率等级",ShebeiInfomodel.transDev),MergeStr(@"产品序列号",ShebeiInfomodel.serialNum),MergeStr(@"设备经度",ShebeiInfomodel.lonVal)];
    
    NSArray *arr2 = @[MergeStr(@"设备名称",ShebeiInfomodel.devName),MergeStr(@"软件版本号", ShebeiInfomodel.softwareVersion),MergeStr(@"产品型号",ShebeiInfomodel.modelNum),MergeStr(@"设备类型码",ShebeiInfomodel.serialNum),MergeStr(@"设备纬度指示",[ShebeiInfomodel.latFlag isEqualToString:@"0"]?@"北纬":@"南纬"),MergeStr(@"设备经度指示",[ShebeiInfomodel.lonFlag isEqualToString:@"0"]?@"东经":@"西经" )];
    

    NSArray *arr3 = @[MergeStr(@"功率等级",ShebeiInfomodel.transDev),MergeStr(@"冷却类型",ShebeiInfomodel.devCold),MergeStr(@"cpu序列号",ShebeiInfomodel.cpuNo),MergeStr(@"设备时间",ShebeiInfomodel.devTime)];
    NSArray *arr4 = @[MergeStr(@"设备高度",ShebeiInfomodel.altitude),MergeStr(@"生产厂家",ShebeiInfomodel.manuFactory),@"",@""];
   
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:arr2];
    UIView *view2 = [self creatViewWith:arr3.count and:viewSpace+view1.frame.origin.y + view1.frame.size.height and:arr3 and:arr4];

    
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];

}
#pragma mark -- 通信接口
- (void)createTongxinjiekouWith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:TongxinJiekou50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJBaseModel *model = [FSJBaseModel initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJTongxinjiekou50W *basemodel = [FSJTongxinjiekou50W initWithDictionary:[responseObject objectForKey:@"data"]];
            
            [self createTongxinjiekouViewWithModel:basemodel];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createTongxinjiekouViewWithModel:(FSJTongxinjiekou50W *)Tongxinjiekoumodel{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"本设备ID",Tongxinjiekoumodel.deviceId),MergeStr(@"是否启用DHCP", [Tongxinjiekoumodel.isDHCP isEqualToString:@"0"]?@"禁用":@"启用"),MergeStr(@"掩码",Tongxinjiekoumodel.ipMask),MergeStr(@"本地ip管理",Tongxinjiekoumodel.localIp),MergeStr(@"本设备mac地址",Tongxinjiekoumodel.macAddr),MergeStr(@"设备ID", Tongxinjiekoumodel.deviceId),MergeStr(@"默认网关",Tongxinjiekoumodel.ipGateway)];
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:nil];
   
    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];
}
#pragma mark -- Seg

- (void)createHeadViewWith:(NSArray *) titleArr{
    
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    scroView.contentSize = CGSizeMake(WIDTH/4*titleArr.count, 44);
    scroView.backgroundColor = SystemLightGrayColor;
    scroView.scrollEnabled = YES;
    scroView.showsHorizontalScrollIndicator = NO;
    for (int i = 0; i < titleArr.count; i ++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake( WIDTH/4 *i, 0, WIDTH/4, 42);
        //[btn setTitle:[NSString stringWithFormat:@"功放%d",i+1] forState:UIControlStateNormal];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
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
        if (view.tag == 500+index-1) {
            view.backgroundColor = SystemBlueColor;
        }
    }
    for (UIButton *btn in btnArr) {
        if (btn.tag == 600+index-1) {
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
        index = sender.tag-600+1;
        [self createViewWithFrom:dbStr];
    }
}

- (UIView *)creatViewWith:(NSInteger)num and:(CGFloat)y and:(NSArray*)firstLabel and:(NSArray*) secondLabel{
    UIView *smallview = [[UIView alloc]initWithFrame:CGRectMake(WIDTH *0.05, y, WIDTH *0.9, rowHeight *num + 10)];
    smallview.backgroundColor = SystemWhiteColor;
    smallview.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
    smallview.layer.shadowOpacity = 0.5;
    smallview.layer.shadowRadius  = 1;

    for (int i = 0; i < num; i ++) {
        UILabel  *label1 = [[UILabel alloc]initWithFrame:CGRectMake(3, 5+rowHeight*i , smallview.frame.size.width, rowHeight)];
        label1.text = firstLabel[i];
        
        UILabel  *label2 = [[UILabel alloc]initWithFrame:CGRectMake(smallview.frame.size.width/2+WIDTH*0.05, 5+rowHeight*i, smallview.frame.size.width/2, rowHeight)];
        label2.text = secondLabel[i];
        label1.backgroundColor = label2.backgroundColor = [UIColor clearColor];
        label1.font = label2.font = [UIFont systemFontOfSize:14];
        [subviewArr addObject:label1];
        [subviewArr addObject:label2];

        [smallview addSubview:label1];
        [smallview addSubview:label2];
    }
    
    return smallview;
    
}

- (void)shuaxin:(UIButton *)sender{
    for (UIView *view in self.view.subviews) {
        if (view.frame.origin.y >0 ) {
            [view removeFromSuperview];
        }
    }
    [self createViewWithFrom:deviceStr];
}
- (void)backTomain:(UIButton *)sender{
   
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

        self.nameArr = @[@"设备信息",@"通信接口",@"整机控制",@"整机状态",@"电源",@"功放",@"激励器"];
        self.titleBtn.Btnwidth = 90;
        self.titleBtn.BtnX = 20;
    
    self.titleBtn.frame = CGRectMake(WIDTH/2-72.5, 20, 160, 40);
    //self.titleBtn.Btnwidth =130;
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
            
                switch (arrindex-500) {
                    case 0:
                        weakself.jiankong50WType = ShebeiInfo;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                    case 1:
                        weakself.jiankong50WType = TongxinJiekou;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                    case 2:
                        weakself.jiankong50WType = ZhengjiControl;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                    case 3:
                        weakself.jiankong50WType = ZhengjiStatus;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                    case 4:
                        weakself.jiankong50WType = Dianyuan;
                        weakself.titleBtn.Btnwidth = 60;
                        weakself.titleBtn.BtnX = 40;
                        break;
                    case 5:
                        weakself.jiankong50WType = Gongfang;
                        weakself.titleBtn.Btnwidth = 60;
                        weakself.titleBtn.BtnX = 40;
                        break;
                    case 6:
                        weakself.jiankong50WType = Jiliqi;
                        weakself.titleBtn.Btnwidth = 80;
                        weakself.titleBtn.BtnX = 30;
                        break;
                        
                    default:
                        break;
                }
            
            for (UIView *view in weakself.view.subviews) {
                [view removeFromSuperview];
            }
            [weakself createViewWithFrom:dbStr];
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
