//
//  MIConversation.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, ConversationType){
    ConversationTypePrivate=1,
    ConversationTypeDiscussion=2,
    ConversationTypeGroup=3,
    ConversationTypeRoom=4,
    ConversationTypeSystem=5,
};

@interface DFConversation : NSObject

@property (strong, nonatomic) NSString *targetId;
@property (assign, nonatomic) ConversationType type;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *subTitle;
@property (assign, nonatomic) NSUInteger unreadCount;
@property (assign, nonatomic) long long updateTime;

@end
