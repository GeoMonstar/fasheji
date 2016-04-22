//
//  FSJMapViewController.m
//  FSJ
//
//  Created by Monstar on 16/4/13.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJMapViewController.h"
#import "MyAnimatedAnnotationView.h"
#import "FSJMeViewController.h"
#import "FSJAllFSJ.h"
#import "FSJOneFSJ.h"
#import "FSJOneFSJTableViewCell.h"
#import "FSJMoreInfomationViewController.h"
#import "FSJPeopleManagerDetailViewController.h"
#import "FSJOneCity.h"
#import "FSJPeopleManagimentviewController.h"
#import "FSJTongjiViewController.h"

#define tableviewHeight self.view.bounds.size.height/4+50
#define tableviewY      self.view.bounds.size.height/4*3 -50
#define moveDistance    self.view.bounds.size.height/4
NSString *keyCityError      = @"kCityError";
NSString *keyCityNor        = @"kCityNor";
NSString *keyCityNorID      = @"kCityNorID";
NSString *keyCityErrorID    = @"kCityErrorID";
NSString *keyCityErrorCount = @"kCityErrorCount";
NSString *keyCityNorCount   = @"kCityNorCount";
@interface FSJMapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKDistrictSearchDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    
    NSMutableArray *imageViewArr;
    NSMutableArray *btnArr;
    UINavigationController *nav;
    BMKLocationService* locService;
    NSMutableArray    *listNormal;
    NSMutableArray    *listidNormal;
    NSMutableArray    *listError;
    NSMutableArray    *namelist;
    NSMutableArray    *listidError;
    NSMutableArray    *searchList;
    NSMutableArray    *nameIdDic;
    NSMutableArray    *stationArr;
    NSMutableArray    *stationNormal;
    NSMutableArray    *stationError;
    NSMutableArray    *overlayNor;
    NSMutableArray    *overlayEor;
    NSMutableArray    *quanjuArr;
    
    NSMutableArray    *cityNormal;
    NSMutableArray    *cityError;
    NSMutableArray    *cityidNormal;
    NSMutableArray    *cityidError;
    NSMutableArray    *allcityName;
    NSMutableArray    *allcityModel;
    NSMutableArray    *cityoverlayErr;
    NSMutableArray    *cityoverlayNor;
    NSMutableArray    *allsite;
    BMKDistrictSearch *_NormalSearch;
    BMKDistrictSearch *_ErrorSearch;
    BMKPolyline       *normalArea;
    BMKPolygon        *errorArea;
    BMKGeoCodeSearch* _geocodesearch;
    BMKGeoCodeSearch* _geocodesearchCity;
    NSString * staticAreaname;
    NSString * staticJwt;
    NSString * staticareaType;
    NSString * staticareaId;
    NSString * staticuserId;
    NSString * statitopic;
    NSString * staticName;
    NSInteger *sizeNo;
    NSInteger *pageNo;
    NSInteger *warnNumber;
    BOOL showWarn;
    BOOL showCity;
    BOOL showProvince;
    BOOL districtSearch;
    BOOL full;
    BOOL showPop;
    UIColor* WarnStokeColor;
    UIColor* WarnFillColor;
    UIColor* NorStokeColor;
    UIColor* NorFillColor;
    BMKMapView *_mapView;
    UIView *BackgroundVIew;
    UISearchBar *mainSearchbar;
    UIButton *userBtn;
    UIView *tabbarBg;
    
    NSArray *gaojingArr;
    NSArray *shebeiArr;
    
    NSArray *gaojingimgArr;
    NSArray *shebeiimgArr;
    
    NSArray *shebeiTypeArr;
    NSArray *gaojingTypeArr;
    UIView *maskview;
    NSString *tableViewTitle;
}
//@property (nonatomic, strong)NSMutableArray *allsite;
@property (nonatomic, strong)UITableView *mytableView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

#define FirstLevel  6.0f
#define SecondLevel 9.0f
#define ThirdtLevel 11.0f
#define ForthLevel  13.0f

@end

@implementation FSJMapViewController


