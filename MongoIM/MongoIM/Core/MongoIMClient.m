//
//  MongoIMClient.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/29.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoIMClient.h"

#import "DFMessageStorageService.h"


@implementation MongoIMClient

static MongoIMClient *_client=nil;

#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_client == nil) {
            _client = [[MongoIMClient alloc] init];
        }
    }
    return _client;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}


-(void)sendMessage:(DFMessage *)message
{
    [[DFMessageStorageService sharedInstance] insertMessage:message];
}

-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size
{
    return [[DFMessageStorageService sharedInstance] getMessages:type targetId:targetId start:start size:size];
}


@end
