//
//  AppDelegate.m
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//
#import "AppDelegate.h"
#import "FSJLogInViewController.h"
#import "FSJMapViewController.h"
//#define BaiduMapKEy @"LuciFxMX26SzSnd3zEZEfb8R"
#define BaiduMapKEy @"G4u27joqchFtv5iVTn5KPwXp"
@interface AppDelegate ()<BMKGeneralDelegate>{
    BMKMapManager * _mapManager;
}
@end
@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [GLobalRealReachability startNotifier];
    //carsh
    [[PgyManager sharedPgyManager] setEnableFeedback:NO];
    [[PgyManager sharedPgyManager] startManagerWithAppId:PgyAppID];
    [[PgyUpdateManager sharedPgyManager] startManagerWithAppId:PgyAppID];
    //[[PgyUpdateManager sharedPgyManager] checkUpdate];
    
    NSString *str = [[NSBundle mainBundle] bundleIdentifier];
    NSLog(@"%@",str);
        _mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [_mapManager start:BaiduMapKEy generalDelegate:self];
        if (!ret) {
            NSLog(@"启动失败");
    }
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    BOOL bo =(BOOL) [[EGOCache globalCache]objectForKey:@"Login"];
    if (bo) {
        FSJMapViewController *vc = [[FSJMapViewController alloc]init];
        self.window.rootViewController = vc;
    }
    else{
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
    //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)applicationWillTerminate:(UIApplication *)application {
    
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
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
