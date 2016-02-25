//
//  RongCloudToMongoMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoMessageContentAdapter.h"
#import "Key.h"

@implementation RongCloudToMongoMessageContentAdapter


-(DFConversation *)getMongoConversation:(RCConversation *)conversation
{
    DFConversation *con = [[DFConversation alloc] init];
    con.targetId = conversation.targetId;
    //con.title = conversation.conversationTitle;
    con.unreadCount = conversation.unreadMessageCount;
    con.updateTime = conversation.sentTime;
    con.subTitle = [self getConversationSubTitle:conversation.lastestMessage];
    return con;
}


-(DFMessageContent *)getMongoMessageContent:(RCMessageContent *)content
{
    return nil;
}

-(NSString *)getMongoMessageType
{
    return nil;
}

-(NSString *)getConversationSubTitle:(RCMessageContent *)content
{
    return nil;
}

-(void)sendMessage:(DFMessage *)message type:(RCConversationType)type content:(RCMessageContent *)content
{
    RCMessage *msg = [[RCIMClient sharedRCIMClient] sendMessage:type targetId:message.targetId content:content
                                                    pushContent:nil
                                                       pushData:nil
                                                        success:^(long messageId) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                NSLog(@"发送成功。当前消息ID：%ld", messageId);
                                                                NSDictionary *dic = @{@"messageId": [NSNumber numberWithLong:messageId]};
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_SENT object:nil userInfo:dic];
                                                            });
                                                            
                                                            
                                                        } error:^(RCErrorCode errorCode, long messageId) {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                NSLog(@"发送失败。消息ID：%ld， 错误码：%ld", messageId, (long)errorCode);
                                                                NSDictionary *dic = @{@"messageId": [NSNumber numberWithLong:messageId]};
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_FAILED object:nil userInfo:dic];
                                                            });
                                                        }];
    
    
    message.messageId = msg.messageId;
    
}
@end
