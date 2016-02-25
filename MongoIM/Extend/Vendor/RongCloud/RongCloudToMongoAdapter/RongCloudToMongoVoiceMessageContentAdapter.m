//
//  RongCloudToMongoVoiceMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoVoiceMessageContentAdapter.h"
#import "DFVoiceMessageContent.h"

@implementation RongCloudToMongoVoiceMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCVoiceMessage *)voiceMessage
{
    DFVoiceMessageContent *messageContent = [[DFVoiceMessageContent alloc] init];
    messageContent.duration = voiceMessage.duration;
    messageContent.wavAudioData = voiceMessage.wavAudioData;
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeVoice;
}

-(NSString *)getConversationSubTitle:(RCVoiceMessage *)voiceMessage
{
    return @"[语音]";
}

@end
