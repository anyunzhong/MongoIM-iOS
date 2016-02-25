//
//  MIMessage.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "DFConversation.h"
#import "DFMessageContent.h"

typedef NS_ENUM(NSUInteger, MessageDirection){
    MessageDirectionSend=1,
    MessageDirectionReceive=2,
};


typedef NS_ENUM(NSUInteger, MessageSendStatus){
    MessageSendStatusSending=1,
    MessageSendStatusFailed=2,
    MessageSendStatusSent=3,
};


typedef NS_ENUM(NSUInteger, MessageReceiveStatus){
    MessageReceiveStatusUnread=0,
    MessageReceiveStatusRead=1,
    MessageReceiveStatusListened=2,
    MessageReceiveStatusDownloaded=4,
};


@interface DFMessage : NSObject

@property (nonatomic, assign) NSUInteger messageId;
@property (nonatomic, strong) NSString *targetId;
@property (assign, nonatomic) MessageDirection direction;
@property (strong, nonatomic) NSString *senderId;
@property (assign, nonatomic) ConversationType conversationType;
@property (assign, nonatomic) MessageReceiveStatus receiveStatus;
@property (assign, nonatomic) MessageSendStatus sendStatus;
@property (assign, nonatomic) long long receivedTime;
@property (assign, nonatomic) long long sentTime;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) DFMessageContent *messageContent;
@property (nonatomic, strong) NSString *extra;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, assign) BOOL showUserNick;
@property (assign, nonatomic) NSInteger rowIndex;
@property (assign, nonatomic) CGFloat cellHeight;


@end
