//
//  FSJBaseModel.h
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension.h>
@interface FSJBaseModel : NSObject<NSCoding>
//
//
@property (nonatomic, copy)NSString *message;

@property (nonatomic, copy)NSString *state;

@property (nonatomic, copy)NSString *status;


+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
