//
//  MIVoiceMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import <QuartzCore/QuartzCore.h>

@interface DFVoiceMessageContent : DFMediaMessageContent

@property(nonatomic, strong) NSData *wavAudioData;
@property(nonatomic, assign) NSUInteger duration;

@property (assign, nonatomic) CGFloat bubbleWidth;

@end
