//
//  FSJInterestModel.h
//  FSJ
//
//  Created by Monstar on 16/6/7.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJInterestModel : NSObject


@property (nonatomic,copy)NSString *name;

@property (nonatomic,copy)NSString *stationId;

+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
