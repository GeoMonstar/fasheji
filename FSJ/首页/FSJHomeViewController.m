//
//  FSJHomeViewController.m
//  FSJ
//
//  Created by Monstar on 16/3/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//
#import "FSJHomeViewController.h"
#import "MyAnimatedAnnotationView.h"
#import "FSJMeViewController.h"
#import "FSJAllFSJ.h"
#import "FSJOneFSJ.h"
#import "FSJOneFSJTableViewCell.h"
#import "FSJMoreInfomationViewController.h"
#import "FSJPeopleManagerDetailViewController.h"
#import "FSJOneCity.h"
#define tableviewHeight self.view.bounds.size.height/2
@interface FSJHomeViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKDistrictSearchDelegate,BMKGeoCodeSearchDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate>
{
    UINavigationController *nav;
    BMKLocationService* locService;
    NSMutableArray    *listNormal;
    NSMutableArray    *listError;
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
    
    BMKDistrictSearch *_NormalSearch;
    BMKDistrictSearch *_ErrorSearch;
    BMKPolyline       *normalArea;
    BMKPolygon        *errorArea;
    BMKGeoCodeSearch* _geocodesearch;
    BMKGeoCodeSearch* _geocodesearchCity;
    
    NSString * staticJwt;
    NSString * staticareaType;
    NSString * staticareaId;
    NSString * staticuserId;
    NSString * statitopic;
    NSInteger *sizeNo;
    NSInteger *pageNo;
    NSInteger *warnNumber;
    BOOL showWarn;
    BOOL showCity;
    BOOL showProvince;
    BOOL districtSearch;
    BOOL full;
    