#pragma mark -- 视图周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_mapView viewWillAppear];
    
    self.navigationController.navigationBarHidden = YES;
    _mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
    locService.delegate = self;
    _geocodesearchCity.delegate = self;
    _geocodesearch.delegate = self;
}
- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
    //[[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
    locService.delegate = nil;
    _geocodesearch.delegate = nil;
    _geocodesearchCity.delegate = nil;
    for (BMKDistrictSearch *search in searchList) {
        search.delegate = nil;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self receiveWarnNoti];
    
        if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
        {
            self.navigationController.navigationBar.translucent = NO;
        }
    [self customUI];
    [self addCustomGestures];//添加自定义的手势
    
    staticJwt      = [[EGOCache globalCache]stringForKey:@"jwt"];
    staticareaType = [[EGOCache globalCache]stringForKey:@"areaType"];
    staticareaId   = [[EGOCache globalCache]stringForKey:@"areaId"];
    staticuserId   = [[EGOCache globalCache]stringForKey:@"userId"];
    staticName     = [[EGOCache globalCache]stringForKey:@"areaname"];
    statitopic     = [NSString stringWithFormat:@"%@/#",[[EGOCache globalCache]stringForKey:@"topic"]];
    NSDictionary *dic = @{@"areaId":staticareaId,@"areaType":staticareaType,@"userId":staticuserId,@"jwt":staticJwt};
    if ([staticareaType isEqualToString:@"1"]) {
        [UIView animateWithDuration:1.0 animations:^{
            _mapView.zoomLevel = FirstLevel;
            
        }];
        _mapView.minZoomLevel = FirstLevel;
        [self searchWithModelwith:dic];
    }
    if ([staticareaType isEqualToString:@"2"]) {
        [self getCtiyWithID:@[staticareaId] andName:@[staticName]];
        [UIView animateWithDuration:1.0 animations:^{
            _mapView.zoomLevel = SecondLevel;
        }];
        _mapView.minZoomLevel = SecondLevel;
    }
    if ([staticareaType isEqualToString:@"3"]) {
        [self getCityStationWith:dic];
        //        [UIView animateWithDuration:1.0 animations:^{
        //            _mapView.minZoomLevel = ThirdtLevel;
        //        }];
        _mapView.minZoomLevel = ThirdtLevel;
    }
}
#pragma mark -- 警告通知
- (void)receiveWarnNoti{
    
        [MPush registerForClientId:@"ios0422" withAppName:@"fsj"];
    
    
    [MPush setMessageCallback:^(NSString *mes) {
        if (mes) {
            [self changeStatusWith:mes];
        }
        NSLog(@"警告消息===========%@",mes);
    }];
    
    [MPush setConnectCallback:^(int code) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [MPush subscribeForArea:statitopic];
            });
            
        }];
    
    
}
- (void)changeStatusWith:(NSString *)jsonString{
            NSData  *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary *resultsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            NSString *contentStr = resultsDic[@"content"];
            NSString *statusStr  = resultsDic[@"status"];
//    NSString *contentStr = jsonString[0];
//    NSString *statusStr  = jsonString[1];
    NSArray  *arr = [contentStr componentsSeparatedByString:@"/"];
    //{"content":"1/11/12/10000","status":"0"}
    if ([statusStr isEqualToString:@"0"]) {
        NSInteger num = [[EGOCache globalCache]stringForKey:arr[2]].integerValue;
        num -= 1;
        for (BMKPointAnnotation *annoatation in stationError) {
            if ([annoatation.subtitle isEqualToString:arr.lastObject]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeAnnotation:annoatation];
                    annoatation.title = @"zc";
                    if (_mapView.zoomLevel >ThirdtLevel) {
                        [_mapView addAnnotation:annoatation];
                    }
                    [stationError  removeObject:annoatation];
                    [stationNormal addObject:annoatation];
                });
                NSLog(@"去掉前错误数量%lu",(unsigned long)stationError.count);
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)num] forKey:arr[2]];
        });
        if ([[NSString stringWithFormat:@"%ld",(long)num] isEqualToString:@"0"]) {
            for (BMKPolygon * polygon in cityoverlayErr) {
                if ([polygon.subtitle isEqualToString:arr[2]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [cityoverlayErr removeObject:polygon];
                        [cityoverlayNor addObject:polygon];
                        polygon.title = @"0";
                        if (_mapView.zoomLevel < ThirdtLevel && _mapView.zoomLevel >= SecondLevel) {
                            [_mapView removeOverlay:polygon];
                            [_mapView addOverlay:polygon];
                        }
                    });
                }
            }
            NSInteger sheng = [[EGOCache globalCache]stringForKey:arr[1]].integerValue;
            sheng -=1;
            
            //dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)sheng] forKey:arr[1]];
            if ([[NSString stringWithFormat:@"%ld",(long)sheng] isEqualToString:@"0"]) {
                for (BMKPolygon * polygon in overlayEor) {
                    if ([polygon.subtitle isEqualToString:arr[1]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_mapView removeOverlay:polygon];
                            polygon.title = @"0";
                            if (_mapView.zoomLevel <SecondLevel) {
                                [_mapView addOverlay:polygon];
                            }
                            [overlayEor removeObject:polygon];
                            [overlayNor addObject:polygon];
                        });
                    }
                }
            }
        }
    }
    if ([statusStr isEqualToString:@"1"]){
        NSInteger num = [[EGOCache globalCache]stringForKey:arr[2]].integerValue;
        num += 1;
        for (BMKPointAnnotation *annoatation in stationNormal) {
            if ([annoatation.subtitle isEqualToString:arr.lastObject]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeAnnotation:annoatation];
                    annoatation.title = @"gj";
                    if (_mapView.zoomLevel > ThirdtLevel) {
                        [_mapView addAnnotation:annoatation];
                    }
                    [stationNormal  removeObject:annoatation];
                    [stationError   addObject:annoatation];
                });
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)num] forKey:arr[2]];
        });
        if (num < 0) {
            return;
        }
        if ([[NSString stringWithFormat:@"%ld",(long)num] isEqualToString:@"1"]) {
            for (BMKPolygon * polygon in cityoverlayNor) {
                if ([polygon.subtitle isEqualToString:arr[2]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_mapView removeOverlay:polygon];
                        polygon.title = @"1";
                        if (_mapView.zoomLevel < ThirdtLevel && _mapView.zoomLevel >= SecondLevel) {
                            [_mapView addOverlay:polygon];
                        }
                        [cityoverlayNor removeObject:polygon];
                        [cityoverlayErr addObject:polygon];
                    });
                    break;
                }
            }
            NSInteger sheng = [[EGOCache globalCache]stringForKey:arr[1]].integerValue;
            sheng +=1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",(long)sheng] forKey:arr[1]];
            });
            if (sheng <0) {
                return;
            }
            if ([[NSString stringWithFormat:@"%ld",(long)sheng] isEqualToString:@"1"]) {
                for (BMKPolygon * polygon in overlayNor) {
                    if ([polygon.subtitle isEqualToString:arr[1]]) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [_mapView removeOverlay:polygon];
                            polygon.title = @"1";
                            if (_mapView.zoomLevel <SecondLevel) {
                                [_mapView addOverlay:polygon];
                            }
                            [overlayNor removeObject:polygon];
                            [overlayEor addObject:polygon];
                        });
                        break;
                    }
                }
            }
        }
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

