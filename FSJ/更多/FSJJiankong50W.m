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
#import "FSJScrollBtnView.h"
#define rowHeight 23
#define viewSpace 17
#define dbStr @"db"
#define deviceStr @"device"

@interface FSJJiankong50W ()<ScrollviewDidselectd>
{
    NSString *navTitle;
    UIScrollView *mainScro;
    NSString * url;
    NSString * jwtStr;
    NSMutableArray *btnArr;
    NSMutableArray *secondbtnArr;
    NSMutableArray *viewArr;
    NSMutableArray *secondviewArr;
    NSMutableArray *subviewArr;
    NSMutableArray *indexArr;
    NSInteger   selfindex;
    NSInteger   secondindex;
    NSInteger _currentDataIndex;
    NSInteger BtnWidth;
    FSJJKPopView *popview;
    BOOL isJiliqi;
}

@property (strong,nonatomic) FSJTitleBtn *titleBtn;
@property (strong,nonatomic) UILabel *titleLabel;
@property (strong,nonatomic) UIImageView *titleImg;
@property (retain,nonatomic) NSArray *nameArr;

@end

@implementation FSJJiankong50W

- (void)viewDidLoad{
    [super viewDidLoad];
    NSArray *titleArray = @[@"系统信息",@"调制解调器",@"发射机",@"通信接口",@"无线终端"];
    
    btnArr  = @[].mutableCopy;
    secondbtnArr = @[].mutableCopy;
    viewArr = @[].mutableCopy;
    subviewArr = @[].mutableCopy;
    secondviewArr = @[].mutableCopy;
    self.view.backgroundColor = SystemLightGrayColor;
    selfindex = 1;
    secondindex = 1;
    jwtStr = [[FSJUserInfo shareInstance] userAccount].jwt;
    mainScro  = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH)];
    mainScro.backgroundColor = SystemLightGrayColor;
    [self createViewWithFrom:dbStr];
    [self createNav];
}
- (void)createViewWithFrom:(NSString *)str {
    isJiliqi = NO;
    switch (self.jiankong50WType) {
        case ShebeiInfo:
            [self createShebeiInfoViewWith:str];
            navTitle = @"系统信息";
            break;
        case Jiliqi:
            [self createJiliqiwith:str];
            navTitle = @"调制解调器";
            isJiliqi = YES;
            break;
        case Fasheji:
            [self createFashejiWith:str];
            navTitle = @"发射机";
            break;
        case TongxinJiekou:
            [self createTongxinjiekouWith:str];
            navTitle = @"通信接口";
            break;
        
        case WuxianZhongduan:
            [self createWuxianzhongduanWith:str];
            navTitle = @"无线终端";
            break;
        
        
        default:
            break;
    }
}
#pragma mark -- 无线终端
- (void)createWuxianzhongduanWith:(NSString *)str{
    FSJScrollBtnView *fashejiView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) andItemFrame:CGRectMake(0, 0, WIDTH/4, 44) andtitleColor:[UIColor blackColor] andselTitleColor:SystemBlueColor andbgColor:SystemWhiteColor andselBgColor:SystemWhiteColor andviewTag:1002 andtitleArray:@[@"常用参数",@"不常用参数"] andViewDirection:0];
    fashejiView.delegate = self;
    [self.view addSubview:fashejiView];
    switch (selfindex) {
        case 1:
            [self createDTUnormal50WWith:str];
            break;
        case 2:
            [self createDTUabnormal50With:str];
            break;
        default:
            break;
    }
    
}
#pragma mark -- 无线终端-正常
- (void)createDTUnormal50WWith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:DTUnormal50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJDTUnormal50W *basemodel = [FSJDTUnormal50W initWithDictionary:model.data];
            
            [self createDTUnormal50WViewWith:basemodel];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createDTUnormal50WViewWith:(FSJDTUnormal50W *)FSJDTUnormal50WModel{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"DTU ID",FSJDTUnormal50WModel.dtu_id),MergeStr(@"监控IP",FSJDTUnormal50WModel.spy_ip),MergeStr(@"监控IP",FSJDTUnormal50WModel.spy_port)];
    NSArray *arr2 = @[MergeStr(@"DTU 密码",FSJDTUnormal50WModel.dtu_pwd),MergeStr(@"监控域名",FSJDTUnormal50WModel.spy_domin),MergeStr(@"心跳包间隔",FSJDTUnormal50WModel.heartbeat)];
    
    UIView *view1 = [self creatViewWith:arr1.count and:44+10 and:arr1 and:arr2];
    
    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];
    
}
#pragma mark -- 无线终端-不正常
- (void)createDTUabnormal50With:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:DTUabnormal50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJDTUabNormal50W *basemodel = [FSJDTUabNormal50W initWithDictionary:model.data];
            
            [self createDTUabnormal50WViewWith:basemodel];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}
