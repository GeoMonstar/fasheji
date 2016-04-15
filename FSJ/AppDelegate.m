//
//  AppDelegate.m
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//
#import "AppDelegate.h"
#import "FSJLogInViewController.h"
#import "FSJHomeViewController.h"
#import "FSJTabbarViewController.h"
#import "FSJMapViewController.h"
#import "MPush.h"
#import "mopush.h"
#define BaiduMapKEy @"LuciFxMX26SzSnd3zEZEfb8R"
//#define BaiduMapKEy @"G4u27joqchFtv5iVTn5KPwXp"
@interface AppDelegate ()<BMKGeneralDelegate>{
    BMKMapManager * _mapManager;
}
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[EGOCache globalCache]clearCache];
    NSString *str = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"%@",str);
        _mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [_mapManager start:BaiduMapKEy generalDelegate:self];
        if (!ret) {
            NSLog(@"启动失败");
    }
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BOOL bo = [[EGOCache globalCache]objectForKey:@"Login"];
    if (bo) {
//        FSJTabbarViewController *vc = [[FSJTabbarViewController alloc]init];
//        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
//        self.window.rootViewController = nav;
        FSJMapViewController *vc = [[FSJMapViewController alloc]init];
        self.window.rootViewController = vc;
    }
    else{
        //FSJMapViewController *vc = [[FSJMapViewController alloc]init];
        FSJLogInViewController *vc = [[FSJLogInViewController alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
        self.window.rootViewController = nav;
    }
    [self.window makeKeyAndVisible];
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application {
       // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}
- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    //取消徽章
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"noti:%@",notification);
    // 这里真实需要处理交互的地方
    // 获取通知所带的数据
    NSString *notMess = [notification.userInfo objectForKey:@"key"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发射机实时警告"
                                                    message:notMess
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    // 更新显示的徽章个数
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    badge++;
    
    //badge = badge >= 0 ? badge : 0;
    [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    
    NSArray *localNotifications = [UIApplication sharedApplication].scheduledLocalNotifications;
    
    for (UILocalNotification *notification in localNotifications) {
        NSDictionary *userInfo = notification.userInfo;
        if (userInfo) {
            // 根据设置通知参数时指定的key来获取通知参数
            NSString *info = userInfo[@"key"];
            // 如果找到需要取消的通知，则取消
            if (info != nil) {
                [[UIApplication sharedApplication] cancelLocalNotification:notification];
                break;
            }
        }
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
    
}
- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}
@end
