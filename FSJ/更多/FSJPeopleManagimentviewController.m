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
@interface FSJPeopleManagimentviewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UISearchBar     *mysearchBar;
    FSJJiankongVC   *jiankong;
    NSString        *jwt;
    //NSMutableArray *dataArray;
    NSDictionary    *dic;
    NSString        *url;
    NSInteger       count;
    FSJPeopleManagerDetailViewController *detail;
    FSJResultList   *transmodel;
    BOOL            isDraggingDown;
    NSMutableArray  *tempArr;
    NSString        *placeHolder;
    NSArray         *jiankongArr;
    NSArray         *jiankongimgArr;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)UITableView *myTable;
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
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH) style:UITableViewStyleGrouped];
        _myTable.delegate = self;
        _myTable.dataSource = self;
    }
    return _myTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SystemWhiteColor;
    count = 1;
    [self createNav];
    jwt = [[EGOCache globalCache]stringForKey:@"jwt"];
    [self createTableView];
}
- (void)createTableView{
    [self.myTable registerNib:[UINib nibWithNibName:@"FSJDetailTableViewCell"bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"oneCELL"];
    [self.myTable registerNib:[UINib nibWithNibName:@"FSJSecondDetailTableViewCell"bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"twoCELL"];
    [self.view addSubview:self.myTable];
    if (self.InfoType == PeopleManage) {
        placeHolder = @"请输入发射站名称";
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/station/manager/list";
    }
    if (self.InfoType == StationManage) {
        placeHolder = @"请输入发射站名称";
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        //url = @"/rs/app/station/list";
         url = @"/rs/app/interest/lis";
    }
    if (self.InfoType == FSJManage) {
        placeHolder = @"请输入发射机名称";
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/station/transmitter/list";
    }
    if (self.InfoType == Warning) {
        placeHolder = @"请输入发射站、发射机名称";
        dic = @{@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/alarm/list";
    }
    if (self.InfoType == Warned) {
         placeHolder = @"请输入发射站、发射机名称";
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
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
        if (weakself.dataArray.count > 0) {
            [weakself loadDataWhenReachingBottom];
        }
        else {
            [weakself endRefreshing];
        }
    }];
    [self loadDataWhenDraggingDown];
    [self startNetworkWith:url andDic:dic];
}
- (void) loadDataWhenDraggingDown {
    count =1;
    isDraggingDown = YES;
     [self startNetworkWith:url andDic:dic];
}
// 触底加载数据的方法
- (void) loadDataWhenReachingBottom {
    count ++;
    isDraggingDown = NO;
    
    [self startNetworkWith:url andDic:dic];
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
    NSLog(@"%ld",(long)count);
    //[SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    //[SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithURL:neturl requestDictionary:dict success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
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
                //[SVProgressHUD showSuccessWithStatus:model.message];
                // 键盘控制
                // [mysearchBar resignFirstResponder];
            }else{
                //[SVProgressHUD showInfoWithStatus:@"数据加载完成"];
                [self endRefreshing];
            }
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
    if (self.InfoType == Warning || self.InfoType == Warned) {
        cell.topLabel.text = [NSString stringWithFormat:@"设备名称:%@", model.tname];
        cell.secondLabel.text = [NSString stringWithFormat:@"所属区域%@",model.areaName];
        cell.thirdLabel.text = [NSString stringWithFormat:@"检测值:%@            %@",model.value,model.time];
        
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
        jiankong.JiankongType = Zhengji;
        jiankong.fsjId = transmodel.transId;
        jiankong.addressId = transmodel.ipAddr;
        
        [self.navigationController pushViewController:jiankong animated:YES];
//        transmodel = self.dataArray[indexPath.section];
//        jiankong = [[FSJJiankongVC alloc]init];
//        jiankong.fsjId = transmodel.transId;
//        jiankong.addressId = transmodel.ipAddr;
//        if ([transmodel.powerRate isEqualToString:@"300W"]) {
//            jiankongArr     = @[@"前置放大单元",@"工作状态"];
//            jiankongimgArr  = @[@"clt.png",@"zhuangtai"];
//            [self createPopwithName:jiankongArr andImg:jiankongimgArr andtag:602 andShowzidong:NO];
//        }
//        else{
//            jiankongArr     = @[@"前置放大单元",@"功率放大单元",@"整机",@"工作状态"];
//            jiankongimgArr  = @[@"clt.png",@"cnu",@"zhengji",@"zhuangtai"];
//            [self createPopwithName:jiankongArr andImg:jiankongimgArr andtag:602 andShowzidong:YES];
//        
//        }
        
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
    
    [self createTableView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    if ([mysearchBar.text isEqualToString:@""]) {
//      [SVProgressHUD showErrorWithStatus:@"请输入查询内容"];
        return;
    }
    else{
        [self createTableView];
    }
}
- (void)cancelBtn:(UIButton *)sender{
    [mysearchBar resignFirstResponder];
    mysearchBar.text = @"";
    [self createTableView];
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
    //mysearchBar.text = @"";
}
@end