    UIColor* WarnStokeColor;
    UIColor* WarnFillColor;
    UIColor* NorStokeColor;
    UIColor* NorFillColor;
    
    
}
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (nonatomic, strong)NSMutableArray *allsite;
@property (nonatomic, strong)UITableView *mytableView;
@property (weak, nonatomic) IBOutlet UISearchBar *mainSearchbar;
@property (weak, nonatomic) IBOutlet UITextField *SearchTF;
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@property (weak, nonatomic) IBOutlet UIView *BackgroundVIew;
#define FirstLevel  7.0f
#define SecondLevel 9.0f
#define ThirdtLevel 11.0f
#define ForthLevel  14.5f
@end
@implementation FSJHomeViewController
#pragma mark -- 懒加载
- (NSMutableArray *)allsite{
    if (_allsite == nil) {
        _allsite = @[].mutableCopy;
    }
    return _allsite;
}
#pragma mark -- 视图周期
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [_mapView viewWillAppear];
    
    self.navigationController.navigationBar.hidden = YES;
    self.mapView.delegate = self;// 此处记得不用的时候需要置nil，否则影响内存的释放
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
    [super viewWillDisappear:YES];
    [_mapView viewWillDisappear];
    self.mapView.delegate = nil; // 不用时，置nil
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
    WarnStokeColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
    NorStokeColor  = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
    WarnFillColor  = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.1];
    NorFillColor   = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.1];
    sizeNo = 0;
    pageNo = 0;
    warnNumber = 0;
    cityoverlayErr = @[].mutableCopy;
    cityoverlayNor = @[].mutableCopy;
    cityError      = @[].mutableCopy;
    cityNormal     = @[].mutableCopy;
    cityidError      = @[].mutableCopy;
    cityidNormal     = @[].mutableCopy;
    allcityName    = @[].mutableCopy;
    allcityModel   = @[].mutableCopy;
    quanjuArr      = @[].mutableCopy;
    nameIdDic      = @[].mutableCopy;
    listNormal     = @[].mutableCopy;
    listError      = @[].mutableCopy;
    listidError    = @[].mutableCopy;
    stationArr     = @[].mutableCopy;
    stationNormal  = @[].mutableCopy;
    stationError   = @[].mutableCopy;
    overlayEor     = @[].mutableCopy;
    overlayNor     = @[].mutableCopy;
    _mapView.zoomLevel          = 6;
    _mapView.minZoomLevel       = 6;
    _mapView.gesturesEnabled    = YES;
    _mapView.zoomEnabledWithTap = YES;
    _mapView.zoomEnabled        = YES;
    _geocodesearch = [[BMKGeoCodeSearch alloc]init];
    _geocodesearchCity = [[BMKGeoCodeSearch alloc]init];
    staticJwt      = [[EGOCache globalCache]stringForKey:@"jwt"];
    staticareaType = [[EGOCache globalCache]stringForKey:@"areaType"];
    staticareaId   = [[EGOCache globalCache]stringForKey:@"areaId"];
    staticuserId   = [[EGOCache globalCache]stringForKey:@"userId"];
    statitopic     = [NSString stringWithFormat:@"%@/#",[[EGOCache globalCache]stringForKey:@"topic"]];
    
    NSDictionary *dic = @{@"areaId":staticareaId,@"areaType":staticareaType,@"userId":staticuserId,@"jwt":staticJwt};
    [self searchWithModelwith:dic];
    self.BackgroundVIew.layer.cornerRadius = 3;
    self.BackgroundVIew.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.BackgroundVIew.layer.shadowOffset =  CGSizeMake(5.0f, 5.0f);
    self.BackgroundVIew.layer.shadowOpacity = 1.0f;
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    [self customUI];
    [self addCustomGestures];//添加自定义的手势
}
#pragma mark -- 警告通知
- (void)receiveWarnNoti{
    [MPush registerForClientId:@"ios0330" withAppName:@"fsj"];
    [MPush setConnectCallback:^(int code) {
        [MPush subscribeForArea:statitopic];
    }];
    [MPush setMessageCallback:^(NSString *mes) {
    //[[NSNotificationCenter defaultCenter]postNotificationName:@"Warn" object:nil userInfo:@{@"message":mes }];
        [self changeStatusWith:mes];
        //[self scheduleLocalNotificationWith:mes];
        NSLog(@"警告消息===========%@",mes);
    }];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus:) name:@"Warn" object:nil];
}
- (void)changeStatusWith:(NSString *)jsonString{
        NSData  *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *error;
        NSDictionary *resultsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        NSString *contentStr = resultsDic[@"content"];
        NSString *statusStr  = resultsDic[@"status"];
        NSArray  *arr = [contentStr componentsSeparatedByString:@"/"];
        //{"content":"1/11/12/10000","status":"0"}
    if ([statusStr isEqualToString:@"0"]) {
        for (BMKPointAnnotation *annoatation in stationError) {
            if ([annoatation.subtitle isEqualToString:arr.lastObject]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeAnnotation:annoatation];
                    annoatation.title = @"0";
                    [_mapView addAnnotation:annoatation];
                });
                [stationError removeObject:annoatation];
                [stationNormal addObject:annoatation];
            }
        }
    }
    if (stationError.count == 0) {
            for (BMKPolygon * polygon in cityoverlayErr) {
                if ([polygon.subtitle isEqualToString:arr[2]]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeOverlay:polygon];
                    polygon.title = @"0";
                    [_mapView addOverlay:polygon];
                });
                    [cityoverlayErr removeObject:polygon];
                    [cityoverlayNor addObject:polygon];
             }
        }
    }
    if (cityoverlayErr.count == 0) {
        for (BMKPolygon * polygon in overlayEor) {
            if ([polygon.subtitle isEqualToString:arr[1]]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView removeOverlay:polygon];
                    polygon.title = @"0";
                    [_mapView addOverlay:polygon];
                });
                [overlayEor removeObject:polygon];
                [overlayNor addObject:polygon];
            }
        }
    }    
}
- (void)scheduleLocalNotificationWith:(NSString *)mes{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSLog(@"fireDate=%@",fireDate);
    notification.fireDate = fireDate;
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.repeatInterval = kCFCalendarUnitSecond;
    notification.alertBody =  @"发射机实时告警";
    notification.applicationIconBadgeNumber = 1;
    notification.soundName = UILocalNotificationDefaultSoundName;
    NSDictionary *userDict = [NSDictionary dictionaryWithObject:mes forKey:@"key"];
    notification.userInfo = userDict;
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType type =  UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:type
                                                                                 categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        notification.repeatInterval = NSCalendarUnitDay;
    } else {
        notification.repeatInterval = NSDayCalendarUnit;
    }
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
- (void)viewDidUnload {
    [super viewDidUnload];
}
#pragma mark -- 控件和事件
- (void)customUI{
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreBtn setBackgroundColor:SystemBlueColor];
    self.moreBtn.layer.cornerRadius = 25;
    self.moreBtn.layer.masksToBounds = YES;
    self.mainSearchbar.placeholder = @"查找设备名称、IP地址";
    self.mainSearchbar.delegate = self;
    self.mainSearchbar.backgroundColor = SystemWhiteColor;
    self.mainSearchbar.searchBarStyle =UISearchBarStyleDefault;
    self.mainSearchbar.barTintColor = SystemWhiteColor;
    self.mainSearchbar.layer.borderColor = SystemWhiteColor.CGColor;
    self.mainSearchbar.layer.borderWidth = 2;
    self.mainSearchbar.barStyle =UIBarStyleDefault;
    self.mainSearchbar.showsCancelButton = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar;{
    [self.mytableView removeFromSuperview];
    showWarn = NO;
    [_mapView removeAnnotations:stationError];
    [_mapView removeAnnotations:stationNormal];
    if ([self.mainSearchbar.text isEqualToString:@""]) {
        [SVProgressHUD showErrorWithStatus:@"请输入查询内容"];
        return;
    }
    else{
        [self startKeywordsquery];
    }
     [self.view endEditing:YES];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    showWarn = YES;
    [_mapView addAnnotations:stationNormal];
    [_mapView addAnnotations:stationError];
    [_mapView removeAnnotations:quanjuArr];
    [self.view endEditing:YES];
}
- (void)startKeywordsquery{
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeGradient];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
    [self getallstationInfoWith:self.mainSearchbar.text andtype:Allstationquery anddicparameter:@"keyword"andShowAnno:YES];
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
            if ([listmodel.status isEqualToString:@"0"]) {
                [listNormal addObject:listmodel.name];
                NSLog(@"正常 == %@",listmodel.name);
            }
            else{
                [listError addObject:listmodel.name];
                [listidError addObject:listmodel.areaId];
                NSLog(@"警告 == %@",listmodel.name);
            }
        }
           // dispatch_async(dispatch_get_main_queue(), ^{
                if ([self getsearchWithArr:listError]) {
                }
                else{
                    [self getsearchWithArr:listError];
                }
            //});
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
- (BOOL)getsearchWithArr:(NSMutableArray *)array{
    for (int i = 0 ; i < array.count; i ++) {
        BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
        option.city = array[i];
        BMKDistrictSearch *search = [[BMKDistrictSearch alloc]init];
        search.delegate = self;
        [searchList addObject:search];
        districtSearch = [search districtSearch:option];
        // BOOL districtSearch;
        if (districtSearch) {
            NSLog(@"district检索发送成功");
            
        } else  {
            NSLog(@"district检索发送失败");
            break;
        }
    }
    return districtSearch;
}
- (void)searchWithArr:(NSMutableArray *)array{
    for (int i = 0 ; i < array.count; i ++) {
        BMKDistrictSearchOption *option = [[BMKDistrictSearchOption alloc] init];
        option.city = array[i];
        BMKDistrictSearch *search = [[BMKDistrictSearch alloc]init];
        search.delegate = self;
        [searchList addObject:search];
        districtSearch = [search districtSearch:option];
       // BOOL districtSearch;
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
        NSLog(@"\nname:%@\n areaId:%d 中心点 纬度:%lf,经度:%lf 节点数目 = %ld", result.name, (int)result.code, result.center.latitude, result.center.longitude,result.pointsCount);
       
        [overlayEor     addObjectsFromArray:[self createPolgonWith:listError andId:listidError and:result and:@"1" and:YES]];
        [cityoverlayErr addObjectsFromArray:[self createPolgonWith:cityError andId:cityidError and:result and:@"1" and:NO]];
        [cityoverlayNor addObjectsFromArray:[self createPolgonWith:cityNormal andId:cityidNormal and:result and:@"0" and:NO]];
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
            if (bol == YES) {
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
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"BMKMapView控件初始化完成" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
    //[alert show];
    alert = nil;
    _mapView.compassPosition = CGPointMake(15, 90);
}
- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    NSLog(@"地图缩放等级 == %lf",_mapView.zoomLevel);
    if (_mapView.zoomLevel >=SecondLevel ) {
        showProvince = NO;
        [_mapView removeOverlays:overlayNor];
        [_mapView removeOverlays:overlayEor];
        if (showCity == YES) {
            [_mapView addOverlays:cityoverlayNor];
            [_mapView addOverlays:cityoverlayErr];
            showCity = NO;
        }
        if ( _mapView.zoomLevel > ThirdtLevel) {
             self.mytableView.hidden = NO;
            showCity =YES;
            [_mapView removeOverlays:cityoverlayNor];
            [_mapView removeOverlays:cityoverlayErr];
            if (showWarn == YES) {
                [_mapView addAnnotations:stationNormal];
                [_mapView addAnnotations:stationError];
                //showWarn = NO;
            }
        }
        else{
            self.mytableView.hidden = YES;
            //[_mapView addOverlays:cityoverlayNor];
           // [_mapView addOverlays:cityoverlayErr];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_mapView removeAnnotations:stationError];
                [_mapView removeAnnotations:stationNormal];
            });
        }
    }
    else{
         showCity = YES;
        [_mapView removeAnnotations:stationError];
        [_mapView removeAnnotations:stationNormal];
        [_mapView removeOverlays:cityoverlayErr];
        [_mapView removeOverlays:cityoverlayNor];
        if (!showProvince) {
            [_mapView addOverlays:overlayEor];
            [_mapView addOverlays:overlayNor];
            showProvince = YES;
        }
    }
}
- (void)mapView:(BMKMapView *)mapView onClickedMapBlank:(CLLocationCoordinate2D)coordinate{
    //NSLog(@"经度 = %f,纬度 = %f",coordinate.latitude,coordinate.longitude);
    if (_mapView.zoomLevel <= FirstLevel) {
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
- (void)mapview:(BMKMapView *)mapView onDoubleClick:(CLLocationCoordinate2D)coordinate {
    if (_mapView.zoomLevel <= FirstLevel) {
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
#pragma mark -- 反向地理编码 获得点击地区坐标
- (void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (searcher == _geocodesearchCity){
        if (error == 0) {
            NSLog(@"%@",result.address);
            for (NSString *str in allcityName) {
                if ([result.address containsString:str]) {
                  //  _mapView.centerCoordinate = result.location;
                    NSLog(@"%@",str);
                    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
                    geocodeSearchOption.address = str;
                    BOOL flag = [_geocodesearchCity geoCode:geocodeSearchOption];
                    if(flag)
                    {
                        NSLog(@"geocity检索发送成功");
                        showWarn = YES;
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
        for (NSString *str in listError) {
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
#pragma mark -- 正向地理编码 获得发射站数据
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //清楚标注记录
    if (stationArr.count >0 || stationError.count>0 || stationNormal.count>0 || cityoverlayErr.count || cityoverlayNor.count > 0 || cityError.count > 0 || cityNormal.count > 0) {
        [stationArr     removeAllObjects];
        [stationError   removeAllObjects];
        [stationNormal  removeAllObjects];
      //[cityoverlayNor removeAllObjects];
      //[cityoverlayErr removeAllObjects];
        [cityNormal     removeAllObjects];
        [cityError      removeAllObjects];
    }
    if (searcher == _geocodesearch) {
    for (FSJResultList *tempModle in nameIdDic) {
        if ([tempModle.name isEqualToString:result.address]) {
        NSDictionary *requestdic = @{@"areaId":tempModle.areaId,@"areaType":@"2",@"userId":staticuserId,@"jwt":staticJwt};
        [FSJNetWorking networkingGETWithActionType:AreaalarmStatus requestDictionary:requestdic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                FSJUserInfo *model = [FSJUserInfo initWithDictionary:responseObject];
                if ([model.status isEqualToString:@"200"]) {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        _mapView.zoomLevel = SecondLevel;
                    });
                    showCity = YES;
                    for (NSDictionary *dic in model.list) {
                        FSJOneCity *cityModel = [FSJOneCity initWithDictionary:dic];
                        [allcityName addObject:cityModel.name];
                        [allcityModel addObject:cityModel];
                        if ([cityModel.status isEqualToString:@"1"]) {
                            [cityError   addObject:cityModel.name];
                            [cityidError addObject:cityModel.areaId];
                            
                        }
                        else{
                            [cityNormal   addObject:cityModel.name];
                            [cityidNormal addObject:cityModel.areaId];
                        }
                    }
                    //dispatch_async(dispatch_get_main_queue(), ^{
                    [self searchWithArr:cityNormal];
                    [self searchWithArr:cityError];
                    // });
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",error]];
            }];
        }
    }
}
    if (searcher == _geocodesearchCity) {
        for (FSJOneCity *cityModel in allcityModel) {
            if ([cityModel.name isEqualToString:result.address]) {
        NSDictionary *requestdic = @{@"areaId":cityModel.areaId,@"areaType":@"3",@"userId":staticuserId,@"jwt":staticJwt};
            [FSJNetWorking networkingGETWithActionType:AreaalarmStatus requestDictionary:requestdic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
                if (responseObject) {
                   FSJUserInfo *user = [FSJUserInfo initWithDictionary:responseObject];
                    //获取警告数量
                    // warnNumber = (int)[user.alarmTotal integerValue];
                    
                   if ([user.status isEqualToString:@"200"]) {
                       for (NSDictionary *dic in user.list) {
                        FSJResultList *listmodel = [FSJResultList initWithDictionary:dic];
                           [stationArr addObject:listmodel];
                           //获取警告数量
                           warnNumber += (int)[listmodel.alarmSize integerValue];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            _mapView.zoomLevel = ForthLevel;
                        });
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
        }
    }
    NSLog(@"address = %@, 坐标 = %lf %lf",result.address,result.location.longitude,result.location.latitude);
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
            annotataion.title = @"正常";
            _mapView.centerCoordinate = coor;
            annotataion.subtitle = model.stationId;
            [stationNormal addObject:annotataion];
        }
        if([model.status isEqualToString:@"1"]){
            BMKPointAnnotation *annotataion = [[BMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = model.lat.floatValue;
            coor.longitude = model.lon.floatValue;
            annotataion.coordinate = coor;
            annotataion.subtitle = model.stationId;
            _mapView.centerCoordinate = coor;
            annotataion.title = @"警告";
            annotataion.subtitle = model.stationId;
            [stationError addObject:annotataion];
        }
    }
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation.title isEqualToString:@"警告"]) {
        NSString *AnnotationViewID2 = @"AnimatedAnnotation2";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID2];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        for (int i = 1; i <= 3; i++) {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fasheji%d",i]];
            [images addObject:image];
        }
        annotationView.annotationImages = images;
        return annotationView;
    }
    if ([annotation.title isEqualToString:@"正常"]) {
        NSString *AnnotationViewID1 = @"AnimatedAnnotation1";
        MyAnimatedAnnotationView *annotationView = nil;
        if (annotationView == nil) {
            annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID1];
            annotationView.canShowCallout = NO;
        }
        NSMutableArray *images = [NSMutableArray array];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fasheji"]];
        [images addObject:image];
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
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"green"]];
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
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"red"]];
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
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"orenge"]];
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
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"hui"]];
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
    for (FSJOneFSJ *tempmodel in self.allsite) {
        
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
//        if ([[tempmodel.lon substringToIndex:8] isEqualToString:[lon substringToIndex:8]] || [[tempmodel.lat substringToIndex:7] isEqualToString:[lat substringToIndex:7]]) {
              NSLog(@"标注 == %@ %@",[tempmodel.lon substringToIndex:8],[tempmodel.lat substringToIndex:7]);
                [self getallstationInfoWith:tempmodel.stationId andtype:Allstationquery anddicparameter:@"sid"andShowAnno:NO];
            
            
        }
    }
}
#pragma mark -- 查看发射机下面的所有发射机信息
- (void)getallstationInfoWith:(NSString *)ID andtype:(NetworkConnectionActionType)type anddicparameter:(NSString *)str andShowAnno:(BOOL)show{
    if (self.allsite.count >0) {
        [self.allsite removeAllObjects];
    }
    [SVProgressHUD showWithStatus:@"数据加载中" maskType:SVProgressHUDMaskTypeGradient];
    NSDictionary *dic = @{str:ID,@"pageSize":@"8",@"pageNo":@"1",@"jwt":staticJwt};
    [FSJNetWorking networkingGETWithActionType:type requestDictionary:dic success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
        FSJAllFSJ *model = [FSJAllFSJ initWithDictionary:responseObject];
        NSLog(@"%@",model.message);
        [SVProgressHUD dismiss];
        if ([model.status isEqualToString:@"200"]) {
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *dic in model.list) {
                FSJOneFSJ *model = [FSJOneFSJ initWithDictionary:dic];
                
                NSLog(@"%@ %@ %@ statue ==%@",model.name ,model.masterPr, model.masterPo, model.status);
                
               [tempArray addObject:model];
                [self.allsite addObjectsFromArray:tempArray];
                if (show) {
                    [self addAnnotataionOnmapWith:self.allsite];
                   
                }
                else
                dispatch_async(dispatch_get_main_queue(), ^{
                        [self.mytableView reloadData];
                });
                 [self createTableview];
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
        _mytableView = [[UITableView alloc]initWithFrame:CGRectMake(0, HEIGH/3*2, WIDTH, HEIGH/3) style:UITableViewStyleGrouped];
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
    
    self.mytableView.frame = CGRectMake(0, HEIGH/3*2, WIDTH, HEIGH/3);
    //self.mytableView.scrollEnabled = NO;
    [self.view addSubview:self.mytableView];
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
            return self.allsite.count;
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
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"HEADER"];
        }
        cell.backgroundColor = SystemLightGrayColor;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.text = [NSString stringWithFormat:@"共搜索到%ld条结果",self.allsite.count];
        return cell;
    }
    else{
        
    static NSString *identifer = @"CELL";
    FSJOneFSJTableViewCell *cell = [self.mytableView dequeueReusableCellWithIdentifier:identifer];
        FSJOneFSJ *model = self.allsite[indexPath.row];
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
            cell.fsjImg.image = [UIImage imageNamed:@"green"];
            break;
        case 1:
            cell.fsjImg.image = [UIImage imageNamed:@"red"];
            break;
        case 2:
            cell.fsjImg.image = [UIImage imageNamed:@"orenge"];
            break;
        case 3:
            cell.fsjImg.image = [UIImage imageNamed:@"hui"];
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
        return;
    }
    else{
    FSJOneFSJ *model = self.allsite[indexPath.row];
    FSJPeopleManagerDetailViewController *detail = [[FSJPeopleManagerDetailViewController alloc]init];
    detail.DetailInfoType = FSJManageDetail;
    detail.managerID = model.transId;
    [self.navigationController pushViewController:detail animated:YES];
    }
    //取消选中效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -- 导航
