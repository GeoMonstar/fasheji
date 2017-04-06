//
//  NSString+URL.h
//  test
//
//  Created by RIMIMAX on 14-7-11.
//  Copyright (c) 2014年 FuQingshan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (URL)
/**
 *  网络传输中防止转义
 *
 */
- (NSString *)URLEncodedString;

@end
