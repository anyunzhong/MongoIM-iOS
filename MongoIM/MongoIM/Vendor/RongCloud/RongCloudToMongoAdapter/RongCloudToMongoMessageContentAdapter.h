//
//  RongCloudToMongoMessageContentAdapter.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFConversation.h"
#import <RongIMLib/RongIMLib.h>
#import "DFMessageContent.h"
#import "MessageContentType.h"
#import "DFMessage.h"

@interface RongCloudToMongoMessageContentAdapter : NSObject

//通过融云的会话内容获得对应的Mongo会话内容
-(DFConversation *) getMongoConversation:(RCConversation *) conversation;

-(NSString *) getConversationSubTitle:(RCMessageContent *) content;

//通过融云消息类型得到对应的Mongo消息类型
-(NSString *) getMongoMessageType;

//通过融云的消息内容获得对应的Mongo消息内容
-(DFMessageContent *) getMongoMessageContent:(RCMessageContent *) content;

//发送消息
-(void)sendMessage:(DFMessage *) message type:(RCConversationType) type content:(RCMessageContent *) content;

@end
