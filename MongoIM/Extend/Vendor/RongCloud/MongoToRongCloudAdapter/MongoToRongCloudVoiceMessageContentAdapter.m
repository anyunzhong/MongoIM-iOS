//
//  MongoToRongCloudVoiceMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudVoiceMessageContentAdapter.h"
#import "DFVoiceMessageContent.h"

@implementation MongoToRongCloudVoiceMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFVoiceMessageContent *)voiceMessage
{
    return [RCVoiceMessage messageWithAudio:voiceMessage.wavAudioData duration:voiceMessage.duration];
}
@end
