//
//  RCShortVideoMessage.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RCShortVideoMessage.h"
#import "MessageContentType.h"
#import "NSDictionary+JSON.h"

@implementation RCShortVideoMessage

-(NSData *)encode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_cover forKey:@"cover"];
    [dic setObject:_url forKey:@"url"];

    return [NSDictionary dic2jsonData:dic];
}

-(void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    _cover = [dic objectForKey:@"cover"];
    _url = [dic objectForKey:@"url"];
}

+(NSString *)getObjectName
{
    return RCMessageContentTypeShortVideo;
}


+(RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}


@end