#pragma mark -- 控件和事件
- (void)customUI{
    UIView *statusView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 20)];
    statusView.backgroundColor = SystemBlueColor;
    [self.view addSubview:statusView];
    // self.view.backgroundColor = SystemBlueColor;
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    shebeiArr = @[@"人员信息管理",@"发射站管理",@"发射机管理"];
    shebeiimgArr =@[@"tbrenyuan.png",@"tbfashezhan.png",@"tbfasheji.png"];
    gaojingArr = @[@"统计",@"警告查询"];
    gaojingimgArr = @[@"tbtongji.png",@"tbchaxun.png"];
    WarnStokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    NorStokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    WarnFillColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    NorFillColor   = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1];
    sizeNo = 0;
    pageNo = 0;
    warnNumber = 0;
    imageViewArr   = @[].mutableCopy;
    btnArr         = @[].mutableCopy;
    cityoverlayErr = @[].mutableCopy;
    cityoverlayNor = @[].mutableCopy;
    cityError      = @[].mutableCopy;
    cityNormal     = @[].mutableCopy;
    cityidError    = @[].mutableCopy;
    cityidNormal   = @[].mutableCopy;
    allcityName    = @[].mutableCopy;
    allcityModel   = @[].mutableCopy;
    quanjuArr      = @[].mutableCopy;
    nameIdDic      = @[].mutableCopy;
    namelist       = @[].mutableCopy;
    listNormal     = @[].mutableCopy;
    listidNormal   = @[].mutableCopy;
    listError      = @[].mutableCopy;
    listidError    = @[].mutableCopy;
    stationArr     = @[].mutableCopy;
    stationNormal  = @[].mutableCopy;
    stationError   = @[].mutableCopy;
    overlayEor     = @[].mutableCopy;
    overlayNor     = @[].mutableCopy;
    allsite        = @[].mutableCopy;
    _mapView.gesturesEnabled    = YES;
    _mapView.zoomEnabledWithTap = YES;
    _mapView.zoomEnabled        = YES;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearchCity = [[BMKGeoCodeSearch alloc]init];
    _mapView =[[BMKMapView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGH)];
    [self.view addSubview:_mapView];
    
    BackgroundVIew = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGH*0.08)];
    BackgroundVIew.backgroundColor = SystemBlueColor;
    userBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    userBtn.frame = CGRectMake(WIDTH *0.015,HEIGH * 0.015, HEIGH * 0.05, HEIGH * 0.05);
    [userBtn setBackgroundImage:[UIImage imageNamed:@"geren1"] forState:UIControlStateNormal];
    [userBtn addTarget:self action:@selector(UserInfo:) forControlEvents:UIControlEventTouchUpInside];
    [BackgroundVIew addSubview:userBtn];
    
    mainSearchbar = [[UISearchBar alloc]initWithFrame:CGRectMake(WIDTH *0.13,HEIGH * 0.01, WIDTH* 0.86, HEIGH *0.06)];
    mainSearchbar.placeholder = @"查找设备名称、IP地址";
    mainSearchbar.delegate = self;
    mainSearchbar.backgroundColor = [UIColor clearColor];
    mainSearchbar.searchBarStyle =UISearchBarStyleDefault;
    mainSearchbar.barTintColor = [UIColor whiteColor];
    [mainSearchbar setBackgroundImage:[UIImage imageWithColor:SystemWhiteColor]];
    
    mainSearchbar.layer.borderColor = SystemBlueColor.CGColor;
    mainSearchbar.layer.borderWidth = 0;
    mainSearchbar.layer.cornerRadius = HEIGH *0.03;
    mainSearchbar.layer.masksToBounds = YES;
    mainSearchbar.barStyle =UIBarStyleBlack;
    mainSearchbar.showsCancelButton = YES;
    [BackgroundVIew addSubview:mainSearchbar];
    [_mapView addSubview:BackgroundVIew];
    //[self.view insertSubview:BackgroundVIew atIndex:0];
    tabbarBg = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGH *0.93, WIDTH,  HEIGH *0.07)];
    //tabbarBg.userInteractionEnabled = NO;
    tabbarBg.backgroundColor = SystemLightGrayColor;
    self.view.backgroundColor = SystemWhiteColor;
    NSArray *norimg = @[@"ditu",@"jiankong",@"shebei",@"tbgaojing"];
    NSArray *seletedimg = @[@"ditu1",@"jiankong1",@"shebei1",@"tbgaojing1"];
    NSArray *titleArr  = @[@"地图",@"监控",@"设备",@"告警"];
    maskview = [[UIView alloc]initWithFrame:CGRectMake(0, Popviewheight * 0.08 , Popviewwidth, Popviewheight * 0.87 -20)];
    maskview.backgroundColor = [[UIColor whiteColor]colorWithAlphaComponent:0.9];

    for (int i = 0; i<4; i ++) {
        FSJTabbarBtn * btn = [FSJTabbarBtn buttonWithType:UIButtonTypeCustom];
         btn.frame = CGRectMake(i * WIDTH/4 , 0, WIDTH/4, HEIGH *0.07);
         btn.enabled = YES;
         UIImage *btnImg = [UIImage imageNamed:norimg[i]];
         UIImage *sebtnImg = [UIImage imageNamed:seletedimg[i]];
        [btn setImage:btnImg forState:UIControlStateNormal];
        [btn setImage:sebtnImg forState:UIControlStateSelected];
        [btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [btn setFont:[UIFont systemFontOfSize: 10.0]];
         btn.imageView.backgroundColor = [UIColor clearColor];
        //[btn setTitleEdgeInsets:UIEdgeInsetsMake(HEIGH *0.035,-20, 0, 20)];
        [btn setTitleColor:SystemGrayColor forState:UIControlStateNormal];
        [btn setTitleColor:SystemBlueColor forState:UIControlStateSelected];
        
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
         btn.tag = 600 + i;
        [btnArr addObject:btn];
        [tabbarBg addSubview:btn];
    }
    for (UIButton *btn in btnArr) {
        if (btn.tag == 600) {
            btn.selected = YES;
        }
        if (btn.tag == 601) {
            btn.enabled = NO;
        }
    }
    [self.view addSubview:tabbarBg];
}
- (void)btnClicked:(UIButton *)sender{
    NSLog(@"clicked");
    if (sender.selected == YES) {
        return;
    }
    else{
        if (sender.tag == 602 || sender.tag == 603) {
            [_mapView addSubview:maskview];
        }
        else{
            
            [maskview removeFromSuperview];
        }
         [[WBPopMenuSingleton shareManager]hideMenu];
       for (UIButton *btn in btnArr) {

            btn.selected =NO;
            sender.selected = YES;
        }
        if (sender.tag == 602 && sender.selected == YES) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createPopwithName:shebeiArr andImg:shebeiimgArr andtag:602];
            });
        }
        if (sender.tag == 603 && sender.selected == YES) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self createPopwithName:gaojingArr andImg:gaojingimgArr andtag: 603];
            });
        }
        if (sender.tag == 600 || sender.tag == 601) {
        }
    }
}
- (void)createPopwithName:(NSArray *)nameArr andImg:(NSArray *)imgArr andtag:(NSInteger) btntag{
    NSMutableArray *obj = [NSMutableArray array];
    for (NSInteger i = 0; i < nameArr.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = imgArr[i];
        info.title = nameArr[i];
        [obj addObject:info];
    };
    FSJTongjiViewController * tongji = [[FSJTongjiViewController alloc]init];
     FSJPeopleManagimentviewController* people = [[FSJPeopleManagimentviewController alloc]init];
    [[WBPopMenuSingleton shareManager]showPopMenuSelecteWithFrame:200
                                                             item:obj
                                                           action:^(NSInteger index) {
       if ([nameArr[index] isEqualToString:@"统计"]) {
           [self.navigationController pushViewController:tongji animated:YES];
       };
         if ([nameArr[index] isEqualToString:@"人员信息管理"]) {
                    people.InfoType = PeopleManage;
            [self.navigationController pushViewController:people animated:YES];
           };
            if ([nameArr[index] isEqualToString:@"发射站管理"]) {
                     people.InfoType = StationManage;
               [self.navigationController pushViewController:people animated:YES];
            };
             if ([nameArr[index] isEqualToString:@"发射机管理"]) {
                     people.InfoType = FSJManage;
                [self.navigationController pushViewController:people animated:YES];
            };
            if ([nameArr[index] isEqualToString:@"警告查询"]) {
                     people.InfoType = Warned;
                 [self.navigationController pushViewController:people animated:YES];
            };
                  for (UIButton *btn in btnArr) {
                      if (btn.tag == btntag) {
                          btn.selected = NO;
                           [self btnClicked:btn];
                      }
                  }
            }TopView:_mapView];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{

    [self.mytableView removeFromSuperview];
    showWarn = NO;
    [_mapView removeAnnotations:stationError];
    [_mapView removeAnnotations:stationNormal];
    if ([mainSearchbar.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入查询内容"];
        return;
    }
    else{
        [self startKeywordsquery];
    }
    [self.view endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    mainSearchbar.text = @"";
    showPop = NO;
//    showWarn = YES;
//    showCity = YES;
//    showProvince = YES;
    if (_mapView.zoomLevel >=SecondLevel && _mapView.zoomLevel < ThirdtLevel) {
       
        [_mapView addOverlays:cityoverlayNor];
        [_mapView addOverlays:cityoverlayErr];
    }
    if ( _mapView.zoomLevel >= ThirdtLevel) {
        
        [_mapView addAnnotations:stationNormal];
        [_mapView addAnnotations:stationError];
        
    }
    if(_mapView.zoomLevel < SecondLevel) {
       
        [_mapView addOverlays:overlayNor];
        [_mapView addOverlays:overlayEor];
    }
    [_mapView removeAnnotations:quanjuArr];
    [self.view endEditing:YES];
}
- (void)startKeywordsquery{
    showPop = YES;
    if (_mapView.zoomLevel >=SecondLevel && _mapView.zoomLevel < ThirdtLevel) {
        
        [_mapView removeOverlays:cityoverlayNor];
        [_mapView removeOverlays:cityoverlayErr];
    }
    if ( _mapView.zoomLevel >= ThirdtLevel) {
        
        [_mapView removeAnnotations:stationNormal];
        [_mapView removeAnnotations:stationError];
        
    }
    if(_mapView.zoomLevel < SecondLevel) {
        
        [_mapView removeOverlays:overlayNor];
        [_mapView removeOverlays:overlayEor];
    }
//     showWarn = NO;
//     showCity = NO;
//     showProvince = NO;
    [self getallstationInfoWith:mainSearchbar.text andtype:Allstationquery anddicparameter:@"keyword"andShowAnno:YES ];
}
#pragma mark --行政区搜索
- (void)searchWithModelwith:(NSDictionary *)dic{
    showProvince = YES;
    [FSJNetWorking networkingGETWithActionType:NationalarmStatus requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
        if ([model.status isEqualToString:@"200"]) {
            for (NSDictionary *dic in model.list) {
                FSJResultList *listmodel = [FSJResultList initWithDictionary:dic];
                [nameIdDic addObject:listmodel];
                [namelist addObject:listmodel.name];
                [[EGOCache globalCache]setString:listmodel.alarmTotal forKey:listmodel.areaId];
                if ([listmodel.alarmTotal isEqualToString:@"0"]) {
                    [listNormal addObject:listmodel.name];
                    [listidNormal addObject:listmodel.areaId];
                    NSLog(@"正常 == %@",listmodel.name);
                }
                else{
                    [listError   addObject:listmodel.name];
                    [listidError addObject:listmodel.areaId];
                    NSLog(@"警告 == %@",listmodel.name);
                }
            }
            //获取各个城市信息
            [self getCtiyWithID:listidError andName:listError];
            [self getCtiyWithID:listidNormal andName:listNormal];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self searchWithArr:listError];
                [self searchWithArr:listNormal];
            });
            NSLog(@"查询成功 ==== %@",model.status);
        }
        else{
            [SVProgressHUD showErrorWithStatus:model.message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        [SVProgressHUD showErrorWithStatus:@"网络连接失败，请重试"];
    }];
}
#pragma mark --获取地级市信息
- (void)getCtiyWithID:(NSArray *)arrID andName:(NSArray *)arrName{
    if (allcityModel.count >0) {
         [allcityModel removeAllObjects];
    }
   
    [cityNormal   removeAllObjects];
    [cityError    removeAllObjects];
    [cityidError  removeAllObjects];
    [cityidNormal removeAllObjects];
    for (int i = 0; i < arrID.count; i++) {
        NSMutableArray *modelArr = @[].mutableCopy;
        NSDictionary *requestdic = @{@"areaId":arrID[i],@"areaType":@"2",@"userId":staticuserId,@"jwt":staticJwt};
        [FSJNetWorking networkingGETWithActionType:AreaalarmStatus requestDictionary:requestdic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
            FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
            if ([model.status isEqualToString:@"200"]) {
                for (NSDictionary *dic in model.list) {
                    FSJOneCity *cityModel = [FSJOneCity initWithDictionary:dic];
                    [allcityName  addObject:cityModel.name];
                    [allcityModel addObject:cityModel];
                    //[modelArr addObject:cityModel];
                    [[EGOCache globalCache]setString:cityModel.alarmTotal forKey:cityModel.areaId];
                    
                    if ([cityModel.alarmTotal isEqualToString:@"0"]) {
                        [cityNormal   addObject:cityModel.name];
                        [cityidNormal addObject:cityModel.areaId];
                    }
                    else{
                        [cityError   addObject:cityModel.name];
                        [cityidError addObject:cityModel.areaId];
                    }
                }
                
               // [[EGOCache globalCache]setObject:modelArr forKey:arrName[i]];
                [modelArr removeAllObjects];
                //[[EGOCache globalCache]setString:[NSString stringWithFormat:@"%ld",cityError.count] forKey:arrID[i]];
                NSDictionary *dictname = @{keyCityNor:cityNormal,keyCityError:cityError,keyCityNorID:cityidNormal,keyCityErrorID:cityidError,};
                [[EGOCache globalCache]setObject:dictname forKey:arrName[i]];
                
                if ([staticareaType isEqualToString:@"2"]) {
                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
                    geocodeSearchOption.address = staticName;
                    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
                    if(flag)
                    {
                        NSLog(@"geo检索发送成功");
                    }
                    else
                    {
                        NSLog(@"geo检索发送失败");
                    }
                    
                }
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        }];
        [cityNormal   removeAllObjects];
        [cityError    removeAllObjects];
        [cityidError  removeAllObjects];
        [cityidNormal removeAllObjects];
    }
}
- (void)searchWithArr:(NSMutableArray *)array{
    for (int i = 0 ; i < array.count; i ++) {
        BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
        option.city = array[i];
        BMKDistrictSearch *search = [[BMKDistrictSearch alloc]init];
        search.delegate = self;
        [searchList addObject:search];
        districtSearch = [search districtSearch:option];
        //BOOL districtSearch;
        if (districtSearch) {
            NSLog(@"district检索发送成功");
        } else  {
            NSLog(@"district检索发送失败");
            break;
        }
    }
}
#pragma mark - 行政区搜索结果
- (void)onGetDistrictResult:(BMKDistrictSearch *)searcher result:(BMKDistrictResult *)result errorCode:(BMKSearchErrorCode)error {
    NSLog(@"onGetDistrictResult error: %d", error);
    if (error == BMK_SEARCH_NO_ERROR) {
        
        NSLog(@"\nname:%@\n areaId:%d 中心点 纬度:%lf,经度:%lf 节点数目 = %ld", result.name, (int)result.code, result.center.latitude, result.center.longitude,(long)result.pointsCount);
        [overlayEor     addObjectsFromArray:[self createPolgonWith:listError andId:listidError and:result and:@"1" and:YES]];
        [overlayNor  addObjectsFromArray:[self createPolgonWith:listNormal andId:listidNormal and:result and:@"0" and:YES]];
        NSDictionary *dic = (NSDictionary *)[[EGOCache globalCache]objectForKey:staticAreaname];
        if ([staticareaType isEqualToString:@"2"]) {
            _mapView.centerCoordinate = result.center;
        }
        
        [cityoverlayErr addObjectsFromArray:[self createPolgonWith:[dic objectForKey:keyCityError] andId:[dic objectForKey:keyCityErrorID] and:result and:@"1" and:[staticareaType isEqualToString:@"2"]]];
        [cityoverlayNor addObjectsFromArray:[self createPolgonWith:[dic objectForKey:keyCityNor   ] andId:[dic objectForKey:keyCityNorID] and:result and:@"0" and:[staticareaType isEqualToString:@"2"]]];
    }
}
- (NSMutableArray *)createPolgonWith:(NSArray *)array andId:(NSArray *)arrid and:(BMKDistrictResult *)result and:(NSString *)status and:(BOOL)bol{
    NSMutableArray *arr = @[].mutableCopy;
    for (int i = 0; i < array.count; i ++) {
        if ([result.name isEqualToString:array[i]]) {
            BMKPolygon * tempPolgon = [[BMKPolygon alloc]init];
            tempPolgon = [BMKPolygon polygonWithPoints: result.points count:result.pointsCount];
            tempPolgon.title = status;
            tempPolgon.subtitle = arrid[i];
            [arr addObject:tempPolgon];
            if (bol == YES ) {
                [_mapView addOverlay:tempPolgon];
            }
        }
    }
    return arr;
}
#pragma mark --警告区域图层
- (BMKOverlayView*)mapView:(BMKMapView *)map viewForOverlay:(id<BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKPolygon class]]) {
        BMKPolygonView *polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        if ([overlay.title isEqualToString:@"1"]) {
            polygonView.strokeColor = WarnStokeColor;
            polygonView.fillColor = WarnFillColor;
        }
        else{
            polygonView.strokeColor = NorStokeColor;
            polygonView.fillColor = NorFillColor;
        }
        polygonView.lineWidth = 1;
        polygonView.lineDash = NO;
        return polygonView;
    }
    return nil;
}
#pragma mark - BMKMapViewDelegate
- (void)mapViewDidFinishLoading:(BMKMapView *)mapView {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    //[alert show];
    //alert = nil;
    _mapView.compassPosition = CGPointMake(15, 90);
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"地图缩放等级 == %lf",_mapView.zoomLevel);
    if (_mapView.zoomLevel >=SecondLevel) {
        showProvince = NO;
        [_mapView removeOverlays:overlayNor];
        [_mapView removeOverlays:overlayEor];
        if (showCity == YES &&!showPop) {
            [_mapView addOverlays:cityoverlayNor];
            [_mapView addOverlays:cityoverlayErr];
            showCity = NO;
        }
        if ( _mapView.zoomLevel >= ThirdtLevel) {
            self.mytableView.hidden = NO;
            showCity =YES;
            //dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeOverlays:cityoverlayNor];
                [_mapView removeOverlays:cityoverlayErr];
          //  });
           

            if (showWarn == YES) {
                [_mapView addAnnotations:stationNormal];
                [_mapView addAnnotations:stationError];
                //showWarn = NO;
            }
        }
        else{
            self.mytableView.hidden = YES;
           // dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:stationError];
                [_mapView removeAnnotations:stationNormal];
            //});
        }
    }
    else{
        showCity = YES;
        [_mapView removeAnnotations:stationError];
        [_mapView removeAnnotations:stationNormal];
        [_mapView removeOverlays:cityoverlayErr];
        [_mapView removeOverlays:cityoverlayNor];
        if (!showProvince &&!showPop) {
            [_mapView addOverlays:overlayEor];
            [_mapView addOverlays:overlayNor];
            showProvince = YES;
        }
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{

}
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    if (showPop) {
        return;
    }
    else{
    if (_mapView.zoomLevel < SecondLevel) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
        [_geocodesearch reverseGeoCode:reverseGeocodeSearchOption];
        showProvince = NO;
    }
    if (_mapView.zoomLevel  < ThirdtLevel && _mapView.zoomLevel >= SecondLevel) {
        BMKReverseGeoCodeOption *reverseGeocodeSearchOptionCity = [[BMKReverseGeoCodeOption alloc]init];
        reverseGeocodeSearchOptionCity.reverseGeoPoint = coordinate;
        [_geocodesearchCity reverseGeoCode:reverseGeocodeSearchOptionCity];
        }
    }
}
#pragma mark -- 反向地理编码 获得点击地区坐标
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (searcher == _geocodesearchCity){
        if (error == 0) {
            NSLog(@"%@",result.address);
            for (NSString *str in allcityName) {
                if ([result.address containsString:str]) {
                    // _mapView.centerCoordinate = result.location;
                    NSLog(@"%@",str);
                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
                    geocodeSearchOption.address = str;
                    BOOL flag = [_geocodesearchCity geoCode:geocodeSearchOption];
                    if(flag)
                    {
                        NSLog(@"geocity检索发送成功");
                    }
                    else
                    {
                        NSLog(@"geocity检索发送失败");
                    }
                }
                else{
                }
            }
        }
        else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%u",error]];
            NSLog(@"错误代码 == %u",error);
        }
    }
    if (searcher == _geocodesearch) {
        if (error == 0) {
            NSLog(@"%@",result.address);
            for (NSString *str in namelist) {
                if ([result.address hasPrefix:str]) {
                    _mapView.centerCoordinate = result.location;
                    NSLog(@"%@",str);
                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
                    geocodeSearchOption.address = str;
                    BOOL flag = [_geocodesearch geoCode:geocodeSearchOption];
                    if(flag)
                    {
                        NSLog(@"geo检索发送成功");
                    }
                    else
                    {
                        NSLog(@"geo检索发送失败");
                    }
                }
                else {
                }
            }
        }else{
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%u",error]];
            NSLog(@"错误代码 == %u",error);
        }
    }
}
#pragma mark -- 正向地理编码
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //清楚标注记录
    for (FSJResultList *tempModle in nameIdDic) {
        if ([tempModle.name isEqualToString:result.address]) {
            [self getCtiyWithID:@[tempModle.areaId] andName:@[tempModle.name]];
        }
    }
    if (searcher == _geocodesearch) {
        if (stationArr.count >0 || stationError.count>0 || stationNormal.count>0 || cityoverlayErr.count || cityoverlayNor.count > 0 || cityError.count > 0 || cityNormal.count > 0) {
            [stationArr     removeAllObjects];
            [stationError   removeAllObjects];
            [stationNormal  removeAllObjects];
            [cityoverlayNor removeAllObjects];
            [cityoverlayErr removeAllObjects];
            [cityNormal     removeAllObjects];
            [cityError      removeAllObjects];
        }
        NSDictionary *dict = (NSDictionary *)[[EGOCache globalCache]objectForKey:result.address];
        staticAreaname = result.address;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _mapView.zoomLevel = SecondLevel;
            [_mapView removeOverlays:overlayNor];
            [_mapView removeOverlays:overlayEor];
        });
        dispatch_async(dispatch_get_main_queue(), ^{
            [self searchWithArr:[dict objectForKey:keyCityError]];
            [self searchWithArr:[dict objectForKey:keyCityNor]];
        });
        showCity = YES;
    }
    if (searcher == _geocodesearchCity) {
        _mapView.centerCoordinate = result.location;
       
        for (FSJOneCity *cityModel in allcityModel) {
            
            if ([cityModel.name isEqualToString:result.address]) {
                
                NSDictionary *requestdic = @{@"areaId":cityModel.areaId,@"areaType":@"3",@"userId":staticuserId,@"jwt":staticJwt};
                [self getCityStationWith:requestdic];
            }
        }
        NSLog(@"address = %@, 坐标 = %lf %lf",result.address,result.location.longitude,result.location.latitude);
    }
}
#pragma mark -- 获得发射站数据
- (void)getCityStationWith:(NSDictionary *)dic{
     _mapView.zoomLevel = ForthLevel - 0.5;
    showWarn = YES;
    if (stationArr.count >0) {
        [stationArr removeAllObjects];
    }
    [_mapView removeOverlays:cityoverlayErr];
    [_mapView removeOverlays:cityoverlayNor];
    [FSJNetWorking networkingGETWithActionType:AreaalarmStatus requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        if (responseObject) {
            FSJUserInfo *user = [FSJUserInfo initWithDictionary:responseObject];
            //获取警告数量
            //warnNumber = (int)[user.alarmTotal integerValue];
            if ([user.status isEqualToString:@"200"]) {
                for (NSDictionary *dic in user.list) {
                    FSJResultList *listmodel = [FSJResultList initWithDictionary:dic];
                    [stationArr addObject:listmodel];
                }
                [_mapView removeAnnotations:quanjuArr];
                [self addAnimatedAnnotationWith:stationArr];
                
            }else{
                NSLog(@"%@",user.message);
            }
        }
        else{
            NSLog(@"%@",responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}
#pragma mark -- 添加标注 Annotation
- (void)addAnimatedAnnotationWith:(NSArray *)array{
    for (FSJResultList *model in stationArr) {
        if ([model.status isEqualToString:@"0"]) {
            BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = model.lat.floatValue;
            coor.longitude = model.lon.floatValue;
            annotataion.coordinate = coor;
            annotataion.title = @"zc";
            annotataion.subtitle = model.stationId;
            [_mapView addAnnotation:annotataion];
            _mapView.centerCoordinate = coor;
            //dispatch_async(dispatch_get_main_queue(), ^{
            [stationNormal addObject:annotataion];
            //});
        }
        if([model.status isEqualToString:@"1"]){
            BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = model.lat.floatValue;
            coor.longitude = model.lon.floatValue;
            annotataion.coordinate = coor;
           // _mapView.centerCoordinate = coor;
            annotataion.title = @"gj";
            annotataion.subtitle = model.stationId;
            [_mapView addAnnotation:annotataion];
            [stationError addObject:annotataion];
        }
        
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"zc"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
            for (FSJResultList *tempmodel in stationArr) {
                if ([tempmodel.stationId isEqualToString:annotation.subtitle]){
                    UIButton * Cusbutton = [UIButton buttonWithType:UIButtonTypeCustom];
                    Cusbutton.frame = CGRectMake(0, 0, 70, 40);
                    Cusbutton.backgroundColor = SystemBlueColor;
                    Cusbutton.titleLabel.font = [UIFont systemFontOfSize:10];
                    [Cusbutton setTitle:tempmodel.name forState:UIControlStateNormal];
                    annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:Cusbutton];}
            }
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPfashezhan"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"gj"]) {
        NSString *AnnotationViewID2 = @"AnimatedAnnotation2";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID2];
            annotationView.canShowCallout = NO;
            for (FSJResultList *tempmodel in stationArr) {
                if ([tempmodel.stationId isEqualToString:annotation.subtitle]){
                    UIButton * Cusbutton = [UIButton buttonWithType:UIButtonTypeCustom];
                    Cusbutton.frame = CGRectMake(0, 0, 70, 40);
                    Cusbutton.backgroundColor = SystemBlueColor;
                    Cusbutton.titleLabel.font = [UIFont systemFontOfSize:10];
                    [Cusbutton setTitle:tempmodel.name forState:UIControlStateNormal];
                    annotationView.paopaoView = [[BMKActionPaopaoView alloc]initWithCustomView:Cusbutton];}
            }
        }
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 0; i < 4; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPfashezhan%d",i]];
            [images addObject:image];
        }
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"0"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPgreen"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"1"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPred"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"2"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPyellow"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"3"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"APPhui"]];
        [images addObject:image];
        annotationView.annotationImages = images;
        return annotationView;
    }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    //[self getallstationInfoWith:view.annotation.title];
    
    NSString *lat = [NSString stringWithFormat:@"%lf",view.annotation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%lf",view.annotation.coordinate.longitude];
    NSLog(@"annotion == %@ %@",[lon substringToIndex:8],[lat substringToIndex:7]);
    for (FSJOneFSJ *tempmodel in allsite) {
        if ([tempmodel.transId isEqualToString:view.annotation.subtitle]) {
            NSLog(@"全局标注 == %@ %@",[tempmodel.lon substringToIndex:8],[tempmodel.lat substringToIndex:7]);
            FSJPeopleManagerDetailViewController *detail = [[FSJPeopleManagerDetailViewController alloc]init];
            detail.DetailInfoType = FSJManageDetail;
            detail.managerID = tempmodel.transId;
            [self.navigationController pushViewController:detail animated:YES];
            //return;
        }
    }
    
    for (FSJResultList *tempmodel in stationArr) {
        
        if ([tempmodel.stationId isEqualToString:view.annotation.subtitle]) {
            //if ([[tempmodel.lon substringToIndex:8] isEqualToString:[lon substringToIndex:8]] || [[tempmodel.lat substringToIndex:7] isEqualToString:[lat substringToIndex:7]]) {
            NSLog(@"标注 == %@ %@",[tempmodel.lon substringToIndex:8],[tempmodel.lat substringToIndex:7]);
            [self getallstationInfoWith:tempmodel.stationId andtype:Allstationquery anddicparameter:@"sid"andShowAnno:NO];
            tableViewTitle = tempmodel.name;
        }
    }
}
#pragma mark -- 查看发射机下面的所有发射机信息
- (void)getallstationInfoWith:(NSString *)ID andtype:(NetworkConnectionActionType)type anddicparameter:(NSString *)str andShowAnno:(BOOL)show {
    
    if (allsite.count >0) {
        [allsite removeAllObjects];
    }
    if (self.mytableView) {
        self.mytableView.frame = CGRectZero;
        [self.mytableView removeFromSuperview];
    }
    THWeakSelf(weakself);
    if (!show) {
        [weakself createTableview];
    }
    
    //[LGProgressHud showLoadingHud:self.mytableView withText:@"" textPosition:TextPositionTypeBottle animated:HudAnimatedTypeTop];
    
    NSDictionary *dic = @{str:ID,@"pageSize":@"8",@"pageNo":@"1",@"jwt":staticJwt};
    [FSJNetWorking networkingGETWithActionType:type requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        FSJAllFSJ *model = [FSJAllFSJ initWithDictionary:responseObject];
        NSLog(@"%@",model.message);
        if ([model.status isEqualToString:@"200"]) {
           
            for (NSDictionary *dic in model.list) {
                FSJOneFSJ *model = [FSJOneFSJ initWithDictionary:dic];
                NSLog(@"%@ %@ %@ statue ==%@",model.name ,model.masterPr, model.masterPo, model.status);
                [allsite addObject:model];
                }
            
            if (show) {
                [self addAnnotataionOnmapWith:allsite];
            }
            else{
                 //dispatch_async(dispatch_get_main_queue(), ^{
                  [self.mytableView reloadData];
                 //});
                 //[LGProgressHud hideAllHudInView:self.mytableView animated:HudAnimatedTypeNone];
            }

        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
        NSLog(@"%@",error);
    }];
}
#pragma mark -- 添加全局标注
- (void)addAnnotataionOnmapWith:(NSArray *)array{
    NSLog(@"全局标注数量为%lu",(unsigned long)array.count);
    for (FSJOneFSJ *model in array) {
        BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = model.lat.floatValue;
        coor.longitude = model.lon.floatValue;
        annotataion.coordinate = coor;
        annotataion.title = model.status;
        annotataion.subtitle = model.transId;
        [_mapView addAnnotation:annotataion];
        [quanjuArr addObject:annotataion];
        NSLog(@"%@",model.name);
    }
}
#pragma mark -- 配置Tableview
- (UITableView *)mytableView{
    if (_mytableView == nil) {
        _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, tableviewY, WIDTH, tableviewHeight) style:UITableViewStyleGrouped];
        _mytableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_mytableView registerNib:[UINib nibWithNibName:@"FSJOneFSJTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"CELL"];
        _mytableView.allowsSelection =YES;
        _mytableView.delegate = self;
        _mytableView.dataSource = self;
        
    }
    return _mytableView;
}
- (void)createTableview{
    if (self.mytableView) {
        [self.mytableView removeFromSuperview];
    }
    self.mytableView.frame = CGRectMake(0, tableviewY, WIDTH, tableviewHeight);
    self.mytableView.scrollEnabled = NO;
    [_mapView insertSubview:self.mytableView belowSubview:tabbarBg];
    // [self.view insertSubview:self.mytableView belowSubview:maskview];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return  2;
    }
    else{
        return 0.1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 50;
    }
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    
    switch (sectionIndex) {
        case 0:
            return 1;
            break;
        case 1:
            return allsite.count;
            
            break;
        default:
            return 0;
            break;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HEADER"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HEADER"];
        }
         cell.backgroundColor = SystemBlueColor;
         cell.textLabel.text = [NSString stringWithFormat:@"%@",tableViewTitle];
         cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor =SystemWhiteColor;
        return cell;
    }
    else{
        static NSString *identifer = @"CELL";
        FSJOneFSJTableViewCell *cell = [self.mytableView dequeueReusableCellWithIdentifier:identifer];
        FSJOneFSJ *model = allsite[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.topLabel.text = model.name;
        cell.rusheValue.text = model.masterPo;
        cell.rusheValue.textColor = SystemGreenColor;
        cell.fansheValue.text = model.masterPr;
        cell.fansheValue.textColor = SystemGreenColor;
        cell.fsjImg.contentMode = UIViewContentModeScaleAspectFit;
        [cell.fsjImg sizeToFit];
        switch ([model.status integerValue]) {
            case 0:
                cell.fsjImg.image = [UIImage imageNamed:@"APPgreen"];
                break;
            case 1:
                cell.fsjImg.image = [UIImage imageNamed:@"APPred"];
                break;
            case 2:
                cell.fsjImg.image = [UIImage imageNamed:@"APPyellow"];
                break;
            case 3:
                cell.fsjImg.image = [UIImage imageNamed:@"APPhui"];
                break;
            default:
                break;
        }
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"1");
    if (indexPath.section == 0) {
        [UIView animateWithDuration:1 animations:^{
            CGRect rect = self.mytableView.frame;
            if (rect.origin.y ==  HEIGH-50) {
                rect.origin.y -= moveDistance-50;
                rect.size.height += tableviewHeight-50;
            }
            else{
                rect.origin.y = HEIGH-50;
                rect.size.height = 50;
            }
            self.mytableView.frame = rect;
        }];
    }
    else{
        FSJOneFSJ *model = allsite[indexPath.row];
        FSJPeopleManagerDetailViewController *detail = [[FSJPeopleManagerDetailViewController alloc]init];
        detail.DetailInfoType = FSJManageDetail;
        detail.managerID = model.transId;
        [self.navigationController pushViewController:detail animated:YES];
    }
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 导航
- (void)UserInfo:(UIButton *)sender {
    
       FSJMeViewController *me = [[FSJMeViewController alloc]init];
        me.jwtStr = staticJwt;
        [self.navigationController pushViewController:me animated:YES];
    // [self changeStatusWith:@[@"1/11/12/10001",@"0"]];
    NSLog(@"状态改变1");
}
//- (IBAction)MoreButton:(UIButton *)sender {
//    FSJMoreInfomationViewController *more = [[FSJMoreInfomationViewController alloc]init];
//     [self.navigationController pushViewController:more animated:YES];
//    [self changeStatusWith:@[@"1/11/12/10000",@"0"]];
//    [self changeStatusWith:@[@"1/2/3/10004",@"1"]];
//    NSLog(@"状态改变0");
//}
#pragma mark - 添加自定义的手势（若不自定义手势，不需要下面的代码）
- (void)addCustomGestures {
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.delegate = self;
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.cancelsTouchesInView = NO;
    doubleTap.delaysTouchesEnded = NO;
    doubleTap.delegate = self;
    [self.view addGestureRecognizer:doubleTap];
    /*
     *注意：
     *添加自定义手势时，必须设置UIGestureRecognizer的属性cancelsTouchesInView 和 delaysTouchesEnded 为NO,
     *否则影响地图内部的手势处理
     */
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    //singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    singleTap.delaysTouchesEnded = NO;
    //[singleTap requireGestureRecognizerToFail:doubleTap];
    [_mapView addGestureRecognizer:singleTap];
    UISwipeGestureRecognizer *swipdown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeTableview:)];
    [swipdown setDirection:UISwipeGestureRecognizerDirectionDown];
    UISwipeGestureRecognizer *swipup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(addTableview:)];
    [swipup setDirection:UISwipeGestureRecognizerDirectionUp];
    swipup.delegate   = self;
    swipdown.delegate = self;
    [self.view addGestureRecognizer:swipup];
    [self.mytableView addGestureRecognizer:swipup];
    [self.view addGestureRecognizer:swipdown];
    [self.mytableView addGestureRecognizer:swipdown];
}
- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    NSLog(@"my handleSingleTap");
    [maskview removeFromSuperview];
