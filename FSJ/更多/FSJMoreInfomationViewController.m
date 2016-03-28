//
//  FSJMoreInfomationViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/16.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMoreInfomationViewController.h"
#import "FSJCollectionViewCell.h"
#import "ReusableView.h"

#import "FSJPeopleManagimentviewController.h"
#import "FSJTongjiViewController.h"

@interface FSJMoreInfomationViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    UICollectionView *myCollView;
    FSJPeopleManagimentviewController *people;
    FSJTongjiViewController *tongji;
}

@end

@implementation FSJMoreInfomationViewController
static NSString *cellID = @"cellID";
static NSString *headerID = @"headerID";
static NSString *footerID = @"footerID";
static NSString * const reuseIdentifier = @"Cell";
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self customNav];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.minimumInteritemSpacing = 1;
    layout.minimumLineSpacing = 1;
    layout.itemSize = CGSizeMake(WIDTH/3-2, 100);
    layout.sectionInset = UIEdgeInsetsMake(0, 1, 1, 1);
    myCollView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH) collectionViewLayout:layout];
    [myCollView registerNib:[UINib nibWithNibName:@"FSJCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:cellID];
    [myCollView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerID];
    [myCollView registerClass:[ReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:footerID];
    [myCollView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    myCollView.delegate = self;
    myCollView.dataSource = self;
    myCollView.backgroundColor = SystemLightGrayColor;
    [self.view addSubview:myCollView];
}
- (void)customNav{
   self.navigationController.navigationBar.hidden = NO;
    self.title = @"更多";
    
    [self.navigationController.navigationBar setBackgroundColor:SystemBlueColor];
    [self.navigationController.navigationBar setBarTintColor:SystemBlueColor];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],UITextAttributeTextColor,nil]];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeCustom];
    myButton.frame = CGRectMake(0, 0, 15, 15);
    [myButton setBackgroundImage:[UIImage imageNamed:@"fanhui"] forState:UIControlStateNormal];
    UIBarButtonItem *item6 = [[UIBarButtonItem alloc]initWithCustomView:myButton];
    [myButton addTarget:self action:@selector(backTomain:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = item6;
    self.navigationController.navigationBar.tintColor = SystemWhiteColor;
}
- (void)backTomain:(UIButton *)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 3;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FSJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.cellimage.contentMode = UIViewContentModeScaleAspectFit;
    cell.backgroundColor = [UIColor whiteColor];
    NSArray *arrayFsz = @[@"人员信息管理",@"发射站管理",@"发射机管理"];
    NSArray *arrayFszimg = @[@"renyuan",@"fashezhan",@"fasheji111"];
    NSArray *arrayWarn = @[@"实时警告",@"警告历史",@"统计"];
    NSArray *arrayWarnimg = @[@"shishi",@"gaojing",@"tongji"];
    switch (indexPath.section) {
        case 0:
            cell.infoLabel.text = arrayWarn[indexPath.row];
            cell.cellimage.image = [UIImage imageNamed:arrayWarnimg[indexPath.row]];
            break;
        case 1:
            cell.infoLabel.text = arrayFsz[indexPath.row];
            cell.cellimage.image = [UIImage imageNamed:arrayFszimg[indexPath.row]];
            break;
        default:
            break;
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    people = [[FSJPeopleManagimentviewController alloc]init];
                    people.InfoType = Warning;
                    [self.navigationController pushViewController:people animated:YES];
                    break;
                case 1:
                    people = [[FSJPeopleManagimentviewController alloc]init];
                    people.InfoType = Warned;
                    [self.navigationController pushViewController:people animated:YES];
                    break;
                case 2:
                    tongji = [[FSJTongjiViewController alloc]init];
                    [self.navigationController pushViewController:tongji animated:YES];
                    
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    people = [[FSJPeopleManagimentviewController alloc]init];
                    people.InfoType = PeopleManage;
                    [self.navigationController pushViewController:people animated:YES];
                    
                    break;
                case 1:
                    people = [[FSJPeopleManagimentviewController alloc]init];
                    people.InfoType = StationManage;
                    [self.navigationController pushViewController:people animated:NO];
                    break;
                case 2:
                    people = [[FSJPeopleManagimentviewController alloc]init];
                    people.InfoType = FSJManage;
                    [self.navigationController pushViewController:people animated:YES];
                    
                    break;
                    
                default:
                    break;
            }
        default:
            break;
    }

}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section >=0) {
        ReusableView *header = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerID forIndexPath:indexPath];
        
        header.backgroundColor = SystemLightGrayColor;
        if (indexPath.section == 0) {
            header.text = @" 告警信息";
        }
        if (indexPath.section == 1) {
            header.text = @" 发射站管理";
            
        }
        return header;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    //  if (section>0) {
    return CGSizeMake(0, 44);
    // }
    //  return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    //if (section==3) {
    return CGSizeZero;
    // }
    //  return CGSizeMake(0, 20);
}
-(BOOL)prefersStatusBarHidden
{
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
