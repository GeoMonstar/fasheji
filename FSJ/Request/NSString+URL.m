//
//  NSString+URL.m
//  test
//
//  Created by RIMIMAX on 14-7-11.
//  Copyright (c) 2014年 FuQingshan. All rights reserved.
//

#import "NSString+URL.h"

@implementation NSString (URL)

/*
 
 URLFragmentAllowedCharacterSet  "#%<>[\]^`{|}
 
 URLHostAllowedCharacterSet      "#%/<>?@\^`{|}
 
 URLPasswordAllowedCharacterSet  "#%/:<>?@[\]^`{|}
 
 URLPathAllowedCharacterSet      "#%;<>?[\]^`{|}
 
 URLQueryAllowedCharacterSet     "#%<>[\]^`{|}
 
 URLUserAllowedCharacterSet      "#%/:<>?@[\]^`
 
 */

- (NSString *)URLEncodedString
{
    NSString *encodedString = [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!$&'()*+,-./:;=?@_~%#[]"].invertedSet];
    return encodedString;
}
@end
