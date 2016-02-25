//
//  RongCloudToMongoInfomationNotificationMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoInfomationNotificationMessageContentAdapter.h"
#import "DFInfoNotifyMessageContent.h"

@implementation RongCloudToMongoInfomationNotificationMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCInformationNotificationMessage *)infoNotifyMessage
{
    DFInfoNotifyMessageContent *messageContent = [[DFInfoNotifyMessageContent alloc] init];
    messageContent.content = infoNotifyMessage.message;
    return messageContent;
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeInfoNotify;
}

-(NSString *)getConversationSubTitle:(RCInformationNotificationMessage *)infoMessage
{
    return @"[系统通知]";
}


@end
