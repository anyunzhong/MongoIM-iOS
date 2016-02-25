//
//  MongoToRongCloudRedBagMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudRedBagMessageContentAdapter.h"
#import "DFRedBagMessageContent.h"
#import "RCRedBagMessage.h"

@implementation MongoToRongCloudRedBagMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(DFRedBagMessageContent *)redBagMessage
{
    RCRedBagMessage *content = [[RCRedBagMessage alloc] init];
    content.title = redBagMessage.title;
    return content;

}
@end
