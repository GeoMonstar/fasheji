//
//  FSJOneCity.h
//  FSJ
//
//  Created by Monstar on 16/3/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJOneCity : NSObject


@property (nonatomic, copy)NSString *areaId;

@property (nonatomic, copy)NSString *name;

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *alarmSize;

@property (nonatomic, copy)NSString *alarmTotal;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
