//
//  DFDefaultMessageHandler.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/29.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMongoMessageHandler.h"
#import "MongoIMClient.h"

@interface DFMongoMessageHandler()

@property (nonatomic, strong) NSString *senderId;

@end


@implementation DFMongoMessageHandler

- (instancetype)initWithSenderId:(NSString *) senderId
{
    self = [super init];
    if (self) {
        _senderId = senderId;
    }
    return self;
}

-(void)sendMessage:(DFMessage *)message
{
    message.senderId = _senderId;
    
    [[MongoIMClient sharedInstance] sendMessage:message];
}

-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size
{
    return [[MongoIMClient sharedInstance] getMessages:type targetId:targetId start:start size:size];
}

@end