- (void)createDTUabnormal50WViewWith:(FSJDTUabNormal50W *)FSJDTUabNormal50WModel{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"网络通信协议",FSJDTUabNormal50WModel.network),
                      MergeStr(@"DTU重登陆模式",FSJDTUabNormal50WModel.dtu_login_mode),
                      MergeStr(@"串口参数",FSJDTUabNormal50WModel.seri_param),
                      MergeStr(@"APN名称",FSJDTUabNormal50WModel.apn_name),
                      MergeStr(@"APN访问密码",FSJDTUabNormal50WModel.apn_pwd),
                      MergeStr(@"数据采集中心2域名",FSJDTUabNormal50WModel.data_2name),
                      MergeStr(@"数据采集中心3域名",FSJDTUabNormal50WModel.data_3name),
                      ];
    NSArray *arr2 = @[MergeStr(@"DNS IP",FSJDTUabNormal50WModel.dns_ip),
                      MergeStr(@"串口波特率",FSJDTUabNormal50WModel.seri_date),
                      MergeStr(@"串口流控",FSJDTUabNormal50WModel.seri_flow),
                      MergeStr(@"APN访问用户名",FSJDTUabNormal50WModel.apn_username),
                      MergeStr(@"数据采集中心2IP",FSJDTUabNormal50WModel.data_2ip),
                      MergeStr(@"数据采集中心3IP",FSJDTUabNormal50WModel.data_3ip),
                      MergeStr(@"DTU电话号码",FSJDTUabNormal50WModel.dtu_phone_num),
                      ];
    UIView *view1 = [self creatViewWith:arr1.count and:44+10 and:arr1 and:arr2];
    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];
}
#pragma mark -- 调制解调器
- (void)createJiliqiwith:(NSString *)str{
     FSJScrollBtnView *fashejiView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) andItemFrame:CGRectMake(0, 0, WIDTH/4, 44) andtitleColor:[UIColor blackColor] andselTitleColor:SystemBlueColor andbgColor:SystemWhiteColor andselBgColor:SystemWhiteColor andviewTag:1003 andtitleArray:@[@"输入参数",@"输出参数",@"单凭网参数",@"工作状态"] andViewDirection:0];
      [self.view addSubview:fashejiView];
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:Jiliqi50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJJiliqi50W *basemodel = [FSJJiliqi50W initWithDictionary:model.data];
            //[self createJiliqiwithModel:basemodel andindex:selfindex andfrom:str];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}
