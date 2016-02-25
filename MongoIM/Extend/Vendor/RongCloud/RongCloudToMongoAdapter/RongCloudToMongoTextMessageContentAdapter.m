//
//  RongCloudToMongoTextMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoTextMessageContentAdapter.h"
#import "DFTextMessageContent.h"

@implementation RongCloudToMongoTextMessageContentAdapter


-(DFMessageContent *)getMongoMessageContent:(RCTextMessage *)textMessage
{
    DFTextMessageContent *messageContent = [[DFTextMessageContent alloc] init];
    messageContent.text = textMessage.content;
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeText;
}

-(NSString *)getConversationSubTitle:(RCTextMessage *)textMessage
{
    return textMessage.content;
}

@end
