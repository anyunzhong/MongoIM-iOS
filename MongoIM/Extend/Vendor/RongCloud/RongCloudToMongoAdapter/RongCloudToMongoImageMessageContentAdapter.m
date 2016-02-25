//
//  RongCloudToMongoImageMessageContentAdapter.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RongCloudToMongoImageMessageContentAdapter.h"
#import "DFImageMessageContent.h"
#import "Key.h"

@implementation RongCloudToMongoImageMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCImageMessage *)imageMessage
{
    DFImageMessageContent *messageContent = [[DFImageMessageContent alloc] init];
    
    messageContent.thumbImage = imageMessage.thumbnailImage;
    
    //图像数据
    NSString *url = imageMessage.imageUrl;
    if (url != nil) {
        if ([url hasPrefix:@"http://"]) {
            //远程发的
            messageContent.url = url;
        }else{
            //本地发的为本地地址
            NSData *data  = [NSData dataWithContentsOfFile:url];
            UIImage *image = [UIImage imageWithData:data];
            messageContent.originImage = image;
        }
    }
    //messageContent.url = imageMessage.imageUrl;
    return messageContent;
    
}

-(NSString *)getMongoMessageType
{
    return MessageContentTypeImage;
}

-(NSString *)getConversationSubTitle:(RCImageMessage *)imageMessage
{
    return @"[图片]";
}


//图片消息发送 特殊处理
-(void)sendMessage:(DFMessage *)message type:(RCConversationType)type content:(RCMessageContent *)content
{
    RCMessage *msg = [[RCIMClient sharedRCIMClient] sendImageMessage:type targetId:message.targetId content:content pushContent:nil progress:^(int progress, long messageId) {
        NSLog(@"上传进度：%d", progress);
        
    } success:^(long messageId) {
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
