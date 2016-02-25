//
//  DFBaseMessageHandler.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/29.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFBaseMessageHandler.h"

@implementation DFBaseMessageHandler

-(void)sendMessage:(DFMessage *)message
{
    
}

-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size
{
    return nil;
}

-(NSMutableArray *)getImageMessages:(ConversationType)type targetId:(NSString *)targetId size:(NSUInteger)size
{
    return nil;
}

-(NSMutableArray *)getConversations
{
    return nil;
}

-(void)setMessageReceivedStatus:(NSUInteger)messageId receivedStatus:(MessageReceiveStatus)receivedStatus
{
    
}

-(void)deleteMessage:(NSUInteger)messageId
{
    
}

-(void)deleteConversation:(ConversationType)type targetId:(NSString *)targetId
{
    
}
@end
