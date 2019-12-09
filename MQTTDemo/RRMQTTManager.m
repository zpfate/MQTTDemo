//
//  RRMQTTManager.m
//  MQTTDemo
//
//  Created by Twisted Fate on 2019/11/29.
//  Copyright © 2019 Twisted Fate. All rights reserved.
//

#import "RRMQTTManager.h"
#import <MQTTClient/MQTTClient.h>

static NSString *const kMQTTHost = @"";
static UInt32 const kMQTTPort = 11;

@interface RRMQTTManager ()<MQTTSessionDelegate>

@property (nonatomic, strong) MQTTSession *session;



@end

@implementation RRMQTTManager


- (void)connectSession:(NSString *)userName password:(NSString *)password {
    
    [self.session setUserName:userName];
    [self.session setPassword:password];
    [_session connectAndWaitTimeout:10];
}

- (void)disconnectSession {
    [self.session disconnect];
    [self.session closeAndWait:1];
}

- (void)subscribeTopic:(NSString *)topic atLevel:(MQTTQosLevel)qosLevel  {
    
    [self.session subscribeToTopic:topic atLevel:MQTTQosLevelAtMostOnce subscribeHandler:^(NSError *error, NSArray<NSNumber *> *gQoss) {
        
        if (error) {
            NSLog(@"订阅失败: %@", error.localizedDescription);
        } else {
            NSLog(@"订阅成功: %@", gQoss);
        }
    }];
}

- (void)unsubscribeTopic:(NSString *)topic {
    [self.session unsubscribeTopic:topic];
}

#pragma mark -- MQTTSessionDelegate

- (void)newMessage:(MQTTSession *)session data:(NSData *)data onTopic:(NSString *)topic qos:(MQTTQosLevel)qos retained:(BOOL)retained mid:(unsigned int)mid {
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    
    // 通过topic分辨
    
}




#pragma mark -- Getter

- (MQTTSession *)session {
    
    if (!_session) {
        
        MQTTCFSocketTransport *transport = [[MQTTCFSocketTransport alloc] init];
        transport.host = kMQTTHost;
        transport.port = kMQTTPort;
        _session = [[MQTTSession alloc] init];
        _session.transport = transport;
        _session.delegate = self;
    }
    return _session;
}


@end
