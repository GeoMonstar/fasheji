//
//  FSJPeopleManagimentviewController.m
//  FSJ
//
//  Created by Monstar on 16/3/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJPeopleManagimentviewController.h"
#import "FSJPeopleManagerDetailViewController.h"
#import "FSJOneFSJTableViewCell.h"
#import "FSJDetailTableViewCell.h"
#import "FSJSecondDetailTableViewCell.h"
#import "FSJJiankongVC.h"
#import "FSJOganTree.h"
#import "FSJStationInfo.h"
#import "FSJJiankong50W.h"
#import "FSJPeopleManagerDetailTableViewCell.h"
@interface FSJPeopleManagimentviewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>{
    UISearchBar     *mysearchBar;
    FSJJiankongVC   *jiankong;
    NSString        *jwt;
    //NSMutableArray *dataArray;
    NSMutableDictionary    *netdic;
    NSString        *url;
    NSInteger       count;
    FSJPeopleManagerDetailViewController *detail;
    FSJResultList   *transmodel;
    BOOL            isDraggingDown;
    NSMutableArray  *tempArr;
    NSString        *placeHolder;
    NSArray         *jiankongArr;
    NSArray         *jiankongimgArr;
    
    NSMutableArray *firstNameArr;
    NSMutableArray *seconNamedArr;
    NSMutableArray *thridNameArr;
    NSMutableArray *forthNameArr;
    
    NSInteger columnNumber;
    NSString *FirstLevelStr;
    NSString *onceOrangId;
    NSString *twiceOrangId;
    NSString *thirdOrangId;
    
    NSInteger TableHeight;
    NSString *staticOrganId;
    NSString *staticStationId;
    
