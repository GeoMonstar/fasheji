//
//  MPush.h
//  FSJ
//
//  Created by Leaf on 16/3/28.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MPush : NSObject

+ (void)registerForClientId:(NSString *)clientId;
+ (void)subscribeForArea:(NSString *)area;
+ (void)unsubscribe;
+ (void)setConnectCallback:(void(^)(int))success;
+ (void)setMessageCallback:(void(^)(NSString *))receiveMessage;

@end
