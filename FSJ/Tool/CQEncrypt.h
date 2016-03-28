//
//  CQEncrypt.h
//  iCity_CQ
//
//  Created by 🐠 on 7/31/14.
//  Copyright (c) 2014 whty. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CQEncrypt : NSObject
#pragma mark- 解密
+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key;
#pragma mark- 加密
+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key;
@end
