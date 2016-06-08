//
//  FSJOganTree.h
//  FSJ
//
//  Created by Monstar on 16/6/7.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJOganTree : NSObject


@property (nonatomic, retain)NSArray *country;
@property (nonatomic, retain)NSArray *province;
@property (nonatomic, retain)NSArray *city;
@property (nonatomic, retain)NSArray *county;
@property (nonatomic, copy)NSString *status;
@property (nonatomic,copy)NSString *message;
+ (instancetype)initWithDictionary:(NSDictionary *)dic;
@end