- (IBAction)UserInfo:(UIButton *)sender {
    FSJMeViewController *me = [[FSJMeViewController alloc]init];
    me.jwtStr = staticJwt;
    [self.navigationController pushViewController:me animated:YES];
}
- (IBAction)MoreButton:(UIButton *)sender {
     FSJMoreInfomationViewController *more = [[FSJMoreInfomationViewController alloc]init];
     [self.navigationController pushViewController:more animated:YES];
}
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
     [self.view addGestureRecognizer:singleTap];
    
    UISwipeGestureRecognizer *swipdown = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(removeTableview:)];
    [swipdown setDirection:UISwipeGestureRecognizerDirectionDown];
    UISwipeGestureRecognizer *swipup = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(addTableview:)];
    [swipup setDirection:UISwipeGestureRecognizerDirectionUp];
    swipup.delegate   = self;
    swipdown.delegate = self;
    [self.view addGestureRecognizer:swipup];
    [self.view addGestureRecognizer:swipdown];
}
- (void)addTableview:(UISwipeGestureRecognizer *)swip{
    NSLog(@"up");
   if (self.mytableView != nil) {
        [UIView animateWithDuration:0.6 animations:^{
            self.mytableView.frame = CGRectMake(0, HEIGH/3*2, WIDTH, HEIGH/3);
        }];
    }
}
- (void)removeTableview:(UISwipeGestureRecognizer *)swip{
    NSLog(@"down");
    if (self.mytableView) {
        [UIView animateWithDuration:1 animations:^{
            self.mytableView.frame = CGRectMake(0, HEIGH, WIDTH, 0);
        }];
    }
}
- (void)handleSingleTap:(UITapGestureRecognizer *)theSingleTap {
    NSLog(@"my handleSingleTap");
}
- (void)handleDoubleTap:(UITapGestureRecognizer *)theDoubleTap {
    NSLog(@"my handleDoubleTap");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
//- (void)addTableview:(UISwipeGestureRecognizer *)swip{
//    if (self.mytableView.frame.origin.y == 0) {
//        return;
//     }
//     else{
//    if (self.mytableView != nil) {
//        [UIView animateWithDuration:0.6 animations:^{
//            //[self.view addSubview:self.mytableView];
//            CGRect rect = self.mytableView.frame;
//            rect.origin.y -= HEIGH/2;
//            rect.size.height += HEIGH/2;
//            self.mytableView.frame = rect;
//        }];
//     }
//  }
//    NSLog(@"up");
//}
//- (void)removeTableview:(UISwipeGestureRecognizer *)swip{
//    NSLog(@"down");
//
//     if (self.mytableView.frame.origin.y == HEIGH) {
//        return;
//      }
//      else{
//    if (self.mytableView) {
//        [UIView animateWithDuration:1 animations:^{
//            CGRect rect = self.mytableView.frame;
//            rect.origin.y += HEIGH/2;
//            rect.size.height -= HEIGH/2;
//            self.mytableView.frame = rect;
//        }];
//     }
//  }
//}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[UITableView class]]){
        NSLog(@"111");
        
        return NO;
        
    }
    
    return YES;
    
}
@end
