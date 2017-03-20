//
//  FSJOneFSJ.h
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJOneFSJ : NSObject



@property (nonatomic, copy)NSString *transId;

@property (nonatomic, copy)NSString *stationId;

@property (nonatomic, copy)NSString *lon;

@property (nonatomic, copy)NSString *lat;

@property (nonatomic, copy)NSString *ipAddr;

@property (nonatomic, copy)NSString *masterPr;

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *masterPo;

@property (nonatomic, copy)NSString *name;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
