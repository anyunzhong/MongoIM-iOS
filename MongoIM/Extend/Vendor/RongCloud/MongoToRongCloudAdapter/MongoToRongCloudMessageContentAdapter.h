//
//  MongoToRongCloudMessageContentAdapter.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLib/RongIMLib.h>
#import "DFMessageContent.h"


@interface MongoToRongCloudMessageContentAdapter : NSObject

//通过Mongo的消息内容获取对应的融云MessageContent
-(RCMessageContent *) getRongCloudMessageContent:(DFMessageContent *) content;

@end
