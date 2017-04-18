//
//  FSJJiankong500W.m
//  FSJ
//
//  Created by Monstar on 2017/3/16.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJJiankong50W.h"

#import "FSJTitleBtn.h"
#import "FSJJKPopView.h"
#import "FSJShebeiInfo50W.h"
#import "FSJScrollBtnView.h"

#import "FSJPageView.h"
#define rowHeight 26
#define pageHeight 80
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
    NSString *fromStr;
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
   [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    
    //NSArray *titleArray = @[@"系统信息",@"调制解调器",@"发射机",@"通信接口",@"无线终端"];
    //控制参数from
    fromStr = dbStr;
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
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
  
    switch (self.jiankong50WType) {
        case ShebeiInfo:
            [self createShebeiInfoViewWith:str];
            navTitle = @"系统信息";
            break;
        case Jiliqi:
            
            [self createJiliqiHeader];

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
    FSJScrollBtnView *fashejiView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) andItemFrame:CGRectMake(0, 0, WIDTH/4, 44) andtitleColor:[UIColor blackColor] andselTitleColor:SystemBlueColor andbgColor:SystemWhiteColor andselBgColor:SystemWhiteColor andviewTag:1002 andtitleArray:@[@"常用参数",@"不常用参数"] andViewDirection:0 andShowshadow:YES andSelectIndex:1];
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
        if ([model.status isEqualToString:@"200"]) {
        
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
  
    NSArray *arr1 = @[MergeStr(@"DTU ID",FSJDTUnormal50WModel.dtu_id),MergeStr(@"监控IP",FSJDTUnormal50WModel.spy_ip),MergeStr(@"监控端口号",FSJDTUnormal50WModel.spy_port),MergeStr(@"DTU 密码",FSJDTUnormal50WModel.dtu_pwd),MergeStr(@"监控域名",FSJDTUnormal50WModel.spy_domin),MergeStr(@"心跳包间隔",FSJDTUnormal50WModel.heartbeat)];
    
    
    UIView *view1 = [self creatWiderViewWith:arr1.count and:44+10 and:arr1 and:nil];
    
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
    
    NSArray *arr1 = @[MergeStr(@"网络通信协议",FSJDTUabNormal50WModel.network),
                      MergeStr(@"DTU重登陆模式",FSJDTUabNormal50WModel.dtu_login_mode),
                      MergeStr(@"串口参数",FSJDTUabNormal50WModel.seri_param),
                      MergeStr(@"APN名称",FSJDTUabNormal50WModel.apn_name),
                      ];
    NSArray *arr2 = @[
                       MergeStr(@"APN访问密码",FSJDTUabNormal50WModel.apn_pwd),
                      MergeStr(@"串口波特率",FSJDTUabNormal50WModel.seri_date),
                      MergeStr(@"串口流控",FSJDTUabNormal50WModel.seri_flow),
                      MergeStr(@"APN访问用户名",FSJDTUabNormal50WModel.apn_username),
                      ];
    NSArray *arr3 = @[MergeStr(@"DNS IP",FSJDTUabNormal50WModel.dns_ip),
                      MergeStr(@"数据采集中心2IP",FSJDTUabNormal50WModel.data_2ip),
                      MergeStr(@"数据采集中心2域名",FSJDTUabNormal50WModel.data_2name),
                      MergeStr(@"数据采集中心3IP",FSJDTUabNormal50WModel.data_3ip),
                      MergeStr(@"数据采集中心3域名",FSJDTUabNormal50WModel.data_3name),
                       MergeStr(@"DTU电话号码",FSJDTUabNormal50WModel.dtu_phone_num),];

    
    UIView *view1 = [self creatWiderViewWith:arr1.count and:44+10 and:arr1 and:arr2];
    UIView *view2 = [self creatWiderViewWith:arr3.count and:view1.frame.origin.y+view1.frame.size.height+10 and:arr3 and:nil];
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];
}
#pragma mark -- 调制解调器
- (void)createJiliqiHeader{
    FSJScrollBtnView *fashejiView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) andItemFrame:CGRectMake(0, 0, WIDTH/4, 44) andtitleColor:[UIColor blackColor] andselTitleColor:SystemBlueColor andbgColor:SystemWhiteColor andselBgColor:SystemWhiteColor andviewTag:1003 andtitleArray:@[@"通用参数",@"输入参数",@"输出参数",@"单频网参数",@"工作状态"] andViewDirection:0 andShowshadow:YES andSelectIndex:1];
    fashejiView.delegate = self;
    [self.view addSubview:fashejiView];
    //pageView 分页控制
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":fromStr};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:JiliqiLunbo50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            [self createJiliqiwith:fromStr andindex:1];
            FSJJiliqiLunbo50W *lunboModel = [FSJJiliqiLunbo50W initWithDictionary:model.data];
            NSArray *statusArr = @[lunboModel.eStatus,
                                   lunboModel.GPS,
                                   @"3",@"3",
                                   lunboModel.inputStatus1,
                                   lunboModel.outStatus1,
                                   lunboModel.inputStatus2,
                                   lunboModel.outStatus2 ,
                                   lunboModel.inputStatus3 ,
                                   lunboModel.outStatus3 ,
                                   lunboModel.inputStatus4,
                                   lunboModel.outStatus4];
         
            NSArray *arr1 = @[@"状态        ",@"GPS        ",@"TUNER输入状态",@"RF输出状态",
                              MergeStr1(@"CH1       ",lunboModel.input1Freq),
                              MergeStr1(@"CH1       ",lunboModel.output1Freq),
                              MergeStr1(@"CH2       ",lunboModel.input2Freq),
                              MergeStr1(@"CH2       ",lunboModel.output2Freq),
                              MergeStr1(@"CH3       ",lunboModel.input3Freq),
                              MergeStr1(@"CH3       ",lunboModel.output3Freq),
                              MergeStr1(@"CH4       ",lunboModel.input4Freq),
                              MergeStr1(@"CH4       ",lunboModel.output4Freq)];
            FSJPageView *pageView = [[FSJPageView alloc]initWithFrame:CGRectMake(0, 45, WIDTH, pageHeight) andLabelArray:arr1 andStatusArray:statusArr andColumnNum:2 andRownNum:2 anditemSize:CGSizeMake(WIDTH/2, rowHeight) andiamgeX:33 andShowPage:YES];
            pageView.timeInterval = 5;
            [pageView startTimer];
            [self.view addSubview:pageView];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

