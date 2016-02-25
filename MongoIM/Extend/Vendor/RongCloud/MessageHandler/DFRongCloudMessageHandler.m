//
//  DFRongCloudMessageHandler.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/30.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFRongCloudMessageHandler.h"
#import <RongIMLib/RongIMLib.h>
#import "MessageContentType.h"

#import "Key.h"

#import "DFTextMessageContent.h"
#import "DFVoiceMessageContent.h"
#import "DFImageMessageContent.h"
#import "DFInfoNotifyMessageContent.h"
#import "DFLocationMessageContent.h"
#import "DFShareMessageContent.h"
#import "DFEmotionMessageContent.h"
#import "DFNameCardMessageContent.h"
#import "DFShortVideoMessageContent.h"

#import "DFRedBagMessageContent.h"
#import "RCRedBagMessage.h"
#import "RCShareMessage.h"
#import "RCEmotionMessage.h"
#import "RCNameCardMessage.h"
#import "RCShortVideoMessage.h"

#import "ConnectionStatus.h"

#import "RongCloudToMongoMessageContentAdapterManager.h"
#import "MongoToRongCloudMessageContentAdapterManager.h"

@interface DFRongCloudMessageHandler()<RCIMClientReceiveMessageDelegate, RCConnectionStatusChangeDelegate>

@end

@implementation DFRongCloudMessageHandler

