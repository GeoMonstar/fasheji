//
//  JQBaseNav.m
//  GospellLive
//
//  Created by Monstar on 16/8/4.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "JQBaseNav.h"

#define CJScreenWidth  [UIScreen mainScreen].bounds.size.width
#define CJScreenHeight [UIScreen mainScreen].bounds.size.height
#define NavOffsetFloat 0.65 //拉伸参数
#define NavOffsetDistance 150 //最小回弹距离

#define NavBigestDistance 150 //返回最大位置
@interface JQBaseNav()<UIGestureRecognizerDelegate>{

    CGFloat startX ;//开始位置
    
}

@property (nonatomic, assign) CGPoint mStartPoint;

@property (nonatomic, strong) UIImageView *mLastScreenShotView;

@property (nonatomic, strong) UIView *mBgView;

@property (nonatomic, strong) NSMutableArray *mScreenShots;

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic, assign) BOOL mIsMoving;

@property (nonatomic, assign) BOOL mCanpan;

@end

@implementation JQBaseNav

- (instancetype)init{
    self = [super init];
    if (self) {
        self.canDragBack = YES;
        
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.layer.shadowOffset  = CGSizeMake(0, 10);
    self.view.layer.shadowOpacity = 0.8;
    self.view.layer.shadowRadius  = 10;
    self.view.layer.shadowColor   = [UIColor blackColor].CGColor;
    self.panGesture  = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(didPanGesture:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopPangesture:) name:kGestureControl object:nil];
}
- (void)stopPangesture:(NSNotification *)notification{
    
    if ([[notification.userInfo objectForKey:@"canPan"] isEqualToString:@"0"]) {
        self.mCanpan = NO;
    }else{
        self.mCanpan = YES;
    }
    
    
}
//初始化截屏的view
- (void)initViews{
    if (!self.mBgView) {
        self.mBgView = [[UIView alloc]initWithFrame:self.view.bounds];
        self.mBgView.backgroundColor = [UIColor blackColor];
        [self.view.superview insertSubview:self.mBgView belowSubview:self.view];
    }
    self.mBgView.hidden = NO;
    if (self.mLastScreenShotView) [self.mLastScreenShotView removeFromSuperview];
    UIImage *lastScreenShot = [self.mScreenShots lastObject];
    self.mLastScreenShotView = [[UIImageView alloc] initWithImage:lastScreenShot];
    self.mLastScreenShotView.frame = (CGRect){-(CJScreenWidth *NavOffsetFloat),0,CJScreenWidth,CJScreenHeight};
    [self.mBgView addSubview:self.mLastScreenShotView];
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (self.viewControllers.count >0) {
        //隐藏底部tabbar
        [self.mScreenShots addObject:[self capture]];
       
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //[self pushAnimation:viewController];
    [super pushViewController:viewController animated:animated];
}
- (void)pushAnimation:(UIViewController *)viewController{
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.35];
    [animation setType: kCATransitionMoveIn];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [super pushViewController:viewController animated:NO];
    [self.view.layer addAnimation:animation forKey:nil];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    if (animated) {
        [self popAnimation];
        return nil;
    } else {
        return [super popViewControllerAnimated:animated];
    }
}
- (void) popAnimation {
    if (self.viewControllers.count == 1) {
        return;
    }
    [self initViews];
    [UIView animateWithDuration:0.4 animations:^{
        [self doMoveViewWithX:CJScreenWidth];
    } completion:^(BOOL finished) {
        [self completionPanBackAnimation];
    }];
}
#pragma mark ------------  UIPanGestureRecognizer -------


-(void)didPanGesture:(UIPanGestureRecognizer *)recoginzer{
    
    if (self.viewControllers.count <= 1 && !self.canDragBack) return;
    CGPoint touchPoint = [recoginzer locationInView:[[UIApplication sharedApplication]keyWindow]];
    
    CGFloat offsetX = touchPoint.x - self.mStartPoint.x;
   
    if(recoginzer.state == UIGestureRecognizerStateBegan)
    {
        startX  = touchPoint.x;
       
        if (touchPoint.x > NavBigestDistance) {
            return;
        }
        [self initViews];
        _mIsMoving = YES;
        _mStartPoint = touchPoint;
        offsetX = 0;
    }
    
    if(recoginzer.state == UIGestureRecognizerStateEnded)
    {
        
        if (offsetX > NavOffsetDistance && startX<NavBigestDistance)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:CJScreenWidth];
            } completion:^(BOOL finished) {
                [self completionPanBackAnimation];
                
                self.mIsMoving = NO;
            }];
        }else{
            [UIView animateWithDuration:0.3 animations:^{
                [self doMoveViewWithX:0];
            } completion:^(BOOL finished) {
                self.mIsMoving = NO;
                self.mBgView.hidden = YES;
            }];
        }
        self.mIsMoving = NO;
    }
    if(recoginzer.state == UIGestureRecognizerStateCancelled)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self doMoveViewWithX:0];
        } completion:^(BOOL finished) {
            self.mIsMoving = NO;
            self.mBgView.hidden = YES;
        }];
        self.mIsMoving = NO;
    }
    if (self.mIsMoving) {
        [self doMoveViewWithX:offsetX];
    }
}
-(void)doMoveViewWithX:(CGFloat)x{
    x = x>CJScreenWidth?CJScreenWidth:x;
    x = x<0?0:x;
    CGRect frame = self.view.frame;
    frame.origin.x = x;
    self.view.frame = frame;
    self.mLastScreenShotView.frame = (CGRect){-(CJScreenWidth*NavOffsetFloat)+x*NavOffsetFloat,0,CJScreenWidth,CJScreenHeight};
}
-(void)completionPanBackAnimation{
    [self.mScreenShots removeLastObject];
    //if (self.navigationController.viewControllers.count >1) {
        [super popViewControllerAnimated:NO];
    //}
    
    CGRect frame = self.view.frame;
    frame.origin.x = 0;
    self.view.frame = frame;
    self.mBgView.hidden = YES;
}
//截屏
- (UIImage *)capture
{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    //UIView *windowView = [[UIApplication sharedApplication].windows lastObject];
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



-(UIStatusBarStyle)preferredStatusBarStyle{
    UIViewController* topVC = self.topViewController;
    return [topVC preferredStatusBarStyle];
}
#pragma mark -- setter
-(NSMutableArray *)mScreenShots{
    if (!_mScreenShots) {
        _mScreenShots = [NSMutableArray new];
    }
    return _mScreenShots;
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    //当图层为地图或者可操作cell时禁用手势
    //VVDLog(@"%@",NSStringFromClass([touch.view class]));
    if (self.mCanpan) {
        return YES;
    }else{
            if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"] ||[NSStringFromClass([touch.view class]) isEqualToString:@"TapDetectingView"] ) {
               
                return NO;
            }
        
            else{
                 return YES;
            }
    }
}
@end
