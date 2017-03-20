//
//  FSJDES.h
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJDES : NSObject

//加密
+(NSString *) encrypt: (NSString *) text;
//解密
+(NSString *) decrypt: (NSString *) text;

@end
