//
//  DFMessageStorageService.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMessageStorageService.h"

#import "DFMessageContentManager.h"

#define TABLE_SQL @"CREATE TABLE IF NOT EXISTS message(message_id INTEGER PRIMARY KEY AUTOINCREMENT,target_id VARCHAR (64) NOT NULL,sender_id VARCHAR (64),conversation_type SMALLINT,message_direction SMALLINT,receive_status SMALLINT DEFAULT 0,receive_time INTEGER,send_time INTEGER,send_status SMALLINT DEFAULT 0,content_type VARCHAR (64),content TEXT,extra_column1 INTEGER DEFAULT 0,extra_column2 INTEGER DEFAULT 0,extra_column3 TEXT,extra_column4 TEXT);CREATE INDEX IF NOT EXISTS idx_message ON message (target_id, conversation_type, send_time);"

@implementation DFMessageStorageService


static  DFMessageStorageService *_service=nil;

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_service == nil) {
            _service = [[DFMessageStorageService alloc] init];
        }
    }
    return _service;
}



- (instancetype)init
{
    self = [super init];
    if (self) {
        //[self executeUpdate:@"drop table private_chat" params:nil];
        [self executeUpdate:TABLE_SQL params:nil];
    }
    return self;
}



-(void)insertMessage:(DFMessage *)message
{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:message.targetId forKey:@"targetId"];
    [params setObject:message.senderId forKey:@"senderId"];
    [params setObject:[NSNumber numberWithUnsignedInteger:message.direction] forKey:@"messageDirection"];
    [params setObject:[NSNumber numberWithUnsignedInteger:message.conversationType] forKey:@"conversationType"];
    [params setObject:[NSNumber numberWithUnsignedInteger:message.receiveStatus] forKey:@"receiveStatus"];
    [params setObject:[NSNumber numberWithUnsignedLongLong:message.receivedTime] forKey:@"receiveTime"];
    [params setObject:[NSNumber numberWithUnsignedInteger:message.sendStatus] forKey:@"sendStatus"];
    [params setObject:[NSNumber numberWithUnsignedLongLong:message.sentTime] forKey:@"sendTime"];
    [params setObject:message.contentType forKey:@"contentType"];
    [params setObject:[message.messageContent toJson] forKey:@"content"];
    
    NSString *sql = @"INSERT INTO message(target_id,sender_id, message_direction, conversation_type, receive_status, receive_time, send_status, send_time, content_type, content) VALUES(:targetId, :senderId,:messageDirection,:conversationType,:receiveStatus,:receiveTime, :sendStatus,:sendTime,:contentType,:content)";
    
    [self executeUpdate:sql params:params];
    
}


-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size
{
    NSMutableArray *messages = [NSMutableArray array];
    
    NSString *sql = @"SELECT * from message WHERE conversation_type=:conversationType AND target_id=:targetId and message_id < :start ORDER BY message_id DESC limit :size";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:targetId forKey:@"targetId"];
    [params setObject:[NSNumber numberWithUnsignedInteger:type] forKey:@"conversationType"];
    [params setObject:[NSNumber numberWithUnsignedInteger:start] forKey:@"start"];
    [params setObject:[NSNumber numberWithUnsignedInteger:size] forKey:@"size"];
    

    FMResultSet *rs = [self executeQuery:sql params:params];
    while ([rs next]) {
        DFMessage *message = [[DFMessage alloc] init];
        message.messageId = [rs intForColumn:@"message_id"];
        message.targetId = [rs stringForColumn:@"target_id"];
        message.senderId = [rs stringForColumn:@"sender_id"];
        message.conversationType = type;
        
        message.direction = [rs intForColumn:@"message_direction"];
        
    
        message.sendStatus = [rs intForColumn:@"send_status"];
        message.sentTime = [rs longLongIntForColumn:@"send_time"];
        
        message.receiveStatus = [rs intForColumn:@"receive_status"];
        message.receivedTime = [rs longLongIntForColumn:@"receive_time"];
        
        message.contentType = [rs stringForColumn:@"content_type"];
        
        NSString *content = [rs stringForColumn:@"content"];
        
        DFMessageContent *messageContent = [[DFMessageContentManager sharedInstance] create:message.contentType];
        [messageContent decode:[content dataUsingEncoding:NSUTF8StringEncoding]];
        message.messageContent = messageContent;
        
    
        [messages addObject:message];
    }
    
    [self closeSession];
    
    return messages;
}

@end
