//
//  RCRedBagMessage.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RCRedBagMessage.h"
#import "MessageContentType.h"
#import "NSDictionary+JSON.h"

@implementation RCRedBagMessage

-(NSData *)encode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_title forKey:@"title"];
    return [NSDictionary dic2jsonData:dic];
}

-(void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    _title = [dic objectForKey:@"title"];
}

+(NSString *)getObjectName
{
    return RCMessageContentTypeRedBag;
}


+(RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}
@end
