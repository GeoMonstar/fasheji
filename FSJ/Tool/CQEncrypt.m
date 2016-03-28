//
//  CQEncrypt.m
//  iCity_CQ
//
//  Created by 🐠 on 7/31/14.
//  Copyright (c) 2014 whty. All rights reserved.
//

#import "CQEncrypt.h"
#import "GTMBase64.h"
#include <CommonCrypto/CommonCryptor.h>
#pragma mark- 加密Key
#define CQ_KEY   @"20150720"

@implementation CQEncrypt
#pragma mark- 解密
+(NSString*) decryptUseDES:(NSString*)cipherText key:(NSString*)key {
    if (!key) {
        key = CQ_KEY;
    }
    
    // 利用 GTMBase64 解碼 Base64 字串
    NSString *tempBase64 = [self stringFromHexString:cipherText];
    NSData* cipherData = [GTMBase64 decodeString:tempBase64];
//    NSData *cipherData = [NSData dataFromBase64String:cipherText];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesDecrypted = 0;
    
    // IV 偏移量不需使用
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [cipherData bytes],
                                          [cipherData length],
                                          buffer,
                                          1024,
                                          &numBytesDecrypted);
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData* data = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesDecrypted];
        plainText = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }else{
    
        NSLog(@"DES解码失败");
    }
    
    return plainText;
}

+(NSString *) encryptUseDES:(NSString *)clearText key:(NSString *)key
{
    if (!key) {
        key = CQ_KEY;
    }
    
    NSData *data = [clearText dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    unsigned char buffer[1024];
    memset(buffer, 0, sizeof(char));
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          nil,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          1024,
                                          &numBytesEncrypted);
    
    NSString* plainText = nil;
    if (cryptStatus == kCCSuccess) {
        NSData *dataTemp = [NSData dataWithBytes:buffer length:(NSUInteger)numBytesEncrypted];
        plainText = [GTMBase64 encodeBase64Data:dataTemp];
        NSString *hexStr = [self parseByteArray2HexString:plainText];
        return hexStr;
    }
        NSLog(@"DES加密失败");
        return plainText;
    
}
//普通转成十六进制
+ (NSString *)parseByteArray2HexString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr];
    }
    return hexStr;
}
//十六进制转普通字符串
+ (NSString *)stringFromHexString:(NSString *)hexString { //
    
    char *myBuffer = (char *)malloc((int)[hexString length] / 2 + 1);
    bzero(myBuffer, [hexString length] / 2 + 1);
    for (int i = 0; i < [hexString length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexString substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        myBuffer[i / 2] = (char)anInt;
    }
    NSString *unicodeString = [NSString stringWithCString:myBuffer encoding:4];
    return unicodeString;
    
    
}
@end
