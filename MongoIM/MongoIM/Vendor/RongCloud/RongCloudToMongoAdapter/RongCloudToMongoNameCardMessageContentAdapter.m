//
//  RongCloudToMongoNameCardMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoNameCardMessageContentAdapter.h"
#import "RCNameCardMessage.h"
#import "DFNameCardMessageContent.h"

@implementation RongCloudToMongoNameCardMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCNameCardMessage *)nameCardMessage
{
    
    DFNameCardMessageContent *messageContent = [[DFNameCardMessageContent alloc] init];
    messageContent.userId = nameCardMessage.userId;
    messageContent.userNick = nameCardMessage.userNick;
    messageContent.userNum = nameCardMessage.userNum;
    messageContent.userAvatar = nameCardMessage.userAvatar;
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeNameCard;
}

-(NSString *)getConversationSubTitle:(RCNameCardMessage *)nameCardMessage
{
    return [NSString stringWithFormat:@"[名片] %@", nameCardMessage.userNick];
}

@end
