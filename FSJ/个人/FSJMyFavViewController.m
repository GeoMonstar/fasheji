//
//  FSJMyFavViewController.m
//  FSJ
//
//  Created by Monstar on 16/6/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMyFavViewController.h"
#import "FSJMainTableView.h"
#import "FSJOneFSJ.h"
#import "FSJNoDataTableViewCell.h"
#import "FSJAddStationVC.h"
#import "FSJPeopleManagerDetailViewController.h"
@interface FSJMyFavViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSString *jwt;
}

@property (nonatomic,strong)UITableView* myTable;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FSJMyFavViewController
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray =@[].mutableCopy;
    }
    return _dataArray;
}
- (UITableView *)myTable{
    if (_myTable == nil) {
        _myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH) style:UITableViewStyleGrouped];
       _myTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
       _myTable.delegate   = self;
       _myTable.dataSource = self;
    }
    return _myTable;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [self createNav];
    
    [self.view addSubview:self.myTable];
    self.view.backgroundColor = SystemLightGrayColor;
}
- (void)initUI {
    
    NSDictionary *dic = @{@"jwt":[[EGOCache globalCache]stringForKey:@"jwt"]};
    [FSJNetworking networkingGETWithActionType:GetInterestList requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
        
        if (self.dataArray.count >0) {
            [self.dataArray removeAllObjects];
        }
        if ([model.status isEqualToString:@"200"]) {
            for (NSDictionary *dict in model.list) {
                [self.dataArray addObject:dict];
            }
            
            [self.myTable reloadData];
        }
    }failure:^(NSURLSessionDataTask *operation, NSError *error) {
        [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
    }];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FSJNoDataTableViewCell *cell = [FSJNoDataTableViewCell initWith:tableView];
    cell.TopLabel.textAlignment = NSTextAlignmentLeft;
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.TopLabel.text = [dic objectForKey:@"sname"];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  NSDictionary*dic =  self.dataArray[indexPath.row];
   FSJPeopleManagerDetailViewController* detail = [[FSJPeopleManagerDetailViewController alloc]init];
    detail.DetailInfoType = StationManageDetail;
    detail.managerID = [dic objectForKey:@"stationId"];
    [self.navigationController pushViewController:detail animated:YES];
}
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSDictionary *dict = @{@"jwt":[[EGOCache globalCache]stringForKey:@"jwt"],@"interestId":[dic objectForKey:@"interestId"]};
        [FSJNetworking networkingGETWithActionType:DeleteInterestStation requestDictionary:dict success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
            [MBProgressHUD showSuccess:@"删除成功"];
            [self initUI];
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
             [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        }];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.myTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
    }];
    return @[deleteRowAction];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initUI];
}

- (void)createNav{
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *push = [UIButton buttonWithType:UIButtonTypeCustom];
    push.frame = CGRectMake(0, 0, 15, 15);
    [push setBackgroundImage:[UIImage imageNamed:@"jia"] forState:UIControlStateNormal];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:push];
    [push addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = item2;
    self.navigationItem.leftBarButtonItem = item1;
    self.title = @"兴趣站点";
}
- (void)push:(UIButton *)sender{
    FSJAddStationVC *add = [[FSJAddStationVC alloc]init];
    
    [self.navigationController pushViewController:add animated:YES];
}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