    BOOL firstClicked;
    BOOL secondClicked;
    NSInteger datacount;
    //BOOL secondClicked;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *myTable;
@property (nonatomic,strong)NSMutableArray *firstArr;
@property (nonatomic,strong)NSMutableArray *secondArr;
@property (nonatomic,strong)NSMutableArray *thridArr;
@property (nonatomic,strong)NSMutableArray *forthArr;
@property (nonatomic,strong)DOPDropDownMenu *menu;
@end

@implementation FSJPeopleManagimentviewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[].mutableCopy;
    }
    return _dataArray;
}
- (UITableView *)myTable{
    if (_myTable == nil) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, TableHeight, WIDTH, HEIGH-TableHeight-64) style:UITableViewStyleGrouped];
        _myTable.delegate = self;
        _myTable.dataSource = self;
    }
    return _myTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    firstNameArr = @[].mutableCopy;
    seconNamedArr = @[].mutableCopy;
    thridNameArr = @[].mutableCopy;
    forthNameArr = @[].mutableCopy;
    self.thridArr = @[].mutableCopy;
    self.secondArr = @[].mutableCopy;
    self.firstArr = @[].mutableCopy;
    self.forthArr = @[].mutableCopy;
    
    self.view.backgroundColor = SystemWhiteColor;
    count = 1;
    [self createNav];
    [self getInterest];
    jwt = [[FSJUserInfo shareInstance] userAccount].jwt;
    if(self.InfoType == Warning || self.InfoType == Warned ){
        TableHeight = 0;
    }else{
        TableHeight =44;
        [self getTree];
    }
    
    [self createTableViewWithorganId:@""andstationId:@""];
    
}
- (void)getInterest{
    
    NSDictionary *dic = @{@"jwt":[[FSJUserInfo shareInstance] userAccount].jwt};
    [FSJNetworking networkingGETWithActionType:GetInterestList requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        
        FSJCommonModel *model = [FSJCommonModel initWithDictionary:responseObject];
        NSString *gradeType = [[FSJUserInfo shareInstance] userAccount].areaType;
        
        if ([model.status isEqualToString:@"200"]) {
            
            for (NSDictionary *dict in model.list) {
                 NSString *namestr = [dict objectForKey:@"sname"];
                if ([gradeType isEqualToString:@"1"]) {
                    [forthNameArr addObject:namestr];
                     [self.forthArr addObject:dict];
                }
                if ([gradeType isEqualToString:@"2"]) {
                      [thridNameArr addObject:namestr];
                    [self.thridArr addObject:dict];
                    
                }
                if ([gradeType isEqualToString:@"3"]) {
                    [seconNamedArr addObject:namestr];
                    
                    [self.secondArr addObject:dict];
                }
            }
        }else{
            [MBProgressHUD showError:@"无返回数据"];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
       
    }];
}
- (void)createTableViewWithorganId:(NSString *)organId andstationId:(NSString *)stationIdStr{
    [self.myTable registerNib:[UINib nibWithNibName:@"FSJDetailTableViewCell"bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"oneCELL"];
    [self.myTable registerNib:[UINib nibWithNibName:@"FSJSecondDetailTableViewCell"bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"twoCELL"];
    [self.myTable registerNib:[UINib nibWithNibName:@"FSJPeopleManagerDetailTableViewCell"bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"threeCELL"];
    [self.view addSubview:self.myTable];
    if (self.InfoType == PeopleManage) {
        placeHolder = @"请输入发射站名称";
        netdic = @{@"stationId":stationIdStr,@"organId":organId==nil?@"":organId,@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt}.mutableCopy;
        url = @"/rs/app/station/manager/list";
    }
    if (self.InfoType == StationManage) {
        placeHolder = @"请输入发射站名称";
        netdic = @{@"stationId":stationIdStr,@"organId":organId==nil?@"":organId,@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt}.mutableCopy;
        url = @"/rs/app/station/list";
    }
    if (self.InfoType == FSJManage) {
        placeHolder = @"请输入发射机名称";
        netdic = @{@"stationId":stationIdStr,@"organId":organId==nil?@"":organId,@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt}.mutableCopy;
        url = @"/rs/app/station/transmitter/list";
    }
    if (self.InfoType == Warning) {
        placeHolder = @"请输入发射站、发射机名称";
        netdic = @{@"organId":organId==nil?@"":organId,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt}.mutableCopy;
        url = @"/rs/app/alarm/list";
    }
    if (self.InfoType == Warned) {
         placeHolder = @"请输入发射站、发射机名称";
        netdic = @{@"organId":organId==nil?@"":organId,@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt}.mutableCopy;
        url = @"/rs/app/alarm/history/list";
    }
    FSJWeakSelf(weakself);
    self.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadDataWhenDraggingDown];
    }];
     [mysearchBar setPlaceholder:placeHolder];
    
    // 设置表格视图的触底加载(上拉刷新)
    self.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        isDraggingDown = NO;
        VVDLog(@"dataArray.count == %ld",8*count);
        
        if (weakself.dataArray.count > 0 &&weakself.dataArray.count == 8*count ) {
            [weakself loadDataWhenReachingBottom];
        }
        else {
            [weakself endRefreshing];
        }
    }];
   // [self loadDataWhenDraggingDown];
    [self startNetworkWith:url andDic:netdic];
}
- (void) loadDataWhenDraggingDown {
    count =1;
    isDraggingDown = YES;
    
    [netdic setValue:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"pageNo"];
    [self startNetworkWith:url andDic:netdic];
}
// 触底加载数据的方法
- (void) loadDataWhenReachingBottom {
    count ++;
    isDraggingDown = NO;
    
    [netdic setValue:[NSString stringWithFormat:@"%ld",(long)count] forKey:@"pageNo"];
    [self startNetworkWith:url andDic:netdic];
}
// 结束下拉或上拉刷新状态
- (void) endRefreshing {
    if (isDraggingDown) {
        [self.myTable.mj_header endRefreshing];
    }
    else {
        [self.myTable.mj_footer endRefreshing];
    }
}
- (void)startNetworkWith:(NSString *)neturl andDic:(NSDictionary *)dict{
    
    [FSJNetworking networkingGETWithURL:neturl requestDictionary:dict success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJCommonModel *model = [FSJCommonModel initWithDictionary:responseObject];
         NSMutableArray *tempArray = [NSMutableArray array];
        if ([model.status isEqualToString:@"200"]) {
            for (NSDictionary *dict in model.list) {
                FSJResultList *listmodle = [FSJResultList initWithDictionary:dict];
                [tempArray addObject:listmodle];
            }
            if (tempArray.count >0) {
                if (count == 1 && self.dataArray.count >0) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:tempArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myTable reloadData];
                     [self endRefreshing];
                });
                
            }else{
                [self.dataArray removeAllObjects];
                [self.myTable reloadData];
                [self endRefreshing];
            }
        }
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     FSJResultList *model = self.dataArray[indexPath.section];
    if (self.InfoType == FSJManage) {
        FSJDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"oneCELL"];
        cell.topLabel.text = [NSString stringWithFormat:@"%@ ", model.tname];
        cell.secondLabel.text  = [NSString stringWithFormat:@"所属区域:%@  ",model.areaName];
        cell.thridLabel.text = [NSString stringWithFormat:@"所属发射站:%@  功率等级:%@  ", model.sname,model.powerRate];
        switch (model.state.integerValue) {
            case 0:
                cell.headView.image = [UIImage imageNamed:@"APPgreen.png"];
                break;
            case 1:
                cell.headView.image = [UIImage imageNamed:@"APPred"];
                break;
            case 2:
                cell.headView.image = [UIImage imageNamed:@"APPyellow.png"];
                break;
            case 3:
                cell.headView.image = [UIImage imageNamed:@"APPhui.png"];
                break;
            default:
                break;
        }
        return cell;
    }
    if (self.InfoType == Warning || self.InfoType == Warned) {
        FSJPeopleManagerDetailTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"threeCELL"];
        
        cell.stationName.text = [NSString stringWithFormat:@"%@", model.tname];
        cell.managerName.text = [NSString stringWithFormat:@"告警名称: %@",model.name];
        cell.sex.text = [NSString stringWithFormat:@"告警时间: %@",model.time];
        cell.position.text = [NSString stringWithFormat:@"所属区域: %@",model.areaName];
        cell.telPhone.text = [NSString stringWithFormat:@"检测值:%@",model.value];
        return cell;
    }
    else{
    FSJSecondDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"twoCELL"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = SystemGrayColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    if (self.InfoType == PeopleManage) {
        cell.topLabel.text = [NSString stringWithFormat:@"姓名:%@  所属发射站:%@  ", model.name,model.sname];
        cell.secondLabel.text = [NSString stringWithFormat:@"所属区域:%@",model.areaName];
        cell.thirdLabel.text = [NSString stringWithFormat:@"电话号码:%@",model.phone];
    }
    if (self.InfoType == StationManage) {
        cell.topLabel.text = [NSString stringWithFormat:@"%@     负责人:%@    ", model.name,model.manager];
        cell.secondLabel.text = [NSString stringWithFormat:@"所属区域:%@",model.areaName];
        cell.thirdLabel.text = [NSString stringWithFormat:@"地址:%@",model.address];
    }
   
    return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
- (void)createPopwithName:(NSArray *)nameArr andImg:(NSArray *)imgArr andtag:(NSInteger) btntag andShowzidong:(BOOL)show{
    NSMutableArray *obj = [NSMutableArray array];
    for (NSInteger i = 0; i < nameArr.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = imgArr[i];
        info.title = nameArr[i];
        [obj addObject:info];
    };
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:200 item:obj action:^(NSInteger index) {
    if ([nameArr[index] isEqualToString:@"前置放大单元"]) {
           jiankong.JiankongType = Qianji;
            };
    if ([nameArr[index] isEqualToString:@"功率放大单元"]) {
            jiankong.JiankongType = Moji;
            };
    if ([nameArr[index] isEqualToString:@"整机"]) {
            jiankong.JiankongType = Zhengji;
            };
    if ([nameArr[index] isEqualToString:@"工作状态"]) {
            jiankong.JiankongType = Zhuangtai;
            };
        if (show == YES) {
            jiankong.showZidong = YES;
        }
        else{
            jiankong.showZidong = NO;
        }
        [self.navigationController pushViewController:jiankong animated:YES];
        }TopView:self.view alpha:0.9];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.showPop == YES) {
        transmodel = self.dataArray[indexPath.section];
        jiankong =[[FSJJiankongVC alloc]init];
        jiankong.showZidong = YES;
        
        jiankong.fsjId = transmodel.transId;
        jiankong.addressId = transmodel.ipAddr;
        if ([transmodel.powerRate isEqualToString:@"1KW"]) {
            jiankong.is1000W = YES;
            jiankong.JiankongType = Zhengji;
             [self.navigationController pushViewController:jiankong animated:YES];
        }else if ([transmodel.powerRate isEqualToString:@"50W"]){
            
            FSJJiankong50W *jk500vc = [[FSJJiankong50W alloc]init];
            jk500vc.fsjId = transmodel.transId;
            jk500vc.addressId = transmodel.ipAddr;
            [self.navigationController pushViewController:jk500vc animated:YES];
        }
        else{
            //jiankong.is1000W = NO;
            //[self.navigationController pushViewController:jiankong animated:YES];
            [MBProgressHUD showError:@"功能开发中"];
        }
       
    }
    else{
    detail = [[FSJPeopleManagerDetailViewController alloc]init];
    transmodel = self.dataArray[indexPath.section];
    switch (self.InfoType) {
        case 0:
            detail.DetailInfoType = WarningDetail;
            detail.managerID = transmodel.alarmId;
            break;
        case 1:
            detail.DetailInfoType = WarnedDetail;
            detail.managerID = transmodel.alarmId;
            break;
        case 2:
            return;
            break;
        case 3:
            detail.DetailInfoType = PeopleManageDetail;
            detail.managerID = transmodel.managerId;
            break;
        case 4:
            detail.DetailInfoType = StationManageDetail;
            detail.managerID = transmodel.stationId;
            break;
        case 5:
            detail.DetailInfoType = FSJManageDetail;
            detail.managerID = transmodel.transId;
            break;
        default:
            break;
    }
    [self.navigationController pushViewController:detail animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)createNav{
    //self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, WIDTH*0.10,  15);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    cancel.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item1;
    self.navigationItem.rightBarButtonItem = item2;
    self.navigationController.navigationBar.tintColor = SystemWhiteColor;
    mysearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,WIDTH*0.73,35)];
    mysearchBar.delegate = self;
    mysearchBar.backgroundColor = [UIColor clearColor];
    mysearchBar.searchBarStyle =UISearchBarStyleDefault;
    mysearchBar.barTintColor = [UIColor whiteColor];
    [mysearchBar setBackgroundImage:[UIImage imageWithColor:SystemWhiteColor]];
    mysearchBar.layer.borderColor = SystemBlueColor.CGColor;
    mysearchBar.layer.borderWidth = 0;
    mysearchBar.layer.cornerRadius = 17.5;
    mysearchBar.layer.masksToBounds = YES;
    mysearchBar.barStyle =UIBarStyleBlack;
    mysearchBar.showsCancelButton = NO;
    for (UIView* view in mysearchBar.subviews)
    {
        for (UIView *v in view.subviews) {
            if ( [v isKindOfClass: [UITextField class]] )
            {
                UITextField *tf = (UITextField *)v;
                tf.clearButtonMode = UITextFieldViewModeNever;
            }
        }
    }
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, WIDTH*0.73, 35)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:mysearchBar];

    self.navigationItem.titleView = searchView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:@""];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    if ([mysearchBar.text isEqualToString:@""]) {
        return;
    }
    else{
        [self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:@""];
    }
    [mysearchBar resignFirstResponder];
     [self.view endEditing:YES];
}
- (void)cancelBtn:(UIButton *)sender{
    [mysearchBar resignFirstResponder];
    mysearchBar.text = @"";
    [self.menu reloadData];
    [self createTableViewWithorganId:@""andstationId:@""];
    
}
+ (NSString *)actionWithMoreInfoType:(MoreInfoType)actionType{
    NSString *url = @"";
    switch (actionType) {
        case Warning:
            url = @"/rs/app/alarm/list";
            break;
        case Warned:
            url = @"/rs/app/alarm/history/list";
            break;
        case Tongji:
            url = @"";
            break;
        case PeopleManage:
            url = @"/rs/app/station/manager/list";
            break;
        case StationManage:
            url = @"/rs/app/station/list";
            break;
        case FSJManage:
            url = @"/rs/app/station/transmitter/list";
            break;
        default:
            break;
    }
    return url;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
  
}
- (void)getTree{
    NSDictionary *dic = @{@"jwt":jwt};
    [FSJNetworking networkingGETWithActionType:Gettree requestDictionary:dic
                                       success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
                                           if (responseObject) {
                                               
                                           
                                           FSJOganTree *model = [FSJOganTree initWithDictionary:responseObject];
                                           NSString *gradeType = [[FSJUserInfo shareInstance] userAccount].areaType;
                                           
                                           if ([gradeType isEqualToString:@"1"] ) {
                                              
                                               [forthNameArr insertObject:@"兴趣站点" atIndex:0];
                                               onceOrangId = @"1";
                                               columnNumber = 4;
                                               self.firstArr  = model.province.mutableCopy;
                                               self.secondArr = model.city.mutableCopy;
                                               self.thridArr  = model.county.mutableCopy;
                                               for (NSDictionary *dic in self.firstArr) {
                                                   FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                                                   [firstNameArr addObject:model.name];
                                               }
                                               for (NSDictionary *dic in self.secondArr) {
                                                   FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                                                   ///[seconNamedArr addObject:model.name];
                                               }
                                               for (NSDictionary *dic in self.thridArr) {
                                                   FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                                                   //[thridNameArr addObject:model.name];
                                               }
                                               // [firstNameArr insertObject:@"全部" atIndex:0];
                                               [seconNamedArr insertObject:SecondArrStr atIndex:0];
                                               [thridNameArr insertObject:ThirdArrStr atIndex:0];
                                           }
                                           
                                           if ([gradeType isEqualToString:@"2"]) {
                                               columnNumber = 3;
                                              
                                               [thridNameArr insertObject:@"兴趣站点" atIndex:0];
                                               onceOrangId = [model.province[0] objectForKey:@"organId"];
                                               self.firstArr  = model.city.mutableCopy;
                                               self.secondArr = model.county.mutableCopy;
                                               for (NSDictionary *dic in self.firstArr) {
                                                   
                                                   FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                                                   [firstNameArr addObject:model.name];
                                               }
                                               for (NSDictionary *dic in self.secondArr) {
                                                   FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                                                   ;                //[seconNamedArr addObject:model.name];
                                               }
                                               [firstNameArr  insertObject:[[FSJUserInfo shareInstance] userAccount].officeName atIndex:0];
                                               [seconNamedArr insertObject:ThirdArrStr atIndex:0];
                                           }
                                           if ([gradeType isEqualToString:@"3"]) {
                                               columnNumber = 2;
                                                [seconNamedArr insertObject:@"兴趣站点" atIndex:0];
                                               onceOrangId =  [model.city[0] objectForKey:@"organId"];
                                              
                                               self.firstArr =model.county.mutableCopy;
                                               
                                               for (NSDictionary *dic in self.firstArr) {
                                                   FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                                                   [firstNameArr addObject:model.name];
                                               }
                                               [firstNameArr insertObject:[[FSJUserInfo shareInstance] userAccount].officeName atIndex:0];
                                           }
                                           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                               [self createPop];
                                           });
                                           }else{
                                               [MBProgressHUD showError:@"无返回数据"];
                                           }
                                           
                                       }failure:^(NSURLSessionDataTask *operation, NSError *error) {
                                           
                                       }];
}

