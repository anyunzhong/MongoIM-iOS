//
//  RCNameCardMessage.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "RCNameCardMessage.h"
#import "NSDictionary+JSON.h"
#import "MessageContentType.h"

@implementation RCNameCardMessage

-(NSData *)encode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_userId forKey:@"userId"];
    [dic setObject:_userNick forKey:@"userNick"];
    [dic setObject:_userNum forKey:@"userNum"];
    [dic setObject:_userAvatar forKey:@"userAvatar"];
    
    return [NSDictionary dic2jsonData:dic];
}

-(void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    _userId = [dic objectForKey:@"userId"];
    _userNick = [dic objectForKey:@"userNick"];
    _userNum = [dic objectForKey:@"userNum"];
    _userAvatar = [dic objectForKey:@"userAvatar"];
}

+(NSString *)getObjectName
{
    return RCMessageContentTypeNameCard;
}


+(RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}


@end