//    [UIView animateWithDuration:1 animations:^{
//        CGRect rect = self.mytableView.frame;
//        if (rect.origin.y == HEIGH-50) {
//            return;
//        }
//        else{
//            rect.origin.y = HEIGH-50;
//            rect.size.height = 50;
//        }
//        self.mytableView.frame = rect;
//    }];
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    NSLog(@"my handleDoubleTap");
     [maskview removeFromSuperview];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)addTableview:(UISwipeGestureRecognizer *)swip{
    if (self.mytableView.frame.origin.y == 0  ) {
        return;
    }
    else{
        if (self.mytableView != nil) {
            [UIView animateWithDuration:0.6 animations:^{
                CGRect rect = self.mytableView.frame;
                if (rect.origin.y == tableviewY ) {
                    rect.origin.y    = 0;
                    rect.size.height = HEIGH - HEIGH *0.07 ;
                }
                else{
                    rect.origin.y    = tableviewY;
                    rect.size.height = tableviewHeight;
                }
                self.mytableView.frame = rect;
            }];
        }
    }
    NSLog(@"up");
}
- (void)removeTableview:(UISwipeGestureRecognizer *)swip{
    NSLog(@"down");
    if (self.mytableView.frame.origin.y == HEIGH - HEIGH*0.08 - 50) {
        return;
    }
    else{
        if (self.mytableView) {
            [UIView animateWithDuration:1 animations:^{
                CGRect rect = self.mytableView.frame;
                if (rect.origin.y == tableviewY ) {
                    rect.origin.y    = HEIGH - HEIGH*0.07 - 70;
                    rect.size.height = HEIGH- tableviewY;
                }
                else{
                    rect.origin.y    = tableviewY;
                    rect.size.height = tableviewHeight;
                }
                self.mytableView.frame = rect;
            }];
        }
    }
}
@end
