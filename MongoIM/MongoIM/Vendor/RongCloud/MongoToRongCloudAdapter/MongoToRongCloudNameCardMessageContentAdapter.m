//
//  MongoToRongCloudNameCardMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudNameCardMessageContentAdapter.h"
#import "RCNameCardMessage.h"
#import "DFNameCardMessageContent.h"

@implementation MongoToRongCloudNameCardMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFNameCardMessageContent *)nameCardMessage
{
    RCNameCardMessage *content = [[RCNameCardMessage alloc] init];
    content.userId = nameCardMessage.userId;
    content.userNick = nameCardMessage.userNick;
    content.userNum = nameCardMessage.userNum;
    content.userAvatar = nameCardMessage.userAvatar;
    return content;
    
}
@end
