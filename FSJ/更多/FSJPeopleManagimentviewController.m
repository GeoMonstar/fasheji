//
//  FSJPeopleManagimentviewController.m
//  FSJ
//
//  Created by Monstar on 16/3/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJPeopleManagimentviewController.h"
#import "FSJPeopleManagerDetailViewController.h"


@interface FSJPeopleManagimentviewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    UISearchBar *mysearchBar;
    
    NSString *jwt;
    //NSMutableArray *dataArray;
    NSDictionary *dic;
    NSString *url;
    NSInteger count;
    FSJPeopleManagerDetailViewController *detail;
    FSJResultList *transmodel;
    BOOL isDraggingDown;
    NSMutableArray *tempArr;
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
    [self createUI];
    NSUserDefaults *userjwt = [NSUserDefaults standardUserDefaults];
    if ([userjwt valueForKey:@"jwt"]) {
        jwt = [userjwt valueForKey:@"jwt"];
    }
    [self cteateTableView];  
    
}
- (void)cteateTableView{
    [self.view addSubview:self.myTable];
    if (self.InfoType == PeopleManage) {
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/station/manager/list";
    }
    if (self.InfoType == StationManage) {
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/station/list";
    }
    if (self.InfoType == FSJManage) {
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/station/transmitter/list";
    }
    if (self.InfoType == Warning) {
        dic = @{@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/alarm/list";
    }
    if (self.InfoType == Warned) {
        dic = @{@"sname":mysearchBar.text,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count],@"jwt":jwt};
        url = @"/rs/app/alarm/history/list";
    }
    self.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadDataWhenDraggingDown];
    }];
    // 设置表格视图的触底加载(上拉刷新)
    self.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        isDraggingDown = NO;
        if (self.dataArray.count > 0) {
            [self loadDataWhenReachingBottom];
        }
        else {
            [self endRefreshing];
        }
    }];
    [self loadDataWhenDraggingDown];
    [self startNetworkWith:url andDic:dic];
}
- (void) loadDataWhenDraggingDown {
    count =0;
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
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetWorking networkingGETWithURL:neturl requestDictionary:dict success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
         NSMutableArray *tempArray = [NSMutableArray array];
        if ([model.status isEqualToString:@"200"]) {
            
            for (NSDictionary *dict in model.list) {
                FSJResultList *listmodle = [FSJResultList initWithDictionary:dict];
                [tempArray addObject:listmodle];
            }
            if (tempArray.count >0) {
                
                if (count == 0 && self.dataArray.count >0) {
                    [self.dataArray removeAllObjects];
                }
                [self.dataArray addObjectsFromArray:tempArray];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.myTable reloadData];
                     [self endRefreshing];
                });
                [SVProgressHUD showSuccessWithStatus:model.message];
                [mysearchBar resignFirstResponder];
            }else{
                [SVProgressHUD showInfoWithStatus:@"数据加载完成"];
                [self endRefreshing];
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CELL"];
    }
    FSJResultList *model = self.dataArray[indexPath.section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = SystemGrayColor;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    if (self.InfoType == PeopleManage) {
        cell.textLabel.text = [NSString stringWithFormat:@"姓名:%@     所属发射站:%@", model.name,model.sname];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"电话号码:%@",model.phone];
    }
    if (self.InfoType == StationManage) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@   负责人:%@", model.name,model.manager];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"地址:%@",model.address];
    }
    if (self.InfoType == FSJManage) {
       
        UIImageView *imgiew = [[UIImageView alloc]initWithFrame:CGRectMake(8, 15,25, 30)];
        [cell.contentView addSubview:imgiew];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(45, 0, cell.frame.size.width-40,25)];
        label1.text = [NSString stringWithFormat:@"%@", model.tname];
        label1.font = [UIFont systemFontOfSize:14];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(45, 25, cell.frame.size.width-40,25)];
        label2.text = [NSString stringWithFormat:@"所属发射站:%@   功耗等级:%@",model.sname,model.powerRate];
        label2.font = [UIFont systemFontOfSize:12];

        [cell addSubview:label1];
        [cell addSubview:label2];
        
        switch (model.state.integerValue) {
            case 0:
                imgiew.image = [UIImage imageNamed:@"green.png"];
                break;
            case 1:
                imgiew.image = [UIImage imageNamed:@"red"];
                break;
            case 2:
                imgiew.image = [UIImage imageNamed:@"orenge.png"];
                break;
            case 3:
                imgiew.image = [UIImage imageNamed:@"hui.png"];
                break;
            default:
                break;
        }
    }
    if (self.InfoType == Warning || self.InfoType == Warned) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@  设备IP:%@", model.name,model.ipaddr];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"检测值:%@            %@",model.value,model.time];
//        UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 24, 30, 25)];
//        redLabel.textColor = [UIColor redColor];
//        redLabel.font = [UIFont systemFontOfSize:12];
//        redLabel.text = model.value;
//        [cell.contentView addSubview:redLabel];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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
- (void)createUI{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(0, 0, WIDTH*0.15,  36);
    [cancel setTitle:@"取消" forState:UIControlStateNormal];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(cancelBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = item1;
    self.navigationItem.rightBarButtonItem = item2;
    
    self.navigationController.navigationBar.tintColor = SystemWhiteColor;
    mysearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,WIDTH*0.65,40)];
    mysearchBar.delegate = self;
    mysearchBar.backgroundColor = SystemWhiteColor;
    [mysearchBar setPlaceholder:@"输入发射机名字"];
    mysearchBar.searchBarStyle =UISearchBarStyleDefault;
    mysearchBar.barTintColor = SystemBlueColor;
    mysearchBar.layer.borderColor = SystemBlueColor.CGColor;
    mysearchBar.layer.borderWidth = 2;
    mysearchBar.barStyle =UIBarStyleBlackOpaque;
    //将搜索条放在一个UIView上
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH*0.65, 40)];
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
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    if ([mysearchBar.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入查询内容"];
        return;
    }
    else{
        [self cteateTableView];
    }
}
- (void)cancelBtn:(UIButton *)sender{
    [mysearchBar resignFirstResponder];
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

@end
