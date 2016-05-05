//
//  MyAnimatedAnnotationView.h
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "FSJPopHeadview.h"

@interface MyAnimatedAnnotationView : BMKAnnotationView

@property (nonatomic, strong) NSMutableArray *annotationImages;
@property (nonatomic, strong) UIImageView    *annotationImageView;
@property (nonatomic, strong) FSJPopHeadview *headView;
@property (nonatomic, copy)NSString *title;

@end