- (void)createJiliqiwith:(NSString *)str andindex:(NSInteger)selectedIndex{
    
            switch (selectedIndex) {
                case 1:
                   [self createJiliqiView];
                    break;
                case 2:
                    [self createRfViewwithSelIndex:1];
                    break;
                case 3:
                    [self createPipeViewwithSelIndex:1];
                    break;
                case 4:
                    [self createDanViewwithSelIndex:1];
                    break;
                case 5:
                    [self createWorkStatus];
                    break;
                default:
                    break;
            }
}

#pragma mark --- 调制解调器&&通用参数
- (void)createJiliqiView{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":fromStr};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:JiliqiTongyong50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
                FSJJiliqi50W *basemodel = [FSJJiliqi50W initWithDictionary:model.data];
                
                NSArray *arr1 = @[MergeStr(@"序列号",basemodel.eCpuNum),
                                  MergeStr(@"激励器类型",basemodel.eType),
                                  MergeStr(@"激励器温度",basemodel.eTemper),
                                  MergeStr(@"射频输出总开关",[basemodel.eRFOutputSwitch isEqualToString:@"0"]?@"关闭":@"打开"),
                                  MergeStr(@"射频输出总衰减",basemodel.eSingleFreNetAddr)
                                  
                                  ];
                
                UIView *view1 = [self creatWiderViewWith:arr1.count and:44+10+80+10 and:arr1 and:nil];
                
                [subviewArr addObject:view1];
                [self.view insertSubview:view1 atIndex:0];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark --- 调制解调器&&输入参数
- (void)createRfViewwithSelIndex:(NSInteger)rfindex{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":fromStr,@"index":[NSString stringWithFormat:@"%ld",rfindex]};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:JiliqiInput50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"]) {
          //  NSDictionary *inputDic = model.data;
            NSDictionary *dic = [model.data objectForKey:[NSString stringWithFormat:@"%ld",rfindex]];
            FSJJiliqiRf50W *  rfmodel = [FSJJiliqiRf50W initWithDictionary:dic];
            
                        FSJScrollBtnView *rfScroView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 44+10+80+10+10, WIDTH/4, 300) andItemFrame:CGRectMake(0, 0, WIDTH/4, 60) andtitleColor:[UIColor blackColor] andselTitleColor:[UIColor blackColor] andbgColor:SystemLightGrayColor andselBgColor:SystemWhiteColor andviewTag:10032 andtitleArray:@[@"Tuner1",@"Tuner2",@"Tuner3",@"Tuner4"] andViewDirection:1 andShowshadow:YES andSelectIndex:rfindex];
            rfScroView.delegate = self;
            [subviewArr addObject:rfScroView];
            [self.view addSubview:rfScroView];
            
            
            if (rfmodel) {

                NSArray *arr1 = @[ MergeStr2(@"输入频率",rfmodel.eDemoRFFreq),
                                   MergeStr2(@"输入宽带",rfmodel.eDemoRFBroadBand),
                                   MergeStr2(@"输入IQ倒置",rfmodel.eDemoRFIQ),
                                   MergeStr2(@"输入信噪比SNR",rfmodel.eRFInputSNR),
                                   MergeStr2(@"输入码率",rfmodel.eRFInputRate),
                                   @"输入状态:"];

                NSArray *arr2 = @[@"3",@"3",@"3",@"3",@"3",[rfmodel.eRFInputStatus isEqualToString:@"0"]?@"0":@"1"];
                
                FSJPageView *pageView = [[FSJPageView alloc]initWithFrame:CGRectMake(WIDTH/4, 44+10+80+10+10, WIDTH/4*3, 300) andLabelArray:arr1 andStatusArray:arr2 andColumnNum:1 andRownNum:6 anditemSize:CGSizeMake(WIDTH/2, rowHeight) andiamgeX:65 andShowPage:NO];
                pageView.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
                pageView.layer.shadowOpacity = 0.5;
                pageView.layer.shadowRadius  = 1;
                [subviewArr addObject:pageView];
                [self.view insertSubview:pageView atIndex:0];
            }
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark --- 调制解调器&&输出参数
- (void)createPipeViewwithSelIndex:(NSInteger)rfindex{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":fromStr,@"index":[NSString stringWithFormat:@"%ld",rfindex]};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:JiliqiOutput50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            NSDictionary *dic = [model.data objectForKey:[NSString stringWithFormat:@"%ld",rfindex]];

            FSJJiliqiPipe50W *pipemodel = [FSJJiliqiPipe50W initWithDictionary:dic];
   
            FSJScrollBtnView *pipeScroView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 44+10+80+10+10, WIDTH/4, 300) andItemFrame:CGRectMake(0, 0, WIDTH/4, 60) andtitleColor:[UIColor blackColor] andselTitleColor:[UIColor blackColor] andbgColor:SystemLightGrayColor andselBgColor:SystemWhiteColor andviewTag:10033 andtitleArray:@[@"通道1",@"通道2",@"通道3",@"通道4"] andViewDirection:1 andShowshadow:YES andSelectIndex:rfindex];
            pipeScroView.delegate = self;
            [subviewArr addObject:pipeScroView];
            [self.view addSubview:pipeScroView];
            
            
            if (pipemodel) {
               
                NSArray *arr1 = @[ MergeStr(@"组网模式",[pipemodel.eChOutputNetWay isEqualToString:@"0"]?@"多频网直通模式":@"单频网地面模式"),
                                   MergeStr(@"输出频率",pipemodel.eChOutputFreq),
                                   MergeStr(@"调制模式",pipemodel.eChOutputLDPCQAM),
                                   MergeStr(@"载波",[pipemodel.eChOutputCarrWay isEqualToString:@"0"]?@"多载波":@"单载波"),
                                   MergeStr(@"帧头",pipemodel.eChOutputFrameMode),
                                   MergeStr(@"相位 ",[pipemodel.eChOutputPNPh isEqualToString:@"0"]?@"旋转":@"固定"),
                                   MergeStr(@"时域交织",[pipemodel.eChOutputMixMode isEqualToString:@"0"]?@"240":@"720"),
                                   MergeStr(@"导频",[pipemodel.eChOutputPilotSwitch isEqualToString:@"0"]?@"关":@"开"),
                                   MergeStr(@"单音开关",[pipemodel.eChOutputStoneSwitch isEqualToString:@"0"]?@"关":@"开"),
                                   MergeStr(@"衰减",pipemodel.eChLevelAtte),
                                   MergeStr(@"射频开关",[pipemodel.eChCodeStreamStatus isEqualToString:@"0"]?@"关闭":@"开启")];
                
                UIView *view1 = [self creatLeftViewWith:arr1.count and:44+10+80+10+10 and:arr1 and:nil];
                [subviewArr addObject:view1];
                [self.view insertSubview:view1 atIndex:0];
            }
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
#pragma mark --- 调制解调器&&单频网参数
- (void)createDanViewwithSelIndex:(NSInteger)danindex{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":fromStr,@"index":[NSString stringWithFormat:@"%ld",danindex]};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:JiliqiDanpin50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            NSDictionary *dic = [model.data objectForKey:[NSString stringWithFormat:@"%ld",danindex]];
             FSJJiliqiPipe50W *pipemodel =[FSJJiliqiPipe50W initWithDictionary:dic];
     
            FSJScrollBtnView *pipeScroView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 44+10+80+10+10+rowHeight+10, WIDTH/4, 300) andItemFrame:CGRectMake(0, 0, WIDTH/4, 60) andtitleColor:[UIColor blackColor] andselTitleColor:[UIColor blackColor] andbgColor:SystemLightGrayColor andselBgColor:SystemWhiteColor andviewTag:10034 andtitleArray:@[@"通道1",@"通道2",@"通道3",@"通道4"] andViewDirection:1 andShowshadow:YES andSelectIndex:danindex];
            pipeScroView.delegate = self;
            [subviewArr addObject:pipeScroView];
            [self.view addSubview:pipeScroView];
            
            UIView *netAddress = [[UIView alloc]initWithFrame:CGRectMake(0, 44+10+80+10+10, WIDTH, rowHeight+10)];
            netAddress.backgroundColor = SystemWhiteColor;
            UILabel *netAddressLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, WIDTH, rowHeight)];
            netAddressLabel.font = [UIFont systemFontOfSize:14];
            netAddressLabel.text = MergeStr(@"单频网地址(HEX)", [model.data objectForKey:@"eSingleFreNetAddr"]?[model.data objectForKey:@"eSingleFreNetAddr"]:@"");
            UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, netAddress.frame.size.height-1, WIDTH, 1)];
            line.backgroundColor = SystemLightGrayColor;
            [netAddress addSubview:line];
            [netAddress addSubview:netAddressLabel];
            [subviewArr addObject:netAddress];
            [self.view insertSubview:netAddress atIndex:0];
           
            if (pipemodel) {
                
            NSArray *arr1 = @[MergeStr(@"SIP时延",pipemodel.eChSingleNetDelay),
                              MergeStr(@"设备器时延",pipemodel.eRFInputSingleNetDelay),
                              MergeStr(@"寻址时延",pipemodel.eChAddrDelay),
                              MergeStr(@"寻址开关 ",[pipemodel.eChAddrDelaySwitch isEqualToString:@"0"]?@"关闭":@"开启")];
            UIView *view1 = [self creatLeftViewWith:arr1.count and:44+10+80+10+10+10+rowHeight and:arr1 and:nil];
            [subviewArr addObject:view1];
            [self.view insertSubview:view1 atIndex:0];
            }
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}
#pragma mark --- 调制解调器&&工作状态
- (void)createWorkStatus{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":fromStr};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:JiliqiWorkStatus50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
  
            FSJJiliqiStatus50W *statusmodel = [FSJJiliqiStatus50W initWithDictionary:model.data];
            NSArray *arr1 = @[@"恒温晶振:",@"GPS模块:",@"GPS锁定:",@"设备温度:",@"1PPS状态:",@"总输出增益:",@"内存状态:",@"通道1SIP包:",@"通道2SIP包:",@"通道3SIP包:",@"通道4SIP包:"];
            
            NSArray *arr2 = @[statusmodel.oven,statusmodel.GPS,statusmodel.GPSlock,statusmodel.temper,statusmodel.onepps,statusmodel.over,statusmodel.store,statusmodel.SIP1,statusmodel.SIP2,statusmodel.SIP3,statusmodel.SIP4];
            FSJPageView *pageView = [[FSJPageView alloc]initWithFrame:CGRectMake(0, 44+10+80+10, WIDTH, 7*rowHeight+10) andLabelArray:arr1 andStatusArray:arr2 andColumnNum:2 andRownNum:6 anditemSize:CGSizeMake(WIDTH/2, rowHeight) andiamgeX:80 andShowPage:NO];
            pageView.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
            pageView.layer.shadowOpacity = 0.5;
            pageView.layer.shadowRadius  = 1;
            [subviewArr addObject:pageView];
            [self.view insertSubview:pageView atIndex:0];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}

