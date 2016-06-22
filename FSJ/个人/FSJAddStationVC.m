//
//  FSJAddStationVC.m
//  FSJ
//
//  Created by Monstar on 16/6/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJAddStationVC.h"
#import "FSJOneFSJ.h"
#import "FSJMulitiSelectCell.h"
#import "FSJInterestModel.h"
#import "FSJOganTree.h"
#import "FSJStationInfo.h"

@interface FSJAddStationVC ()<UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate,DOPDropDownMenuDataSource,DOPDropDownMenuDelegate>
{
    UISearchBar     *mysearchBar;
    NSString *userLevel;
    NSInteger count;
    BOOL isDraggingDown;
    NSString *jwt;
    //NSDictionary *netdic;
    NSMutableArray *firstNameArr;
    NSMutableArray *seconNamedArr;
    NSMutableArray *thridNameArr;
    
    UIView *searchView;
    NSInteger columnNumber;
    NSString *FirstLevelStr;
    NSString *onceOrangId;
    NSString *twiceOrangId;
    NSString *thirdOrangId;
    NSString *staticOrganId;
    
    BOOL firstClicked;
    BOOL secondClicked;
}
@property (nonatomic,strong)UITableView* myTable;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,strong)NSMutableArray *selectedRows;

@property (nonatomic,strong)NSArray *firstArr;
@property (nonatomic,strong)NSArray *secondArr;
@property (nonatomic,strong)NSArray *thridArr;


@property (nonatomic,strong)DOPDropDownMenu *menu;
@end

@implementation FSJAddStationVC

