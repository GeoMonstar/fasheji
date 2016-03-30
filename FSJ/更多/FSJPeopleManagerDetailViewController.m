//
//  FSJPeopleManagerDetailViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/17.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJPeopleManagerDetailViewController.h"
#import "FSJPeopleManagerDetailTableViewCell.h"
@interface FSJPeopleManagerDetailViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSString *jwt;
   
    FSJResultList *model;
    //NSDictionary *dic;
    NSString *url;
    NSInteger sectionNum;
    NSString *head;
    NSString *titleStr;
}
@property (nonatomic,strong)UITableView *myTable;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FSJPeopleManagerDetailViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray =  @[].mutableCopy;
    }
    return _dataArray;
}
- (UITableView *)myTable{
    if (_myTable == nil) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH) style:UITableViewStyleGrouped];
        _myTable.delegate = self;
        _myTable.dataSource = self;
        _myTable.separatorInset = UIEdgeInsetsMake(0,3,0,3);
        _myTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return _myTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = false;
    
    [self createUI];
    self.view.backgroundColor = SystemGrayColor;
        NSUserDefaults *userjwt = [NSUserDefaults standardUserDefaults];
    if ([userjwt valueForKey:@"jwt"]) {
        jwt = [userjwt valueForKey:@"jwt"];
    }
    [self ctreateTableView];
}
- (void)ctreateTableView{
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeGradient];
       //[self.myTable registerNib:[UINib nibWithNibName:@"FSJPeopleManagerDetailTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
       switch (self.DetailInfoType) {
        case 0:
            url = @"/rs/app/alarm/info";
            sectionNum = 7;
            head = @"alarmId";
           // titleStr = @"实时警告详情";
            break;
        case 1:
            url = @"/rs/app/alarm/info";
            sectionNum = 10;
             head = @"alarmId";
           // titleStr = @"历史警告详情";
            break;
        case 2:
            url = @"";
            break;
        case 3:
            url = @"/rs/app/station/manager/info";
            sectionNum = 5;
             head = @"managerId";
           // titleStr = @"历史警告详情";
            break;
        case 4:
            url = @"/rs/app/station/info";
            sectionNum = 10;
            head =@"sid";
            break;
        case 5:
            url = @"/rs/app/station/transmitter/getById";
            sectionNum = 11;
            head =@"id";
            break;
        default:
            break;
    }
    NSDictionary *dic = @{head:self.managerID,@"jwt":jwt};
    [FSJNetWorking networkingGETWithURL:url requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        model = [FSJResultList initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"]) {
            
                [SVProgressHUD dismiss];
            [self.view addSubview:self.myTable];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.myTable reloadData];
            });
        }
        else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
   
    return sectionNum;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }
    else{
        return 0.02;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 0.02;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL"];
       if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CELL"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    if (self.DetailInfoType == WarningDetail) {
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = model.name;
                break;
             case 1:
                switch (model.level.integerValue) {
                    case 0:
                        cell.textLabel.text = @"等级:过低";
                        break;
                    case 1:
                        cell.textLabel.text = @"等级:偏低";
                        break;
                    case 2:
                        cell.textLabel.text = @"等级:低正常";
                        break;
                    case 3:
                        cell.textLabel.text = @"等级:高正常";
                        break;
                    case 4:
                        cell.textLabel.text = @"等级:偏高";
                        break;
                    case 5:
                        cell.textLabel.text = @"等级:过高";
                        break;
                    case 6:
                        cell.textLabel.text = @"等级:其他";
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"检测值:%@",model.value];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"设备类型:%@",model.deviceType];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"设备IP:%@",model.ipaddr];;
                break;
            case 5:
                cell.textLabel.text = [NSString stringWithFormat:@"告警时间:%@",model.timestamp];
                break;
            case 6:
                cell.textLabel.text = [NSString stringWithFormat:@"故障现象:%@",model.descript] ;
                break;
            default:
                break;
        }
    }
    if(self.DetailInfoType == WarnedDetail){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = model.name;
                break;
            case 1:
                switch (model.level.integerValue) {
                    case 0:
                        cell.textLabel.text = @"等级:过低";
                        break;
                    case 1:
                        cell.textLabel.text = @"等级:偏低";
                        break;
                    case 2:
                        cell.textLabel.text = @"等级:低正常";
                        break;
                    case 3:
                        cell.textLabel.text = @"等级:高正常";
                        break;
                    case 4:
                        cell.textLabel.text = @"等级:偏高";
                        break;
                    case 5:
                        cell.textLabel.text = @"等级:过高";
                        break;
                    case 6:
                        cell.textLabel.text = @"等级:其他";
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"检测值:%@",model.value];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"设备类型:%@",model.deviceType];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"设备IP:%@",model.ipaddr];
                break;
            case 5:
                cell.textLabel.text = @"告警状态:告警";
                break;
            case 6:
                cell.textLabel.text = [NSString stringWithFormat:@"发射机名称:%@",model.tname];
                break;

            case 7:
                cell.textLabel.text = [NSString stringWithFormat:@"告警时间:%@",model.timestamp];
                break;
            case 8:
                if ([model.timerecover isEqualToString:@""]) {
                    cell.textLabel.text = @"恢复时间:待定";
                }
                else{
                    cell.textLabel.text = [NSString stringWithFormat:@"恢复时间:%@",model.timerecover];}
                break;
            case 9:
                cell.textLabel.text = [NSString stringWithFormat:@"故障现象:%@",model.descript] ;
                
                break;
            default:
                break;
        }
    }
    if (self.DetailInfoType == PeopleManageDetail) {
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = model.name;
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"职务:%@",model.position];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"性别:%@",model.gender];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"手机号:%@",model.phone];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"所属发射站:%@",model.sname];
                break;
                
            default:
                break;
        }
    }
    if (self.DetailInfoType == StationManageDetail){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = model.name;
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"负责人:%@",model.manager];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"所属机构:%@",model.organName];
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"编号:%@",model.no];
                break;
            case 4:
                cell.textLabel.text = [NSString stringWithFormat:@"海拔:%@",model.altitude];
                break;
            case 5:
                cell.textLabel.text = [NSString stringWithFormat:@"经度:%@",model.lon];
                break;
            case 6:
                cell.textLabel.text = [NSString stringWithFormat:@"纬度:%@",model.lat];
                break;
            case 7:
                cell.textLabel.text = [NSString stringWithFormat:@"固话:%@",model.mobile];
                break;
            case 8:
                cell.textLabel.text = [NSString stringWithFormat:@"移动电话:%@",model.phone];
                break;
            case 9:
                cell.textLabel.text = [NSString stringWithFormat:@"地址:%@",model.address];
                break;
            default:
                break;
        }

    }
    if (self.DetailInfoType == FSJManageDetail){
        switch (indexPath.section) {
            case 0:
                cell.textLabel.text = model.tname;
                cell.imageView.contentMode = UIViewContentModeCenter;
                switch ([model.state integerValue]) {
                    case 0:
                        cell.imageView.image = [UIImage imageNamed:@"green.png"];
                        break;
                    case 1:
                        cell.imageView.image = [UIImage imageNamed:@"red.png"];
                        break;
                    case 2:
                        cell.imageView.image = [UIImage imageNamed:@"orenge.png"];
                        break;
                    case 3:
                        cell.imageView.image = [UIImage imageNamed:@"hui.png"];
                        break;
                        
                    default:
                        break;
                }
                break;
            case 1:
                cell.textLabel.text = [NSString stringWithFormat:@"所属发射站:%@",model.sname];
                break;
            case 2:
                cell.textLabel.text = [NSString stringWithFormat:@"发射机类型:%@",model.transmitterType];
                break;
            case 3:
                cell.textLabel.text = [NSString stringWithFormat:@"序列号:%@",model.seriesNo];
                break;
            case 4:
                switch ([model.rfdelay integerValue]) {
                    case 0:
                        cell.textLabel.text = @"射频延时器:有";
                        break;
                    case 1:
                        cell.textLabel.text = @"射频延时器:无";
                        break;
                    default:
                        break;
                }
                
                break;
            case 5:
                cell.textLabel.text = [NSString stringWithFormat:@"工作模式:%@",model.workMode];
                break;
            case 6:
                cell.textLabel.text = [NSString stringWithFormat:@"通讯模式:%@",model.commMode];
                break;
            case 7:
                cell.textLabel.text = [NSString stringWithFormat:@"功率等级:%@",model.powerRate];
                break;
            case 8:
                cell.textLabel.text = [NSString stringWithFormat:@"安装位置:%@",model.location];
                break;
            case 9:
                cell.textLabel.text = [NSString stringWithFormat:@"端口号:%@",model.port];
                break;
            case 10:
                cell.textLabel.text = [NSString stringWithFormat:@"IP地址:%@",model.ipAddr];
                break;
            default:
                break;
        }
    }
        return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 50;
    }
    else{
        return 36;
    }
}
- (void)createUI{
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item1;
    self.title = @"详情";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    
    [SVProgressHUD dismiss];
}
- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
}
//- (void) viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    [self.navigationController setNavigationBarHidden:NO];
//}

/*
#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