#pragma mark -- 发射机
- (void)createFashejiWith:(NSString *)str{
    
    FSJScrollBtnView *fashejiView = [[FSJScrollBtnView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44) andItemFrame:CGRectMake(0, 0, WIDTH/4, 44) andtitleColor:[UIColor blackColor] andselTitleColor:SystemBlueColor andbgColor:SystemWhiteColor andselBgColor:SystemWhiteColor andviewTag:1001 andtitleArray:@[@"数据监控",@"功能控制"] andViewDirection:0 andShowshadow:YES andSelectIndex:1];
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
    NSArray *arr1 = @[MergeStr(@"功率控制状态",[Zhengjicontrolmodel.tWorkAuto isEqualToString:@"0"]?@"手动":@"自动")];
   // NSArray *arr2 = @[MergeStr(@"功率控制状态",@"")];
    
    NSArray *arr3 = @[MergeStr(@"温度保护开关",[Zhengjicontrolmodel.protSwitch1 isEqualToString:@"0"]?@"开启":@"关闭"),
                      MergeStr(@"驻波保护开关",[Zhengjicontrolmodel.protSwitch2 isEqualToString:@"0"]?@"开启":@"关闭"),
                      MergeStr(@"过温阀值",Zhengjicontrolmodel.tempThre),
                      MergeStr(@"驻波阀值",Zhengjicontrolmodel.vswrHigh)];
                      
    NSArray *arr4 = @[MergeStr(@"电流保护开关",[Zhengjicontrolmodel.protSwitch0 isEqualToString:@"0"]?@"开启":@"关闭"),
                      MergeStr(@"过激开关",[Zhengjicontrolmodel.protSwitch3 isEqualToString:@"0"]?@"开启":@"关闭"),
                      MergeStr(@"过流阀值",Zhengjicontrolmodel.tCuurThre),
                      MergeStr(@"过激阀值",Zhengjicontrolmodel.tInputPowThreHigh)];
    
    UIView *view1 = [self creatViewWith:arr1.count and:44+10 and:arr1 and:nil];
    UIView *view2 = [self creatViewWith:arr3.count and:44+10+rowHeight +20  and:arr3 and:arr4];
    view1.layer.borderColor = SystemYellowColor.CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.shadowOffset  =  CGSizeMake(0, 0);
    view1.layer.shadowOpacity = 0;
    view1.layer.shadowRadius  = 0;
       
    [subviewArr addObject:view1];
    [subviewArr addObject:view2];
    [self.view insertSubview:view1 atIndex:0];
    [self.view insertSubview:view2 atIndex:0];

}
#pragma mark -- 发射机 数据监控
- (void)createZhengjistatusWith:(NSString *)str{
    NSDictionary *dic = @{@"deviceId":self.fsjId,@"jwt":jwtStr,@"from":str};
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:ZhengjiStatus50W requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"]) {
  
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
  
    NSArray *arr1 = @[MergeStr(@"输出功率",Zhengjistatusmodel.tOutputPow)];
    NSArray *arr2 = @[MergeStr(@"反射功率",Zhengjistatusmodel.tRefPow)];
    
    NSArray *arr3 = @[MergeStr(@"输入功率",Zhengjistatusmodel.tmasterInputPower),MergeStr(@"前置功能",Zhengjistatusmodel.tSwr),MergeStr(@"环境温度",Zhengjistatusmodel.tEnviTemp),MergeStr(@"AC/DC1",Zhengjistatusmodel.ampDrivVol)];
    NSArray *arr4 = @[MergeStr(@"ACG电压",Zhengjistatusmodel.tAGC),MergeStr(@"工作电源",Zhengjistatusmodel.tAmpCuur),MergeStr(@"功放温度",Zhengjistatusmodel.ampTemperature),MergeStr(@"AC/DC2",Zhengjistatusmodel.ampPowVol)];
    
    NSArray *arr5 = @[MergeStr(@"过温保护",[Zhengjistatusmodel.tProtectTemp isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"反射保护",[Zhengjistatusmodel.tProtectreflect isEqualToString:@"0"]?@"正常":@"异常")];
    NSArray *arr6 = @[MergeStr(@"过流保护",[Zhengjistatusmodel.tProtectTemp isEqualToString:@"0"]?@"正常":@"异常"),MergeStr(@"过激保护",[Zhengjistatusmodel.tProtect isEqualToString:@"0"]?@"正常":@"异常")];

    UIView *view1 = [self creatViewWith:arr1.count and:44+10 and:arr1 and:arr2];
    view1.layer.borderColor = SystemYellowColor.CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.shadowOffset  =  CGSizeMake(0, 0);
    view1.layer.shadowOpacity = 0;
    view1.layer.shadowRadius  = 0;
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
   
    NSArray *arr1 = @[MergeStr(@"系统名称",ShebeiInfomodel.devName),
                      MergeStr(@"台站编码",ShebeiInfomodel.addrNo),
                      MergeStr(@"生产厂家",ShebeiInfomodel.manuFactory)];
    
    NSArray *arr3 = @[MergeStr(@"硬件版本号",ShebeiInfomodel.hardwareVersion),
                      MergeStr(@"产品型号",ShebeiInfomodel.modelNum),
                      MergeStr(@"经度指示",[ShebeiInfomodel.lonFlag isEqualToString:@"0"]?@"东经":@"西经"),
                      MergeStr(@"经度",ShebeiInfomodel.lonVal),
                      MergeStr(@"CPU序列号",ShebeiInfomodel.cpuNo)
                      ];
    NSArray *arr4 = @[MergeStr(@"软件版本号",ShebeiInfomodel.softwareVersion),
                      MergeStr(@"纬度指示",[ShebeiInfomodel.latFlag isEqualToString:@"0"]?@"北纬":@"南纬"),
                      MergeStr(@"纬度",ShebeiInfomodel.latVal),
                      MergeStr(@"高度",ShebeiInfomodel.altitude),
                     @""];
    NSArray *arr5 = @[MergeStr(@"产品序列号",ShebeiInfomodel.serialNum),
                      MergeStr(@"设备类型码",ShebeiInfomodel.shebeitype),
                      MergeStr(@"功率等级",ShebeiInfomodel.transDev)];
    
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:nil];
    view1.layer.borderColor = SystemYellowColor.CGColor;
    view1.layer.borderWidth = 1;
    view1.layer.shadowOffset  =  CGSizeMake(0, 0);
    view1.layer.shadowOpacity = 0;
    view1.layer.shadowRadius  = 0;
    UIView *view2 = [self creatViewWith:arr3.count and:viewSpace+view1.frame.origin.y + view1.frame.size.height and:arr3 and:arr4];
    UIView *view3 = [self creatViewWith:arr5.count and:viewSpace+view2.frame.origin.y + view2.frame.size.height and:arr5 and:nil];
    
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
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
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
    NSArray *arr1 = @[MergeStr(@"MAC地址",Tongxinjiekoumodel.macAddr),MergeStr(@"掩码",Tongxinjiekoumodel.ipMask),MergeStr(@"IP地址",Tongxinjiekoumodel.ipAddr),MergeStr(@"网关",Tongxinjiekoumodel.ipGateway)];
    UIView *view1 = [self creatViewWith:arr1.count and:10 and:arr1 and:nil];
    [subviewArr addObject:view1];
    [self.view insertSubview:view1 atIndex:0];
}
#pragma mark -- 内容
- (UIView *)creatViewWith:(NSInteger)num and:(CGFloat)y and:(NSArray*)firstLabel and:(NSArray*) secondLabel andbgFrame:(CGRect)bgfame{
    UIView *smallview = [[UIView alloc]initWithFrame:bgfame];
    UIScrollView *scroView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, bgfame.size.width, bgfame.size.height)];
    scroView.contentSize = CGSizeMake(bgfame.size.width, num*rowHeight+20);
    scroView.backgroundColor = SystemWhiteColor;
    smallview.layer.shadowOffset  =  CGSizeMake(1.0f, 1.0f);
    smallview.layer.shadowOpacity = 0.5;
    smallview.layer.shadowRadius  = 1;
    
    for (int i = 0; i < num; i ++) {
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(bgfame.origin.x==0?12:5, 5+rowHeight*i , scroView.frame.size.width, rowHeight)];
        label1.text = firstLabel[i];
        
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(scroView.frame.size.width/2+WIDTH*0.05, 5+rowHeight*i, scroView.frame.size.width/2, rowHeight)];
        label2.text = secondLabel[i];
        label1.backgroundColor = label2.backgroundColor = [UIColor clearColor];
        label1.font = label2.font = [UIFont systemFontOfSize:14];
        [subviewArr addObject:label1];
        [subviewArr addObject:label2];
        
        [scroView addSubview:label1];
        [scroView addSubview:label2];
    }
    [smallview addSubview:scroView];
    return smallview;
}