- (NSMutableArray *)selectedRows{
    if (_selectedRows == nil) {
        _selectedRows= @[].mutableCopy;
    }
    return _selectedRows;
}
- (NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray =@[].mutableCopy;
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SystemWhiteColor;
    count = 1;
    firstNameArr = @[].mutableCopy;
    seconNamedArr = @[].mutableCopy;
    thridNameArr = @[].mutableCopy;
    userLevel = [[EGOCache globalCache]stringForKey:@"areaType"];
    jwt = [[EGOCache globalCache]stringForKey:@"jwt"];
    [self createTableView];
    [self createNav];
    [self getTree];
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
    if (thridNameArr.count >0) {
        if (column == 0) {
            return firstNameArr.count;
        }else if (column == 1){
            return seconNamedArr.count;
        }else {
            return thridNameArr.count;
        }
    }else{
        if (column == 0) {
            return firstNameArr.count;
        }else if (column == 1){
            return seconNamedArr.count;
        }
    }
    
    return 0;
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath
{
    if (thridNameArr.count >0) {
        if (indexPath.column == 0) {
            return firstNameArr[indexPath.row];
        } else if (indexPath.column == 1){
            return seconNamedArr[indexPath.row];
        } else {
            return thridNameArr[indexPath.row];
        }
    }else{
        if (indexPath.column == 0) {
            return firstNameArr[indexPath.row];
        } else if (indexPath.column == 1){
            return seconNamedArr[indexPath.row];
        }
    }
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
    NSString *gradeType = [[EGOCache globalCache]stringForKey:@"areaType"];
    NSString *tempOrganId;
    if ([gradeType isEqualToString:@"1"]){
        //点击第一列
        if (indexPath.column ==0) {
       [self reloadDatawithDataArray:self.firstArr andNameArray:firstNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
            
            if (indexPath.row !=0) {
                firstClicked = YES;
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
                        //北京
                        //[thridNameArr addObject:[temp objectForKey:@"name"]];
                    }
                    else{
                        for (NSDictionary *dic in self.secondArr) {
                            if ([[dic objectForKey:@"parentId"]isEqualToString:FirstLevelStr]) {
                                if([[temp objectForKey:@"parentId"] isEqualToString:[dic objectForKey:@"organId"]]) {
                                    //[thridNameArr addObject:[temp objectForKey:@"name"]];
                                }
                            }
                        }
                    }
                }
                
                [seconNamedArr insertObject:SecondArrStr atIndex:0];
                [thridNameArr insertObject:ThirdArrStr atIndex:0];
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
                    //[thridNameArr addObject:[temp objectForKey:@"name"]];
                }
                [thridNameArr insertObject:ThirdArrStr atIndex:0];
                
                [self.menu reloadData];
            }
        }
        //点击第二列
        if (indexPath.column ==1 ) {
            if ([twiceOrangId isEqualToString:@""]) {
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
                        
                       // if (seconNamedArr.count == 1) {
                        //北京
                        if ([[temp objectForKey:@"parentId"] isEqualToString:FirstLevelStr]){
                            
                               [thridNameArr addObject:[temp objectForKey:@"name"]];
                            }
//                        }else{
//                            
//                            for (NSDictionary *dic in self.secondArr) {
//                                if ([[dic objectForKey:@"parentId"]isEqualToString:FirstLevelStr]) {
//                            if([[temp objectForKey:@"parentId"] isEqualToString:[dic objectForKey:@"organId"]]) {
//                               // [thridNameArr addObject:[temp objectForKey:@"name"]];
//                                    }
//                                }
//                            }
//                        }
                    }
                [thridNameArr insertObject:ThirdArrStr atIndex:0];
            }
        }
        //点击第三列
        if(indexPath.column == 2 ){
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
        }
    }
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
                   // [seconNamedArr addObject:[temp objectForKey:@"name"]];
                }
                [seconNamedArr insertObject:ThirdArrStr atIndex:0];
            }
        }
        if(indexPath.column == 1 ){
            
            if ([twiceOrangId isEqualToString:@""]) {
                [self reloadDatawithDataArray:self.secondArr andNameArray:seconNamedArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
            }else{
                 [self reloadDatawithDataArray:self.secondArr andNameArray:seconNamedArr and:tempOrganId and:twiceOrangId andIndexPath:indexPath];
            }
            NSLog(@"%@",seconNamedArr[indexPath.row]);
        }
    }
    if ([gradeType isEqualToString:@"3"]){
      //  if (indexPath.row !=0) {
            [self reloadDatawithDataArray:self.firstArr andNameArray:firstNameArr and:tempOrganId and:onceOrangId andIndexPath:indexPath];
        //}
        
        
    }
    NSLog(@"点击了 %ld - %ld 项目",(long)indexPath.column,indexPath.row);
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
       [self loadDatawith:onceOrangIdStr];
    }else{
        staticOrganId = tempOrganId;
        [self loadDatawith:tempOrganId];
    }

}
- (void)getTree{
    NSDictionary *dic = @{@"jwt":jwt};
    [FSJNetworking networkingGETWithActionType:Gettree requestDictionary:dic
            success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
           FSJOganTree *model = [FSJOganTree initWithDictionary:responseObject];
                NSString *gradeType = [[EGOCache globalCache]stringForKey:@"areaType"];
                
                if ([gradeType isEqualToString:@"1"] ) {
                    [self loadDatawith:@"1"];
                    onceOrangId = @"1";
                    columnNumber = 3;
                    self.firstArr  = model.province;
                    self.secondArr = model.city;
                    self.thridArr  = model.county;
                    for (NSDictionary *dic in self.firstArr) {
                        FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                        [firstNameArr addObject:model.name];
                    }
                    for (NSDictionary *dic in self.secondArr) {
                        //FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                       // [seconNamedArr addObject:model.name];
                    }
                    for (NSDictionary *dic in self.thridArr) {
                        //FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                        //[thridNameArr addObject:model.name];
                    }
                    
                      [seconNamedArr insertObject:SecondArrStr atIndex:0];
                      [thridNameArr insertObject:ThirdArrStr atIndex:0];
                }
                
                if ([gradeType isEqualToString:@"2"]) {
                    columnNumber = 2;
                    [self loadDatawith:[model.province[0] objectForKey:@"organId"]];
                    onceOrangId = [model.province[0] objectForKey:@"organId"];
                    self.firstArr  = model.city;
                    self.secondArr = model.county;
                    for (NSDictionary *dic in self.firstArr) {
                        
                        FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                        [firstNameArr addObject:model.name];
                    }
                    for (NSDictionary *dic in self.secondArr) {
                        FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                        //[seconNamedArr addObject:model.name];
                    }
                   
                    [firstNameArr  insertObject: [[EGOCache globalCache]stringForKey:@"officeName"] atIndex:0];
                    [seconNamedArr insertObject:ThirdArrStr atIndex:0];
                }
                if ([gradeType isEqualToString:@"3"]) {
                    columnNumber = 1;
                    onceOrangId =  [model.city[0] objectForKey:@"organId"];
                     [self loadDatawith:[model.city[0] objectForKey:@"organId"]];
                    self.firstArr =model.county;
                    
                    for (NSDictionary *dic in self.firstArr) {
                        FSJStationInfo *model = [FSJStationInfo initWithDictionary:dic];
                        [firstNameArr addObject:model.name];
                    }
                    [firstNameArr insertObject:[[EGOCache globalCache]stringForKey:@"officeName"] atIndex:0];
                }
                [self createPop];
                }failure:^(NSURLSessionDataTask *operation, NSError *error) {
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

- (void)createNav{
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *finshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finshBtn.frame = CGRectMake(0, 0, WIDTH*0.10,  15);
    [finshBtn setTitle:@"完成" forState:UIControlStateNormal];
    finshBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:finshBtn];
    [finshBtn addTarget:self action:@selector(finshed:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item1;
    self.navigationItem.rightBarButtonItem = item2;
    self.navigationController.navigationBar.tintColor = SystemWhiteColor;
    mysearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0,0,WIDTH*0.7,35)];
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
    //mysearchBar.showsCancelButton = YES;
    mysearchBar.placeholder = @"输入台站名称";
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
    searchView = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-WIDTH*0.35, 25, WIDTH*0.7, 35)];
    searchView.backgroundColor = [UIColor clearColor];
    [searchView addSubview:mysearchBar];
    [[[UIApplication sharedApplication]keyWindow]addSubview:searchView];
    //self.navigationItem.titleView = searchView;
}
- (void)createTableView{
    self.myTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, HEIGH) style:UITableViewStylePlain];
    self.myTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.myTable.delegate   = self;
    self.myTable.dataSource = self;
    [self.myTable registerClass:[FSJMulitiSelectCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:self.myTable];
    FSJWeakSelf(weakself);
  
    self.myTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadDataWhenDraggingDown];
    }];
    
