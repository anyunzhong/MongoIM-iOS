//
//  RongCloudToMongoLocationMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoLocationMessageContentAdapter.h"
#import "DFLocationMessageContent.h"

@implementation RongCloudToMongoLocationMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCLocationMessage *)locationMessage
{
    DFLocationMessageContent *messageContent = [[DFLocationMessageContent alloc] init];
    messageContent.thumbnailImage = locationMessage.thumbnailImage;
    messageContent.location = locationMessage.location;
    messageContent.locationName = locationMessage.locationName;
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeLocation;
}

-(NSString *)getConversationSubTitle:(RCLocationMessage *)locationMessage
{
    return @"[位置]";
}


@end
