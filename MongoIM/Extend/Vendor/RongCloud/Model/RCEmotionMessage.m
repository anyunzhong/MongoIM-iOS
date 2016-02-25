//
//  RCEmotionMessage.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/11.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RCEmotionMessage.h"
#import "NSDictionary+JSON.h"
#import "MessageContentType.h"

@implementation RCEmotionMessage

-(NSData *)encode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_name forKey:@"name"];
    [dic setObject:_remoteGif forKey:@"remoteGif"];
    [dic setObject:_remoteThumb forKey:@"remoteThumb"];
    [dic setObject:_localGif forKey:@"localGif"];
    [dic setObject:_localThumb forKey:@"localThumb"];
    
    return [NSDictionary dic2jsonData:dic];
}

-(void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    _name = [dic objectForKey:@"name"];
    _remoteThumb = [dic objectForKey:@"remoteThumb"];
    _remoteGif = [dic objectForKey:@"remoteGif"];
    _localThumb = [dic objectForKey:@"localThumb"];
    _localGif = [dic objectForKey:@"localGif"];
}

+(NSString *)getObjectName
{
    return RCMessageContentTypeEmotion;
}


+(RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}


@end