- (void)createJiliqiwithModel:(FSJJiliqi50W *)FSJJiliqimodel andindex:(NSInteger)jiliqiIndex andfrom:(NSString *)fromStr{
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
    NSArray *canshuarr = @[MergeStr(@"CPU序号",FSJJiliqimodel.eCpuNum),
                           MergeStr(@"激励器温度",FSJJiliqimodel.eTemper),
                           MergeStr(@"单频网地址",FSJJiliqimodel.eSingleFreNetAddr),
                           MergeStr(@"当前模式最大输入码",FSJJiliqimodel.eInputCodeRate),
                           MergeStr(@"射频输出总衰减",FSJJiliqimodel.eRFOutputAtte),
                           MergeStr(@"激励器类型",jlqType),
                           MergeStr(@"输出总开关",[FSJJiliqimodel.eRFOutputSwitch isEqualToString:@"0"]?@"关闭":@"打开")];
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
         
            [self createShuchutongdaofrom:fromStr];
            
            break;
        case 3:
            
            [self createShuchutongdaofrom:fromStr];
            break;
        case 4:
           
            [subviewArr addObject:statusView];
            [self.view insertSubview:statusView atIndex:0];
            break;
        default:
            break;
    }
}
#pragma mark --- 输出通道&&解调
- (void)createShuchutongdaofrom:(NSString *)str{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str,@"index":[NSString stringWithFormat:@"%ld",secondindex]};
    VVDLog(@"输出通道&&解调");
    if (selfindex == 2) {
        
        [SVProgressHUD showWithStatus:@"加载中"];
        [FSJNetworking networkingGETWithActionType:Tongdao50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
            FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
            if ([model.status isEqualToString:@"200"] ) {
                FSJTongdao50W *basemodel = [FSJTongdao50W initWithDictionary:model.data];
                
                NSMutableArray *titleArr = @[].mutableCopy;
                for (int i = 0;  i < self.outputNum; i++) {
                    [titleArr addObject:[NSString stringWithFormat:@"通道%d",i+1]];
                }
              //  [self createHeadViewWith:titleArr andY:44 andLevel:2];
                [self createTongdaoViewwith:basemodel];
            }else{
                [MBProgressHUD showError:model.message];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }else{
        [SVProgressHUD showWithStatus:@"加载中"];
        [FSJNetworking networkingGETWithActionType:Tongdao50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
            FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
            if ([model.status isEqualToString:@"200"] ) {
                FSJJietiao50W *basemodel = [FSJJietiao50W initWithDictionary:model.data];
                
                NSMutableArray *titleArr = @[].mutableCopy;
                for (int i = 0;  i < self.inputNum; i++) {
                    [titleArr addObject:[NSString stringWithFormat:@"解调%d",i+1]];
                }
              //  [self createHeadViewWith:titleArr andY:44 andLevel:2];
                [self createTongdaoViewwith:basemodel];
            }else{
                [MBProgressHUD showError:model.message];
            }
            [SVProgressHUD dismiss];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            
        }];
    }
    
}
- (void)createTongdaoViewwith:(FSJJiankongBase *)basemodel{
    if (index  == 2) {
        FSJTongdao50W *tongdaomodel = (FSJTongdao50W *)basemodel;
        NSArray *arr1 = @[MergeStr(@"输出载波方式",[tongdaomodel.eChOutputCarrWay isEqualToString:@"0"]?@"多载波":@"单载波"),
                          MergeStr(@"输出交织模式",[tongdaomodel.eChOutputMixMode isEqualToString:@"0"]?@"240":@"720"),
                          MergeStr(@"通道1输出",tongdaomodel.eChOutputFreq),
                          MergeStr(@"电平衰减调节",tongdaomodel.eChLevelAtte),
                          MergeStr(@"单频网激励器延时",tongdaomodel.eChSingleNetDelay),
                          MergeStr(@"输出LDPC&QAM",tongdaomodel.eChOutputLDPCQAM),
                          MergeStr(@"输出PN相位",[tongdaomodel.eChOutputPNPh isEqualToString:@"0"]?@"旋转":@"固定"),
                          MergeStr(@"输出帧头模式",tongdaomodel.eChOutputFrameMode),
                          MergeStr(@"输出导频开关",[tongdaomodel.eChOutputPilotSwitch isEqualToString:@"0"]?@"关":@"开"),
                          MergeStr(@"输出单音开",[tongdaomodel.eChOutputStoneSwitch isEqualToString:@"0"]?@"关":@"开"),
                          MergeStr(@"通道1输出码流状态",[tongdaomodel.eChCodeStreamStatus isEqualToString:@"0"]?@"正常":@"异常"),
                          MergeStr(@"通道输出组网模式",[tongdaomodel.eChOutputNetWay isEqualToString:@"0"]?@"多频网直通模式":@"单频网地面模式")];
        UIView *view1 = [self creatViewWith:arr1.count and:54+44 and:arr1 and:nil];
        [subviewArr addObject:view1];
        [self.view insertSubview:view1 atIndex:0];
    }else{

        FSJJietiao50W *jietiaomodel = (FSJJietiao50W *)basemodel;
        NSArray *arr1 = @[MergeStr(@"激励器解调RF1口输入状态",[jietiaomodel.eRFInputStatus isEqualToString:@"0"]?@"未锁定":@"锁定"),
                          MergeStr(@"解调RF1 IQ倒置",[jietiaomodel.eDemoRFIQ isEqualToString:@"0"]?@"正常":@"倒置"),
                          MergeStr(@"输入RF1单频网适配器延时",jietiaomodel.eRFInputSingleNetDelay),
                          MergeStr(@"激励器解调RF1口输入SNR",jietiaomodel.eRFInputSNR),
                          MergeStr(@"激励器解调RF1口输入速率",jietiaomodel.eRFInputRate),
                          MergeStr(@"解调宽带",jietiaomodel.eDemoRFBroadBand),
                          MergeStr(@"解调RF1解调频率",jietiaomodel.eDemoRFFreq)];
        UIView *view1 = [self creatViewWith:arr1.count and:54+44 and:arr1 and:nil];
        [subviewArr addObject:view1];
        [self.view insertSubview:view1 atIndex:0];
    }
}
#pragma mark -- 发射机
- (void)createFashejiWith:(NSString *)str{
    
    FSJScrollBtnView *fashejiView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) andItemFrame:CGRectMake(0, 0, WIDTH/4, 44) andtitleColor:[UIColor blackColor] andselTitleColor:SystemBlueColor andbgColor:SystemWhiteColor andselBgColor:SystemWhiteColor andviewTag:1001 andtitleArray:@[@"数据监控",@"功能控制"] andViewDirection:0];
    fashejiView.delegate = self;
    [self.view addSubview:fashejiView];
    switch (selfindex) {
        case 1:
            [self createZhengjistatusWith:str];
            break;
        case 2:
            [self createZhengjiControlwith:str];
            break;
        default:
            break;
    }
    
    
}
#pragma mark -- 发射机 功能控制
- (void)createZhengjiControlwith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:ZhengjiKongzhi50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            FSJZhengjicontrol50W *basemodel = [FSJZhengjicontrol50W initWithDictionary:model.data];
            [self createZhengjicontrolViewWithModel:basemodel];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (void)createZhengjicontrolViewWithModel:(FSJZhengjicontrol50W *)Zhengjicontrolmodel{
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
    NSArray *arr1 = @[MergeStr(@"电流保护",[Zhengjicontrolmodel.protSwitch0 isEqualToString:@"0"]?@"开启":@"关闭"),MergeStr(@"过温保护",[Zhengjicontrolmodel.protSwitch1 isEqualToString:@"0"]?@"开启":@"关闭")];
    NSArray *arr2 = @[MergeStr(@"驻波保护",[Zhengjicontrolmodel.protSwitch2 isEqualToString:@"0"]?@"开启":@"关闭"),MergeStr(@"过激励保护",[Zhengjicontrolmodel.protSwitch3 isEqualToString:@"0"]?@"开启":@"关闭")];

 
    
    UIView *view1 = [self creatViewWith:arr1.count and:44+10 and:arr1 and:arr2];

    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];

}
#pragma mark -- 发射机 数据监控
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
    NSArray *arr1 = @[MergeStr(@"输出功率",Zhengjistatusmodel.tOutputPow)];
    NSArray *arr2 = @[MergeStr(@"反射功率",Zhengjistatusmodel.tRefPow)];
    
    NSArray *arr3 = @[MergeStr(@"输入功率",Zhengjistatusmodel.tmasterInputPower),MergeStr(@"驻波比",Zhengjistatusmodel.tSwr),MergeStr(@"环境温度",Zhengjistatusmodel.tEnviTemp),MergeStr(@"AC/DC1",Zhengjistatusmodel.ampDrivVol)];
    NSArray *arr4 = @[MergeStr(@"ACG",Zhengjistatusmodel.tAGC),MergeStr(@"功放电流",Zhengjistatusmodel.tAmpCuur),MergeStr(@"功放温度",Zhengjistatusmodel.ampTemperature),MergeStr(@"AC/DC2",Zhengjistatusmodel.ampPowVol)];
    
    NSArray *arr5 = @[MergeStr(@"过温保护",[Zhengjistatusmodel.tProtectTemp isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"反射保护",[Zhengjistatusmodel.tProtectreflect isEqualToString:@"0"]?@"正常":@"异常")];
    NSArray *arr6 = @[MergeStr(@"过流保护",[Zhengjistatusmodel.tProtectTemp isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"过激保护",[Zhengjistatusmodel.tProtect isEqualToString:@"0"]?@"正常":@"异常")];

    UIView *view1 = [self creatViewWith:arr1.count and:44+10 and:arr1 and:arr2];
    UIView *view2 = [self creatViewWith:arr3.count and:viewSpace+view1.frame.origin.y + view1.frame.size.height and:arr3 and:arr4];
    UIView *view3 = [self creatViewWith:arr5.count and:viewSpace+view2.frame.origin.y + view2.frame.size.height and:arr5 and:arr6];
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [subviewArr addObject:view3];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];
    [self.view insertSubview:view3 atIndex:0];
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

    
    NSArray *arr1 = @[MergeStr(@"设备名称",ShebeiInfomodel.devName),MergeStr(@"生产厂家",ShebeiInfomodel.manuFactory)];
    NSArray *arr2 = @[MergeStr(@"台站编码",ShebeiInfomodel.addrNo),@""];
    
    NSArray *arr3 = @[MergeStr(@"硬件版本号",ShebeiInfomodel.hardwareVersion),
                      MergeStr(@"产品型号",ShebeiInfomodel.modelNum),
                      MergeStr(@"设备纬度指示",[ShebeiInfomodel.latFlag isEqualToString:@"0"]?@"北纬":@"南纬"),
                      MergeStr(@"纬度",ShebeiInfomodel.latVal),
                      MergeStr(@"CPU序列号",ShebeiInfomodel.cpuNo)
                      ];
    
    NSArray *arr4 = @[MergeStr(@"软件版本号",ShebeiInfomodel.softwareVersion),
                      MergeStr(@"高度",ShebeiInfomodel.altitude),
                      MergeStr(@"设备经度指示",[ShebeiInfomodel.lonFlag isEqualToString:@"0"]?@"东经":@"西经"),
                      MergeStr(@"经度",ShebeiInfomodel.lonVal),@""];
    
    NSArray *arr5 = @[MergeStr(@"产品序列号",ShebeiInfomodel.serialNum),MergeStr(@"设备类型",ShebeiInfomodel.shebeitype)];
    
    NSArray *arr6 = @[MergeStr(@"功率等级",ShebeiInfomodel.transDev),@""];
   
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:arr2];
    UIView *view2 = [self creatViewWith:arr3.count and:viewSpace+view1.frame.origin.y + view1.frame.size.height and:arr3 and:arr4];
    UIView *view3 = [self creatViewWith:arr5.count and:viewSpace+view2.frame.origin.y + view2.frame.size.height and:arr5 and:arr6];
    
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [subviewArr addObject:view3];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];
    [self.view insertSubview:view3 atIndex:0];

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

    NSArray *arr1 = @[MergeStr(@"MAC地址",Tongxinjiekoumodel.macAddr),MergeStr(@"掩码",Tongxinjiekoumodel.ipMask),MergeStr(@"IP地址",Tongxinjiekoumodel.ipAddr),MergeStr(@"网关",Tongxinjiekoumodel.ipGateway)];
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:nil];
    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];
}
#pragma mark -- 内容
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

        self.nameArr = @[@"系统信息",@"调制解调器",@"发射机",@"通信接口",@"无线终端"];
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
            VVDLog(@"selected == %ld",arrindex);
                switch (arrindex-500) {
                    case 0:
                        weakself.jiankong50WType = ShebeiInfo;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                    case 1:
                        weakself.jiankong50WType = Jiliqi;
                        weakself.titleBtn.Btnwidth = 120;
                        weakself.titleBtn.BtnX = 10;
                        break;
                    case 2:
                        weakself.jiankong50WType = Fasheji;
                        weakself.titleBtn.Btnwidth = 80;
                        weakself.titleBtn.BtnX = 30;
                        break;
                    case 3:
                        weakself.jiankong50WType = TongxinJiekou;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
                        break;
                    case 4:
                        weakself.jiankong50WType = WuxianZhongduan;
                        weakself.titleBtn.Btnwidth = 90;
                        weakself.titleBtn.BtnX = 20;
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
#pragma mark -- delegate
- (void)scrollviewDidselectdWithSeletedIndex:(NSInteger)index andViewTag:(NSInteger)viewTag{
   // selfindex = index;
    if (viewTag == 1001) {
        switch (index) {
            case 1:
                [self createZhengjistatusWith:dbStr];
                break;
            case 2:
                [self createZhengjiControlwith:dbStr];
                break;
            default:
                break;
        }
    }
    if (viewTag == 1002) {
        
        switch (index) {
            case 1:
                [self createDTUnormal50WWith:dbStr];
                break;
            case 2:
                [self createDTUabnormal50With:dbStr];
                break;
            default:
                break;
        }
    }
    
}

@end
