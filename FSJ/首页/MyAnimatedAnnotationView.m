//
//  MyAnimatedAnnotationView.m
//  IphoneMapSdkDemo
//
//  Created by wzy on 14-11-27.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "MyAnimatedAnnotationView.h"
#import "FSJMapViewController.h"
@implementation MyAnimatedAnnotationView
@synthesize annotationImageView = _annotationImageView;
@synthesize annotationImages = _annotationImages;
@synthesize headView = _headView;
@synthesize title = _title;
- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        //[self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        [self setBounds:CGRectMake(0.f, 0.f, 30.f, 30.f)];
        self.frame = CGRectMake(0, 0, 100, 70);
        [self setBackgroundColor:[UIColor clearColor]];
        _annotationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(37.5, 40, 25, 25)];
        _annotationImageView.contentMode = UIViewContentModeScaleAspectFit;
        CGRect rect = CGRectMake(0, 0, 100, 40);
        _headView = [[FSJPopHeadview alloc]initWithFrame:rect and:reuseIdentifier];
        [self addSubview:_headView];
        [self addSubview:_annotationImageView];
    }
    return self;
}
- (void)setHeadView:(FSJPopHeadview *)headView{
    _headView = headView;
}
- (void)setAnnotationImages:(NSMutableArray *)images {
    _annotationImages = images;
    [self updateImageView];
}

- (void)updateImageView {
    if ([_annotationImageView isAnimating]) {
        [_annotationImageView stopAnimating];
    }
    _annotationImageView.animationImages = _annotationImages;
    _annotationImageView.animationDuration = 0.5 * [_annotationImages count];
    _annotationImageView.animationRepeatCount = 0;
    [_annotationImageView startAnimating];
}

@end