#pragma mark - Lifecycle
- (instancetype)initWithAppKey:(NSString *) appKey token:(NSString *) token
{
    self = [super init];
    if (self) {
        [[RCIMClient sharedRCIMClient] initWithAppKey:appKey];
        
        //注册自定义消息
        [[RCIMClient sharedRCIMClient] registerMessageType:[RCRedBagMessage class]];
        [[RCIMClient sharedRCIMClient] registerMessageType:[RCShareMessage class]];
        [[RCIMClient sharedRCIMClient] registerMessageType:[RCEmotionMessage class]];
        [[RCIMClient sharedRCIMClient] registerMessageType:[RCNameCardMessage class]];
        [[RCIMClient sharedRCIMClient] registerMessageType:[RCShortVideoMessage class]];
        
        //注册默认Adapter
        [self initMessageContentAdapter];
        
        
        [[RCIMClient sharedRCIMClient] connectWithToken:token success:^(NSString *userId) {
            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
            
            [[RCIMClient sharedRCIMClient] setReceiveMessageDelegate:self object:nil];
            [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
            
        } error:^(RCConnectErrorCode status) {
            NSLog(@"登陆的错误码为:%ld", (long)status);
        } tokenIncorrect:^{
            NSLog(@"token错误");
        }];
    }
    return self;
}

-(void) initMessageContentAdapter
{
    RongCloudToMongoMessageContentAdapterManager *rongManager = [RongCloudToMongoMessageContentAdapterManager sharedInstance];
    [rongManager registerAdapter:[RCTextMessage class] adapterClazz:[RongCloudToMongoTextMessageContentAdapter class]];
    [rongManager registerAdapter:[RCImageMessage class] adapterClazz:[RongCloudToMongoImageMessageContentAdapter class]];
    [rongManager registerAdapter:[RCVoiceMessage class] adapterClazz:[RongCloudToMongoVoiceMessageContentAdapter class]];
    [rongManager registerAdapter:[RCLocationMessage class] adapterClazz:[RongCloudToMongoLocationMessageContentAdapter class]];
    [rongManager registerAdapter:[RCRedBagMessage class] adapterClazz:[RongCloudToMongoRedBagMessageContentAdapter class]];
    [rongManager registerAdapter:[RCShareMessage class] adapterClazz:[RongCloudToMongoShareMessageContentAdapter class]];
    [rongManager registerAdapter:[RCEmotionMessage class] adapterClazz:[RongCloudToMongoEmotionMessageContentAdapter class]];
    [rongManager registerAdapter:[RCNameCardMessage class] adapterClazz:[RongCloudToMongoNameCardMessageContentAdapter class]];
    [rongManager registerAdapter:[RCShortVideoMessage class] adapterClazz:[RongCloudToMongoShortVideoMessageContentAdapter class]];

    [rongManager registerAdapter:[RCInformationNotificationMessage class] adapterClazz:[RongCloudToMongoInfomationNotificationMessageContentAdapter class]];
    
    
    MongoToRongCloudMessageContentAdapterManager *mongoManager = [MongoToRongCloudMessageContentAdapterManager sharedInstance];
    [mongoManager registerAdapter:[DFTextMessageContent class] adapterClazz:[MongoToRongCloudTextMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFImageMessageContent class] adapterClazz:[MongoToRongCloudImageMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFVoiceMessageContent class] adapterClazz:[MongoToRongCloudVoiceMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFLocationMessageContent class] adapterClazz:[MongoToRongCloudLocationMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFRedBagMessageContent class] adapterClazz:[MongoToRongCloudRedBagMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFShareMessageContent class] adapterClazz:[MongoToRongCloudShareMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFEmotionMessageContent class] adapterClazz:[MongoToRongCloudEmotionMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFNameCardMessageContent class] adapterClazz:[MongoToRongCloudNameCardMessageContentAdapter class]];
    [mongoManager registerAdapter:[DFShortVideoMessageContent class] adapterClazz:[MongoToRongCloudShortVideoMessageContentAdapter class]];

}

-(RongCloudToMongoMessageContentAdapter *) getRongCloudAdapter:(Class)clazz
{
    RongCloudToMongoMessageContentAdapterManager *manager = [RongCloudToMongoMessageContentAdapterManager sharedInstance];
    RongCloudToMongoMessageContentAdapter *adapter = [manager getAdapter:clazz];
    return adapter;
}


#pragma mark - MethodImpl

-(void)sendMessage:(DFMessage *)message
{
    message.senderId = [RCIMClient sharedRCIMClient].currentUserInfo.userId;
    
    RCConversationType type = [self getRongCloudType:message.conversationType];
    
    RCMessageContent *content = [self getRongCloudMessageContent:message];
    
    //如果无法生成融云的消息内容 需要提示消息无法发送
    if (content == nil) {
        NSLog(@"暂不支持此类消息发送");
        return;
    }

    RongCloudToMongoMessageContentAdapter *adapter = [self getRongCloudAdapter:[content class]];
    [adapter sendMessage:message type:type content:content];
}

-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size
{
    NSArray *array;
    
    if (start==0) {
        array = [[RCIMClient sharedRCIMClient] getLatestMessages:[self getRongCloudType:type] targetId:targetId count:(int)size];
    }else{
        array =  [[RCIMClient sharedRCIMClient] getHistoryMessages:[self getRongCloudType:type] targetId:targetId oldestMessageId:(long)start count:(int)size];
    }
    
    NSMutableArray *messages = [NSMutableArray array];
    
    for (RCMessage *msg in array) {
        
        DFMessage *message = [self getMongoMessage:msg];
        [messages addObject:message];
    }
    
    return messages;
}

-(NSMutableArray *)getImageMessages:(ConversationType)type targetId:(NSString *)targetId size:(NSUInteger)size
{
    RCConversation *con = [[RCIMClient sharedRCIMClient] getConversation:[self getRongCloudType:type] targetId:targetId];
    
    NSArray *array =  [[RCIMClient sharedRCIMClient] getHistoryMessages:[self getRongCloudType:type] targetId:targetId objectName:@"RC:ImgMsg" oldestMessageId:(long)(con.lastestMessageId) count:(int)size];
    NSMutableArray *messages = [NSMutableArray array];
    
    for (RCMessage *msg in array) {
        
        DFMessage *message = [self getMongoMessage:msg];
        [messages addObject:message];
    }
    
    return messages;
}


-(NSMutableArray *)getConversations
{
    NSArray *conversationList = [[RCIMClient sharedRCIMClient] getConversationList:@[@(ConversationType_PRIVATE),
                                                                                     @(ConversationType_DISCUSSION),
                                                                                     @(ConversationType_GROUP),@(ConversationType_CHATROOM),@(ConversationType_SYSTEM)]];
    NSMutableArray *conversations = [NSMutableArray array];
    
    for (RCConversation *conversation in conversationList) {
        DFConversation *con = [self getMongoConversation:conversation];
        [conversations addObject:con];
    }
    
    return conversations;
}



-(void)setMessageReceivedStatus:(NSUInteger)messageId receivedStatus:(MessageReceiveStatus)receivedStatus
{
    RCReceivedStatus status = [self getRongCloudReceiveStatus:receivedStatus];
    [[RCIMClient sharedRCIMClient] setMessageReceivedStatus:messageId receivedStatus:status];
}


-(void)deleteMessage:(NSUInteger)messageId
{
    [[RCIMClient sharedRCIMClient] deleteMessages:@[[NSNumber numberWithUnsignedInteger:messageId]]];
}

-(void)deleteConversation:(ConversationType)type targetId:(NSString *)targetId
{
    [[RCIMClient sharedRCIMClient] removeConversation:[self getRongCloudType:type] targetId:targetId];
}


#pragma mark - Method


-(DFConversation *) getMongoConversation:(RCConversation *) conversation{
    
    RongCloudToMongoMessageContentAdapter *adapter = [self getRongCloudAdapter:[conversation.lastestMessage class]];
    
    DFConversation *con;
    
    if (adapter != nil) {
        con = [adapter getMongoConversation:conversation];
    }else{
        con = [[DFConversation alloc] init];
        con.targetId = conversation.targetId;
        //con.title = conversation.conversationTitle;
        con.unreadCount = conversation.unreadMessageCount;
        con.updateTime = conversation.sentTime;
        con.subTitle = @"客户端不支持此消息";
    }
    
    con.type = [self getMongoType:conversation.conversationType];
    return con;
    
}



-(DFMessage *) getMongoMessage:(RCMessage *)msg
{
    DFMessage *message = [[DFMessage alloc] init];
    
    message.messageId = msg.messageId;
    message.targetId = msg.targetId;
    message.direction = [self getMongoDirection:msg.messageDirection];
    message.senderId = msg.senderUserId;
    message.conversationType = [self getMongoType:msg.conversationType];
    message.receiveStatus = [self getMongoReceiveStatus:msg.receivedStatus];
    message.sendStatus = [self getMongoSendStatus:msg.sentStatus];
    message.receivedTime = msg.receivedTime;
    message.sentTime = msg.sentTime;
    message.contentType = [self getMongoContentType:msg];
    message.messageContent = [self getMongoMessageContent:msg.content];
    message.extra = msg.extra;
    
    return message;
    
}



-(RCConversationType) getRongCloudType:(ConversationType) conversationType{
    RCConversationType type;
    switch (conversationType) {
        case ConversationTypePrivate:
            type = ConversationType_PRIVATE;
            break;
        case ConversationTypeDiscussion:
            type = ConversationType_DISCUSSION;
            break;
        case ConversationTypeGroup:
            type = ConversationType_GROUP;
            break;
        case ConversationTypeRoom:
            type = ConversationType_CHATROOM;
            break;
        case ConversationTypeSystem:
            type = ConversationType_SYSTEM;
            break;
        default:
            break;
    }
    return type;
    
}

-(ConversationType) getMongoType:(RCConversationType) conversationType{
    ConversationType type;
    switch (conversationType) {
        case ConversationType_PRIVATE:
            type = ConversationTypePrivate;
            break;
        case ConversationType_DISCUSSION:
            type = ConversationTypeDiscussion;
            break;
        case ConversationType_GROUP:
            type = ConversationTypeGroup;
            break;
        case ConversationType_CHATROOM:
            type = ConversationTypeRoom;
            break;
        case ConversationType_SYSTEM:
            type = ConversationTypeSystem;
            break;
        default:
            break;
    }
    return type;
    
}

-(MessageReceiveStatus) getMongoReceiveStatus:(RCReceivedStatus) receiveStatus{
    MessageReceiveStatus status;
    switch (receiveStatus) {
        case ReceivedStatus_READ:
            status = MessageReceiveStatusRead;
            break;
        case ReceivedStatus_UNREAD:
            status = MessageReceiveStatusUnread;
            break;
        default:
            break;
    }
    return status;
}

-(RCReceivedStatus) getRongCloudReceiveStatus:(MessageReceiveStatus) receiveStatus{
    RCReceivedStatus status;
    switch (receiveStatus) {
        case MessageReceiveStatusRead:
            status = ReceivedStatus_READ;
            break;
        default:
            break;
    }
    return status;
}


-(MessageSendStatus) getMongoSendStatus:(RCSentStatus) sentStatus{
    MessageSendStatus status;
    switch (sentStatus) {
        case SentStatus_SENDING:
            status = MessageSendStatusSending;
            break;
        case SentStatus_SENT:
            status = MessageSendStatusSent;
            break;
        case SentStatus_FAILED:
            status = MessageSendStatusFailed;
            break;
        default:
            break;
    }
    return status;
}



-(NSString *) getMongoContentType:(RCMessage *) message{
    
    RongCloudToMongoMessageContentAdapter *adapter = [self getRongCloudAdapter:[message.content class]];
    
    //如果无法解析消息 用消息提示: 客户端暂不支持此消息
    if (adapter == nil) {
        return MessageContentTypeInfoNotify;
    }else{
        return [adapter getMongoMessageType];
    }
}

-(DFMessageContent *) getMongoMessageContent:(RCMessageContent *) content
{
    RongCloudToMongoMessageContentAdapter *adapter = [self getRongCloudAdapter:[content class]];
    
    //如果无法解析消息 用消息提示: 客户端暂不支持此消息
    if (adapter == nil) {
        DFInfoNotifyMessageContent *infoContent = [[DFInfoNotifyMessageContent alloc] init];
        infoContent.content = @"客户端暂不支持此消息";
        return infoContent;
    }else{
        return [adapter getMongoMessageContent:content];
    }
    
}

-(RCMessageContent *) getRongCloudMessageContent:(DFMessage *) message
{
    MongoToRongCloudMessageContentAdapterManager *manager = [MongoToRongCloudMessageContentAdapterManager sharedInstance];
    MongoToRongCloudMessageContentAdapter *adapter = [manager getAdapter:[message.messageContent class]];
    
    if (adapter != nil) {
        return [adapter getRongCloudMessageContent:message.messageContent];
    }
    
    return nil;
}


-(MessageDirection) getMongoDirection:(RCMessageDirection)direction
{
    if (direction == MessageDirection_SEND) {
        return MessageDirectionSend;
    }else{
        return MessageDirectionReceive;
    }
}



#pragma mark - RCIMClientReceiveMessageDelegate

-(void)onReceived:(RCMessage *)message left:(int)nLeft object:(id)object
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        DFMessage *mongoMessage = [self getMongoMessage:message];
        NSDictionary *dic = @{@"message": mongoMessage};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_MESSAGE_RECEIVED object:nil userInfo:dic];
        
        
    });
}


-(void)onConnectionStatusChanged:(RCConnectionStatus)status
{
    CONNECTION_STATUS connectionStatus;
    
    switch (status) {
        case ConnectionStatus_Connected:
            connectionStatus = RUNNING;
            break;
        case ConnectionStatus_Connecting:
            connectionStatus = CONNECTING;
            break;
        case ConnectionStatus_Unconnected:
            connectionStatus = CLOSED;
            break;
        default:
            break;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = @{@"status": [NSNumber numberWithInt:connectionStatus]};
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_CONNETION_STATUS_CHANGED object:nil userInfo:dic];
    });
    
    
}
@end
