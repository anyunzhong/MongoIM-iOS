//
//  RCShareMessage.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/8.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RCShareMessage.h"
#import "MessageContentType.h"
#import "NSDictionary+JSON.h"

@implementation RCShareMessage

-(NSData *)encode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_title forKey:@"title"];
    [dic setObject:_desc forKey:@"desc"];
    [dic setObject:_link forKey:@"link"];
    [dic setObject:_thumb forKey:@"thumb"];
    [dic setObject:_sourceLogo forKey:@"sourceLogo"];
    [dic setObject:_sourceName forKey:@"sourceName"];
    
    return [NSDictionary dic2jsonData:dic];
}

-(void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    _title = [dic objectForKey:@"title"];
    _desc = [dic objectForKey:@"desc"];
    _link = [dic objectForKey:@"link"];
    _thumb = [dic objectForKey:@"thumb"];
    _sourceLogo = [dic objectForKey:@"sourceLogo"];
    _sourceName = [dic objectForKey:@"sourceName"];
}

+(NSString *)getObjectName
{
    return RCMessageContentTypeShare;
}


+(RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}


@end
