//
//  MPush.m
//  FSJ
//
//  Created by Leaf on 16/3/28.
//  Copyright © 2016年 Monstar. All rights reserved.
//

#import "MPush.h"
#import "mopush.h"

int kQos = 2;

static NSString * const kHost      = @"119.6.203.24";
static int const kPort             = 2017;

//static NSString * const kHost      = @"192.168.10.188";
//static int const kPort             = 1883;
static int const kKeepAlive        = 60;
static BOOL const kCleanSession    = NO;

static NSString *s_clientId = nil;
static NSString *s_topic    = nil;

typedef void(^ConnectSuccess)(int);
typedef void(^ReceiveMessage)(NSString *);

static ConnectSuccess s_connectSuccess;
static ReceiveMessage s_receiveMessage;

@implementation MPush
{
    mopush *_mopush;
    dispatch_source_t _timer;
}

#pragma mark - API

+ (void)registerForClientId:(NSString *)clientId withAppName:(NSString *)name {
    s_clientId = clientId;
    mopush_set_appName(name.UTF8String);
    [[MPush shareInstance] connect];
}

+ (void)subscribeForArea:(NSString *)area {
    s_topic = area;
    [[MPush shareInstance] subscribeForArea:area];
}

+ (void)unsubscribe {
    [[MPush shareInstance] unsubscribe];
}

+ (void)setConnectCallback:(ConnectSuccess)success {
    [[MPush shareInstance] setConnectCallback:success];
}

+ (void)setMessageCallback:(ReceiveMessage)receiveMessage {
    [[MPush shareInstance] setMessageCallback:receiveMessage];
}

#pragma mark - Method

+ (void)initialize {
    mopush_lib_init();
}

+ (instancetype)shareInstance {
    static MPush *mpush = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mpush = [[self alloc] init];
    });
    return mpush;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _mopush = mopush_new(s_clientId.UTF8String, kCleanSession, (__bridge void *)(self));
//        mopush_connect_callback_set(_mopush, on_connect);
//        mopush_message_callback_set(_mopush, on_message);
    }
    
    return self;
}

- (void)connect {
    mopush_connect(_mopush, kHost.UTF8String, kPort, kKeepAlive);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_queue_create("com.queue.timer", DISPATCH_QUEUE_CONCURRENT));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 0.01 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (mopush_loop(_mopush, -1)) {
            mopush_reconnect(_mopush);
        }
    });
    dispatch_resume(_timer);
    
}

- (void)subscribeForArea:(NSString *)area {
    int mid =1;
    mopush_subscribe(_mopush, &mid, area.UTF8String, kQos);
}

- (void)unsubscribe {
    mopush_unsubscribe(_mopush, NULL, s_topic.UTF8String);
}

#pragma mark - Callback

static void on_connect(mopush *mop, void *obj, int rc)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        s_connectSuccess(rc);
    });
}

static void on_message(mopush *mop, void *obj, struct mopush_message *message)
{
    NSString *newMsg = [[NSString alloc] initWithBytes:message->payload
                                                length:message->payloadlen
                                              encoding:NSUTF8StringEncoding];
    dispatch_async(dispatch_get_main_queue(), ^{
        s_receiveMessage(newMsg);
    });
}

- (void)setConnectCallback:(ConnectSuccess)success {
    s_connectSuccess = success;
    mopush_connect_callback_set(_mopush, on_connect);
}

- (void)setMessageCallback:(ReceiveMessage)receiveMessage {
    s_receiveMessage = receiveMessage;
    mopush_message_callback_set(_mopush, on_message);
}

#pragma mark - dealloc

- (void)dealloc {
    dispatch_source_cancel(_timer);
    
    if (_mopush) {
        //  释放内存
        mopush_destroy(_mopush);
        _mopush = NULL;
        //  释放库资源
        mopush_lib_cleanup();
        
    }
}

@end