- (void)createPop{
    self.menu=[[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 0) andHeight:44];
    self.menu.delegate = self;
    self.menu.dataSource = self;
    [self.view addSubview: self.menu];
}
#pragma mark -- DOPDropDownMenuDataSource & DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu
{
    return columnNumber;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column
{
   // if (thridNameArr.count >0) {
        if (column == 0) {
            return firstNameArr.count>0?firstNameArr.count:0;
        }else if (column == 1){
            return seconNamedArr.count>0?seconNamedArr.count:0;
        }else if (column == 2){
            return thridNameArr.count>0?thridNameArr.count:0;
        }
        else {
            return forthNameArr.count>0?forthNameArr.count:0;
        }
//    }else{
//        if (column == 0) {
//            return firstNameArr.count;
//        }else if (column == 1){
//            return seconNamedArr.count;
//        }
//    }
    
    return 0;
}
- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
   // if (thridNameArr.count >0) {
        if (indexPath.column == 0) {
            return firstNameArr[indexPath.row];
        } else if (indexPath.column == 1){
            return seconNamedArr[indexPath.row];
        } else if (indexPath.column ==2){
            return thridNameArr[indexPath.row];
        }else{
            return forthNameArr[indexPath.row];
        }
//    }else{
//        if (indexPath.column == 0) {
//            return firstNameArr[indexPath.row];
//        } else if (indexPath.column == 1){
//            return seconNamedArr[indexPath.row];
//        }
//    }
    return nil;
}


- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu imageNameForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}


- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}

- (NSString *)menu:(DOPDropDownMenu *)menu detailTextForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfItemsInRow:(NSInteger)row column:(NSInteger)column
{
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForItemsInRowAtIndexPath:(DOPIndexPath *)indexPath
{
    return nil;
}
- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (self.dataArray.count>0) {
        [self.dataArray removeAllObjects];
    }
    NSString *gradeType = [[FSJUserInfo shareInstance] userAccount].areaType;
    NSString *tempOrganId;
    //国家级
    if ([gradeType isEqualToString:@"1"]){
        //点击第一列
        if (indexPath.column ==0) {
            firstClicked = YES;
            [self reloadDatawithDataArray:self.firstArr andNameArray:firstNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
            if (indexPath.row !=0) {
                NSDictionary *dic = self.firstArr[indexPath.row];
                twiceOrangId = [dic objectForKey:@"organId"];
                FirstLevelStr = [dic objectForKey:@"organId"];
                NSLog(@"organId = %@",FirstLevelStr);
                [seconNamedArr removeAllObjects];
                for (NSDictionary *temp in self.secondArr) {
                    if ([[temp objectForKey:@"parentId"]isEqualToString:[dic objectForKey:@"organId"]]) {
                        [seconNamedArr addObject:[temp objectForKey:@"name"]];
                        
                    }
                }
                [thridNameArr removeAllObjects];
                for (NSDictionary *temp in self.thridArr) {
                    if ([[temp objectForKey:@"parentId"]isEqualToString:[dic objectForKey:@"organId"]]) {
                        //[thridNameArr addObject:[temp objectForKey:@"name"]];
                    }
                    else{
                        for (NSDictionary *dic in self.secondArr) {
                            if ([[dic objectForKey:@"parentId"]isEqualToString:FirstLevelStr]) {
                                if([[temp objectForKey:@"parentId"] isEqualToString:[dic objectForKey:@"organId"]]) {
                                  //  [thridNameArr addObject:[temp objectForKey:@"name"]];
                                }
                            }
                        }
                    }
                }
                [thridNameArr insertObject:SecondArrStr atIndex:0];
                [seconNamedArr insertObject:ThirdArrStr atIndex:0];
                //[self.menu reloadData];
            }
            else{
                twiceOrangId = @"";
                [seconNamedArr removeAllObjects];
                [thridNameArr removeAllObjects];
                for (NSDictionary *temp in self.secondArr) {
                    //[seconNamedArr addObject:[temp objectForKey:@"name"]];
                }
                [seconNamedArr insertObject:SecondArrStr atIndex:0];
                
                for (NSDictionary *temp in self.thridArr) {
                   // [thridNameArr addObject:[temp objectForKey:@"name"]];
                }
                [thridNameArr insertObject:ThirdArrStr atIndex:0];
                [self.menu reloadData];
            }
        }
        //点击第二列
        if (indexPath.column ==1) {
            
            
            if ([twiceOrangId isEqualToString:@""]||twiceOrangId == nil) {
                [self reloadDatawithDataArray:self.secondArr andNameArray:seconNamedArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
            }else{
                [self reloadDatawithDataArray:self.secondArr andNameArray:seconNamedArr and:tempOrganId and:twiceOrangId andIndexPath:indexPath];
            }
            
            if (indexPath.row !=0) {
                NSDictionary *dic = self.secondArr[indexPath.row-1];
                thirdOrangId = [dic objectForKey:@"organId"];
                [thridNameArr removeAllObjects];
                for (NSDictionary *temp in self.thridArr) {
                    if ([[temp objectForKey:@"parentId"]isEqualToString:[dic objectForKey:@"organId"]]) {
                        [thridNameArr addObject:[temp objectForKey:@"name"]];
                        
                    }
                }
                [thridNameArr insertObject:ThirdArrStr atIndex:0];
            }
            else{
                thirdOrangId = @"";
                [thridNameArr removeAllObjects];
                for (NSDictionary *temp in self.thridArr) {
                    
                    //if (seconNamedArr.count == 1) {
                       //北京
                        if ([[temp objectForKey:@"parentId"] isEqualToString:FirstLevelStr]){
                          
                            [thridNameArr addObject:[temp objectForKey:@"name"]];
                        }
                  //  }else{
                        
//                        for (NSDictionary *dic in self.secondArr) {
//                            if ([[dic objectForKey:@"parentId"]isEqualToString:FirstLevelStr]) {
//                                if([[temp objectForKey:@"parentId"] isEqualToString:[dic objectForKey:@"organId"]]) {
//                                  //  [thridNameArr addObject:[temp objectForKey:@"name"]];
//                                }
//                            }
//                        }
                        
//                    }
                }
                [thridNameArr insertObject:ThirdArrStr atIndex:0];
            }
        }
        //点击第三列
        if(indexPath.column == 2){
            
            if (seconNamedArr.count == 1) {
                if(thirdOrangId ==nil ||[thirdOrangId isEqualToString:@""]){
                    [self reloadDatawithDataArray:self.secondArr andNameArray:thridNameArr and:tempOrganId and:twiceOrangId andIndexPath:indexPath];
                }else if (twiceOrangId ==nil ||[thirdOrangId isEqualToString:@""]) {
                    [self reloadDatawithDataArray:self.secondArr andNameArray:thridNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
                }else{
                    [self reloadDatawithDataArray:self.secondArr andNameArray:thridNameArr and:tempOrganId and:thirdOrangId andIndexPath:indexPath];
                }
                
            }else{
                if(thirdOrangId ==nil){
                    [self reloadDatawithDataArray:self.thridArr andNameArray:thridNameArr and:tempOrganId and:twiceOrangId andIndexPath:indexPath];
                }else if (twiceOrangId ==nil) {
                    [self reloadDatawithDataArray:self.thridArr andNameArray:thridNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
                }else{
                    [self reloadDatawithDataArray:self.thridArr andNameArray:thridNameArr and:tempOrganId and:thirdOrangId andIndexPath:indexPath];
                }
            }
            NSLog(@"%@",thridNameArr[indexPath.row]);
            //点击第四列
        } if(indexPath.column == 3){
            if (indexPath.row == 0) {
                // staticStationId = @"";
                //[self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:@""];
               // [self createTableViewWithorganId:@"" andstationId:@""];
            }else{
                [self.menu reloadData];
                
            NSDictionary *tempDict = self.forthArr[indexPath.row-1];
                //[self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId)andstationId:[tempDict objectForKey:@"stationId"]];
                
                mysearchBar.text = [tempDict objectForKey:@"sname"];
                [self createTableViewWithorganId:@"" andstationId:[tempDict objectForKey:@"stationId"]];
                //staticStationId = [tempDict objectForKey:@"stationId"];
                
            }
        }
    }
    //省级
    if ([gradeType isEqualToString:@"2"]){
        if (indexPath.column == 0) {
            [self reloadDatawithDataArray:self.firstArr andNameArray:firstNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
            if (indexPath.row != 0) {
                NSDictionary *dic = self.firstArr[indexPath.row-1];
                [seconNamedArr removeAllObjects];
                for (NSDictionary *temp in self.secondArr) {
                    if ([[temp objectForKey:@"parentId"]isEqualToString:[dic objectForKey:@"organId"]]) {
                        [seconNamedArr addObject:[temp objectForKey:@"name"]];
                        twiceOrangId = [temp objectForKey:@"parentId"];
                    }
                }
                [seconNamedArr insertObject:ThirdArrStr atIndex:0];
            }
            else{
                twiceOrangId = @"";
                [seconNamedArr removeAllObjects];
                for (NSDictionary *temp in self.secondArr) {
                    //[seconNamedArr addObject:[temp objectForKey:@"name"]];
                }
                [seconNamedArr insertObject:ThirdArrStr atIndex:0];
            }
        }
        if(indexPath.column == 1){
            if ([twiceOrangId isEqualToString:@""]) {
                [self reloadDatawithDataArray:self.secondArr andNameArray:seconNamedArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
            }else{
                [self reloadDatawithDataArray:self.secondArr andNameArray:seconNamedArr and:tempOrganId and:twiceOrangId andIndexPath:indexPath];
            }
            NSLog(@"%@",seconNamedArr[indexPath.row]);
        }
        if(indexPath.column == 2){
            if (indexPath.row == 0) {
              // staticStationId = @"";
               // [self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:@""];
                 //[self createTableViewWithorganId:@"" andstationId:@""];
            }else{
                 [self.menu reloadData];
                NSDictionary *tempDict = self.thridArr[indexPath.row-1];
                //[self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:[tempDict objectForKey:@"stationId"]];
                mysearchBar.text = [tempDict objectForKey:@"sname"];
                [self createTableViewWithorganId:@"" andstationId:[tempDict objectForKey:@"stationId"]];
               // staticStationId = [tempDict objectForKey:@"stationId"];
                
                
            }
        }
    }
    //市级
    if ([gradeType isEqualToString:@"3"]){
        if(indexPath.column == 0){
           [self reloadDatawithDataArray:self.firstArr andNameArray:firstNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
        }
        if(indexPath.column == 1){
            
            if (indexPath.row == 0) {
               // staticStationId = @"";
               // [self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:@""];
                
                //[self createTableViewWithorganId:@"" andstationId:@""];
            }else{
                [self.menu reloadData];
                NSDictionary *tempDict = self.secondArr[indexPath.row-1];
               // [self createTableViewWithorganId:(staticOrganId==nil?@"":staticOrganId) andstationId:[tempDict objectForKey:@"stationId"]];
                mysearchBar.text = [tempDict objectForKey:@"sname"];
                [self createTableViewWithorganId:@"" andstationId:[tempDict objectForKey:@"stationId"]];
               // staticStationId = [tempDict objectForKey:@"stationId"];
            }
        }
    }
    
}

//根据点击刷新数据
- (void)reloadDatawithDataArray:(NSArray *)DataArray andNameArray:(NSArray *)NameArray and:(NSString *)tempOrganId and:(NSString *)onceOrangIdStr andIndexPath:(DOPIndexPath *)indexPath{
    for (NSDictionary *dic in DataArray) {
        if ([NameArray[indexPath.row] isEqualToString:[dic objectForKey:@"name"]]) {
            tempOrganId = [dic objectForKey:@"organId"];
        }
    }
    if (tempOrganId == nil) {
        
        staticOrganId = onceOrangIdStr;
        //[self createTableViewWithorganId:onceOrangIdStr andstationId:(staticStationId==nil?@"":staticStationId)];
        [self createTableViewWithorganId:onceOrangIdStr andstationId:@""];
    }else{
        
        staticOrganId = tempOrganId;
        //[self createTableViewWithorganId:tempOrganId andstationId:(staticStationId==nil?@"":staticStationId)];
        [self createTableViewWithorganId:tempOrganId andstationId:@""];
    }
    
}
@end
