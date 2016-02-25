//
//  MongoToRongCloudTextMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudTextMessageContentAdapter.h"
#import "DFTextMessageContent.h"

@implementation MongoToRongCloudTextMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFTextMessageContent *)textMessage
{
    return [RCTextMessage messageWithContent:textMessage.text];
}
@end
