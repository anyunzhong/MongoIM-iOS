//
//  RongCloudToMongoEmotionMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/11.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoEmotionMessageContentAdapter.h"
#import "RCEmotionMessage.h"
#import "DFEmotionMessageContent.h"

@implementation RongCloudToMongoEmotionMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCEmotionMessage *)emotionMessage
{
    DFPackageEmotionItem *item = [[DFPackageEmotionItem alloc] init];
    item.name = emotionMessage.name;
    item.remoteGif = emotionMessage.remoteGif;
    item.remoteThumb = emotionMessage.remoteThumb;
    item.localGif = emotionMessage.localGif;
    item.localThumb = emotionMessage.localThumb;
    
    DFEmotionMessageContent *messageContent = [[DFEmotionMessageContent alloc] init];
    messageContent.emotionItem = item;
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeEmotion;
}

-(NSString *)getConversationSubTitle:(RCEmotionMessage *)emotionMessage
{
    return [NSString stringWithFormat:@"[%@]", emotionMessage.name];
}


@end
