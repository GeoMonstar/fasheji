//
//  FSJTransPoint.h
//  FSJ
//
//  Created by Monstar on 16/4/25.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSJTransPoint : NSObject

+ (BMKPolygon *)transferPathStringToPolygon:(NSArray *)paths;
@end