//    self.myTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        isDraggingDown = NO;
//        
//        if (weakself.dataArray.count > 0) {
//            [weakself loadDataWhenReachingBottom];
//        }
//        else {
//            [weakself endRefreshing];
//        }
//    }];
    
}
- (void) loadDataWhenDraggingDown {
    count =1;
    isDraggingDown = YES;
    [self loadDatawith:staticOrganId];
}
// 触底加载数据的方法
- (void) loadDataWhenReachingBottom {
    count ++;
    isDraggingDown = NO;
    
    [self loadDatawith:staticOrganId];
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
- (void)loadDatawith:(NSString *)organId{
    
    NSDictionary *netdic;
    if (mysearchBar.text == nil ) {
          netdic = @{@"jwt":jwt,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count]};
    }else{
         netdic = @{@"jwt":jwt,@"sname":mysearchBar.text,@"organId":organId==nil?@"":organId,@"pageSize":@"8",@"pageNo":[NSString stringWithFormat:@"%ld",(long)count]};
    }
    [FSJNetworking networkingGETWithActionType:SearchInterestStation requestDictionary:netdic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
        
        NSMutableArray *tempArray = @[].mutableCopy;
        if ([model.status isEqualToString:@"200"]) {
            for (NSDictionary *dict in model.list) {
              
                [tempArray addObject:dict];
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
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (staticOrganId == nil) {
        [self loadDatawith:@""];
    }else{
        [self loadDatawith:staticOrganId];
    }
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     [self.view endEditing:YES];
    [mysearchBar resignFirstResponder];
    if ([mysearchBar.text isEqualToString:@""]) {
        return;
    }
    else{
        if (staticOrganId == nil) {
            [self loadDatawith:@""];
        }else{
            [self loadDatawith:staticOrganId];
        }
    }
}
- (void)finshed:(UIButton *)sender{
    if (self.selectedRows.count == 0) {
        [mysearchBar resignFirstResponder];
        [self.view endEditing:YES];
    }
    else{
    for (int i = 0 ;i<self.selectedRows.count;i++) {
        NSDictionary *dict = self.selectedRows[i];
        NSDictionary *dic = @{@"stationId":[dict objectForKey:@"stationId"],@"jwt":jwt};
        [FSJNetworking networkingPOSTWithActionType:AddInterestStation requestDictionary:dic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
            NSLog(@"%@",[responseObject objectForKey:@"message"]);
            if (i == self.selectedRows.count-1) {
                 [self.navigationController popViewControllerAnimated:YES];
                [MBProgressHUD showSuccess:@"添加成功"];
            }
        } failure:^(NSURLSessionDataTask *operation, NSError *error) {
            [MBProgressHUD showError:[NSString stringWithFormat:@"%@",error]];
        }];
    }
    }
    NSLog(@"%ld",self.selectedRows.count);
   
}

- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     FSJMulitiSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (cell == nil) {
         cell = [[FSJMulitiSelectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    NSDictionary *dict =self.dataArray[indexPath.row];
    cell.TopLabel.text = [dict objectForKey:@"sname"];
    
    if ([self.selectedRows containsObject:[self.dataArray objectAtIndex:indexPath.row]]) {
        cell.customSelected = YES;
    }
    cell.customSelectedBlock = ^(BOOL selected){
        if (selected) {
            [self.selectedRows addObject:[self.dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [self.selectedRows removeObject:[self.dataArray objectAtIndex:indexPath.row]];
        }
    };
   [cell reloadCell];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [searchView removeFromSuperview];
}
@end
