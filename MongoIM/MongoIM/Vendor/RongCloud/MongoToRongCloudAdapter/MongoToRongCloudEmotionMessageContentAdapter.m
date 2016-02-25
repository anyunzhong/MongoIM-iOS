//
//  MongoToRongCloudEmotionMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/11.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudEmotionMessageContentAdapter.h"
#import "DFEmotionMessageContent.h"
#import "RCEmotionMessage.h"

@implementation MongoToRongCloudEmotionMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFEmotionMessageContent *)emotionMessage
{
    RCEmotionMessage *content = [[RCEmotionMessage alloc] init];
    content.name = emotionMessage.emotionItem.name;
    content.remoteThumb = emotionMessage.emotionItem.remoteThumb;
    content.remoteGif = emotionMessage.emotionItem.remoteGif;
    content.localThumb = emotionMessage.emotionItem.localThumb;
    content.localGif = emotionMessage.emotionItem.localGif;
    return content;
    
}

@end
