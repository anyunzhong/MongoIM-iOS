//
//  MongoToRongCloudLocationMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudLocationMessageContentAdapter.h"
#import "DFLocationMessageContent.h"

@implementation MongoToRongCloudLocationMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFLocationMessageContent *)locationMessage
{
    return [RCLocationMessage messageWithLocationImage:locationMessage.thumbnailImage location:locationMessage.location locationName:locationMessage.locationName];
}
@end
