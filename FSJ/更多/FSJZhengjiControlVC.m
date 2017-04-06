//
//  FSJZhengjiControlVC.m
//  FSJ
//
//  Created by Monstar on 2017/3/21.
//  Copyright © 2017年 Monstar. All rights reserved.
//

#import "FSJZhengjiControlVC.h"
#import "FSJShebeiInfo50W.h"

@interface FSJZhengjiControlVC ()<UITableViewDataSource,UITableViewDelegate>{
    FSJZhengjicontrol50W *basemodel;
    BOOL isShow1;
    BOOL isShow2;
    BOOL isShow3;
    BOOL isShow4;
    BOOL isShow5;
    BOOL isShow6;
    BOOL isShow7;

}
@property (nonatomic,strong)NSMutableArray *myDataArray;
@end

@implementation FSJZhengjiControlVC


- (instancetype)initZhengjiControlVCWithframe:(CGRect)rect andRequestdic:(NSDictionary *)requestDic{
    if (self) {
        [self initDatawith:requestDic];
        [self layoutwithframe:rect];
    }
    return self;
}
- (void)initDatawith:(NSDictionary *)requestDic{
    [SVProgressHUD showWithStatus:@"加载中"];
    [FSJNetworking networkingGETWithActionType:ZhengjiKongzhi50W requestDictionary:requestDic success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject) {
        FSJJiankongBase *model = [FSJJiankongBase initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"] ) {
            basemodel = [FSJZhengjicontrol50W initWithDictionary:model.data];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:model.message];
        }
        [SVProgressHUD dismiss];
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        
    }];

}
- (void)layoutwithframe:(CGRect)rect{
    
    self.tableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.bounces = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.rowHeight = 44;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 7;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *titleStr = @"";
    VVDLog(@"section == %ld",(long)section);
    switch (section) {
        case 0:
            titleStr = @"星期一";
            break;
        case 1:
            titleStr = @"星期二";
            break;
        case 2:
            titleStr = @"星期三";
            break;
        case 3:
            titleStr = @"星期四";
            break;
        case 4:
            titleStr = @"星期五";
            break;
        case 5:
            titleStr = @"星期六";
            break;
        case 6:
            titleStr = @"星期天";
            break;
            
        default:
            break;
    }
    JQLayoutButton *button = [JQLayoutButton buttonWithType:UIButtonTypeCustom];
   
    button.frame = CGRectMake(5, 5, 100, 34);
    button.enabled = YES;
    switch (section) {
        case 0:
            button.selected=isShow1;
            break;
        case 1:
            button.selected=isShow2;
            break;
        case 2:
            button.selected=isShow3;
            break;
        case 3:
            button.selected=isShow4;
            break;
        case 4:
            button.selected=isShow5;
            break;
        case 5:
            button.selected=isShow6;
            break;
        case 6:
            button.selected=isShow7;
            break;
            
        default:
            break;
    }

    [button setTitle:titleStr forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"xia"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"you"] forState:UIControlStateSelected];
    button.titleLabel.font = [UIFont systemFontOfSize:14];
    button.tag = 500+section;
    button.layoutStyle = JQLayoutButtonStyleLeftImageRightTitle;
    button.imageSize = CGSizeMake(10, 10);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(headerClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 44)];
    bgView.backgroundColor = [UIColor colorWithRed:(53/255.0) green:(166/255.0) blue:(187/255.0) alpha:0.2];
    [bgView addSubview:button];
    return bgView;
}
- (void)headerClicked:(UIButton *)sender{
    
    if (sender.selected == YES) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
   // sender.selected = !sender.selected;
    switch (sender.tag - 500) {
        case 0:
            isShow1 = sender.selected;
            break;
        case 1:
            isShow2 = sender.selected;
            break;
        case 2:
            isShow3 = sender.selected;
            break;
        case 3:
            isShow4 = sender.selected;
            break;
        case 4:
            isShow5 = sender.selected;
            break;
        case 5:
            isShow6 = sender.selected;
            break;
        case 6:
            isShow7 = sender.selected;
            break;

        default:
            break;
    }
    
    [self.tableView reloadData];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if (isShow1) {
                return 0;
            }else{
                return basemodel.scheduleMon.count;
            }
            
            break;
        case 1:
            if (isShow2) {
                return 0;
            }else{
                return basemodel.scheduleTue.count;
            }
            
            break;
        case 2:
            if (isShow3) {
                return 0;
            }else{
                return basemodel.scheduleWed.count;
            }
         
            break;
        case 3:
            if (isShow4) {
                return 0;
            }else{
                return basemodel.scheduleThurs.count;
            }
            
            break;
        case 4:
            if (isShow5) {
                return 0;
            }else{
                return basemodel.scheduleFri.count;
            }
            
            break;
        case 5:
            if (isShow6) {
                return 0;
            }else{
                return basemodel.scheduleSat.count;
            }
            break;
        case 6:
            if (isShow7) {
                return 0;
            }else{
                return basemodel.scheduleSun.count;
            }
            break;            
        default:
            break;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *celldic = @{};
    switch (indexPath.section) {
        case 0:
            celldic = basemodel.scheduleMon[indexPath.row];

            break;
        case 1:
            celldic = basemodel.scheduleTue[indexPath.row];

            break;
        case 2:
            celldic = basemodel.scheduleWed[indexPath.row];
 
            break;
        case 3:
            celldic = basemodel.scheduleThurs[indexPath.row];

            break;
        case 4:
            celldic = basemodel.scheduleFri[indexPath.row];
 
            break;
        case 5:
            celldic = basemodel.scheduleSat[indexPath.row];

            break;
        case 6:
            celldic = basemodel.scheduleSun[indexPath.row];

            break;
            
        default:
            break;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@-%@",[celldic valueForKey:@"startTime"],[celldic valueForKey:@"endTime"]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
   
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
