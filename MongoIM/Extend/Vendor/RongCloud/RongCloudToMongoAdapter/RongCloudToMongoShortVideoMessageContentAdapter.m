//
//  RongCloudToMongoShortVideoMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoShortVideoMessageContentAdapter.h"
#import "RCShortVideoMessage.h"
#import "DFShortVideoMessageContent.h"

@implementation RongCloudToMongoShortVideoMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCShortVideoMessage *)videoMessage
{
    
    DFShortVideoMessageContent *messageContent = [[DFShortVideoMessageContent alloc] init];
    
    NSData *data =  [[NSData alloc] initWithBase64EncodedString:videoMessage.cover options:0];
    UIImage *image = [UIImage imageWithData:data];
    
    messageContent.cover = image;
    messageContent.url = videoMessage.url;
    
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeShortVideo;
}

-(NSString *)getConversationSubTitle:(RCShortVideoMessage *) videoMessage
{
    return @"[视频]";
}


@end
