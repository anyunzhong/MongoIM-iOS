//
//  MongoToRongCloudImageMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudImageMessageContentAdapter.h"
#import "DFImageMessageContent.h"

@implementation MongoToRongCloudImageMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFImageMessageContent *)imageMessage
{
    return [RCImageMessage messageWithImage:imageMessage.originImage];
}
@end
