//
//  SCHTTPSessionManager.h
//  CDOTO
//
//  Created by yier on 16/3/29.
//  Copyright © 2016年 newdoone. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface SCHTTPSessionManager : AFHTTPSessionManager

@property (assign, nonatomic) BOOL isSecrecy;//需要加密

+(instancetype)shareInstance;
@end
