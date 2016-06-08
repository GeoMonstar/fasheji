//
//  FSJStationInfo.h
//  FSJ
//
//  Created by Monstar on 16/6/7.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJStationInfo : NSObject



@property (nonatomic,copy)NSString *grade;

@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *organId;

@property (nonatomic,copy)NSString *parentId;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
