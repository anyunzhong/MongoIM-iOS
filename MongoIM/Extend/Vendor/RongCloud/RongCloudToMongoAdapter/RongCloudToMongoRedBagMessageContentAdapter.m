//
//  RongCloudToMongoRedBagMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoRedBagMessageContentAdapter.h"
#import "DFRedBagMessageContent.h"

//自定义
#import "RCRedBagMessage.h"

@implementation RongCloudToMongoRedBagMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCRedBagMessage *)redBagMessage
{
    DFRedBagMessageContent *messageContent = [[DFRedBagMessageContent alloc] init];
    messageContent.title = redBagMessage.title;
    return messageContent;
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeRedBag;
}

-(NSString *)getConversationSubTitle:(RCRedBagMessage *)redBagMessage
{
    return [NSString stringWithFormat:@"[红包] %@", redBagMessage.title];
}

@end
