//
//  FSJDES.m
//  FSJ
//
//  Created by Monstar on 16/3/3.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "FSJDES.h"
#import "CQEncrypt.h"
#define FSJ_XX @"20160303"

@implementation FSJDES

/**
 *  加密
 *
 *  @param text 需要加密的字符串
 *
 *  @return 返回加密数据
 */
+ (NSString *)encrypt:(NSString *)text{
    
    return  [CQEncrypt encryptUseDES:text key:FSJ_XX];
}
/**
 *  解密
 *
 *  @param text 需要解密的字符串
 *
 *  @return 返回解密数据
 */
+ (NSString *)decrypt:(NSString *)text{
    return [CQEncrypt decryptUseDES:text key:FSJ_XX];
}


@end
