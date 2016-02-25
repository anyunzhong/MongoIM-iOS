//
//  MongoToRongCloudShortVideoMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudShortVideoMessageContentAdapter.h"
#import "RCShortVideoMessage.h"
#import "DFShortVideoMessageContent.h"


@implementation MongoToRongCloudShortVideoMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFShortVideoMessageContent *)videoMessage
{
    RCShortVideoMessage *content = [[RCShortVideoMessage alloc] init];
    content.url = videoMessage.url;
    
    NSData *data = UIImageJPEGRepresentation(videoMessage.cover, 1.0);
    NSString *cover = [data base64EncodedStringWithOptions:0];
    content.cover = cover;
    
    return content;
    
}

@end
