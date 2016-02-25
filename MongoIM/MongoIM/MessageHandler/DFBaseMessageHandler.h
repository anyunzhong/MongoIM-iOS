//
//  DFBaseMessageHandler.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/29.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMessage.h"

@interface DFBaseMessageHandler : NSObject

//发送消息
-(void) sendMessage:(DFMessage *) message;

//获得消息列表
-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size;

//获得图片消息
-(NSMutableArray *)getImageMessages:(ConversationType)type targetId:(NSString *)targetId size:(NSUInteger)size;

//获得所有会话
-(NSMutableArray *) getConversations;

//设置消息状态
-(void)setMessageReceivedStatus:(NSUInteger)messageId receivedStatus:(MessageReceiveStatus)receivedStatus;

//删除消息
-(void) deleteMessage:(NSUInteger)messageId;

//删除会话
-(void) deleteConversation:(ConversationType)type targetId:(NSString *)targetId;


@end
