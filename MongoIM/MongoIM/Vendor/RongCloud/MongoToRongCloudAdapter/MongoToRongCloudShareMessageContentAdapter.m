//
//  MongoToRongCloudShareMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudShareMessageContentAdapter.h"
#import "DFShareMessageContent.h"
#import "RCShareMessage.h"

@implementation MongoToRongCloudShareMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFShareMessageContent *)shareMessage
{
    RCShareMessage *rcShareMessage = [[RCShareMessage alloc] init];
    rcShareMessage.title = shareMessage.title;
    rcShareMessage.desc = shareMessage.desc;
    rcShareMessage.thumb = shareMessage.thumb;
    rcShareMessage.link = shareMessage.link;
    rcShareMessage.sourceName = shareMessage.sourceName;
    rcShareMessage.sourceLogo = shareMessage.sourceLogo;
    return rcShareMessage;

}
@end