- (UIView *)creatViewWith:(NSInteger)num and:(CGFloat)y and:(NSArray*)firstLabel and:(NSArray*) secondLabel{
    return  [self creatViewWith:num and:y and:firstLabel and:secondLabel andbgFrame:CGRectMake(WIDTH *0.05, y, WIDTH *0.9, rowHeight *num + 10)];
    
}
- (UIView *)creatWiderViewWith:(NSInteger)num and:(CGFloat)y and:(NSArray*)firstLabel and:(NSArray*) secondLabel{
    return  [self creatViewWith:num and:y and:firstLabel and:secondLabel andbgFrame:CGRectMake(0, y, WIDTH, rowHeight *num + 10)];
}
- (UIView *)creatLeftViewWith:(NSInteger)num and:(CGFloat)y and:(NSArray*)firstLabel and:(NSArray*) secondLabel{
    return  [self creatViewWith:num and:y and:firstLabel and:secondLabel andbgFrame:CGRectMake(WIDTH/4, y, WIDTH*3/4, 300)];
}
- (void)shuaxin:(UIButton *)sender{
    for (UIView *view in self.view.subviews) {
        if (view.frame.origin.y >0 ) {
            [view removeFromSuperview];
        }
    }
    fromStr = deviceStr;
    [self createViewWithFrom:fromStr];
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
    
    for (UIView *view in subviewArr) {
        [view removeFromSuperview];
    }
   
    if (viewTag == 1001) {
        switch (index) {
            case 1:
                [self createZhengjistatusWith:fromStr];
                break;
            case 2:
                [self createZhengjiControlwith:fromStr];
                break;
            default:
                break;
        }
    }
    if (viewTag == 1002) {
        
        switch (index) {
            case 1:
                [self createDTUnormal50WWith:fromStr];
                break;
            case 2:
                [self createDTUabnormal50With:fromStr];
                break;
            default:
                break;
        }
    }
    if (viewTag == 1003) {
        [self createJiliqiwith:fromStr andindex:index];
        
    }
    if (viewTag == 10032) {
        [self createRfViewwithSelIndex:index];
        
    }
    if (viewTag == 10033) {
        [self createPipeViewwithSelIndex:index];
    }
    if (viewTag == 10034) {
        [self createDanViewwithSelIndex:index];
    }
}

@end
