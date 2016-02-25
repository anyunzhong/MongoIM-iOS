//
//  RongCloudToMongoShareMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoShareMessageContentAdapter.h"
#import "DFShareMessageContent.h"
#import "RCShareMessage.h"

@implementation RongCloudToMongoShareMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCShareMessage *)shareMessage
{
    DFShareMessageContent *shareContent = [[DFShareMessageContent alloc] init];
    shareContent.title = shareMessage.title;
    shareContent.desc = shareMessage.desc;
    shareContent.thumb = shareMessage.thumb;
    shareContent.link = shareMessage.link;
    shareContent.sourceLogo = shareMessage.sourceLogo;
    shareContent.sourceName = shareMessage.sourceName;
    return shareContent;

}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeShare;
}

-(NSString *)getConversationSubTitle:(RCShareMessage *)shareMessage
{
    return [NSString stringWithFormat:@"[链接] %@", shareMessage.title];
}
@end
