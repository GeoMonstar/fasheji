//
//  FSJAllFSJ.h
//  FSJ
//
//  Created by Monstar on 16/3/14.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FSJOneFSJ.h"
@interface FSJAllFSJ : NSObject


#pragma mark -- 查询返回列表

@property (nonatomic, retain)NSArray *list;

@property (nonatomic, copy)NSString *message;

@property (nonatomic, copy)NSString *count;

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *pageNo;

@property (nonatomic, copy)NSString *pageSize;
+ (instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
