//
//  MIVoiceMessageContent.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFVoiceMessageContent.h"

@implementation DFVoiceMessageContent

-(NSData *)encode
{
    return nil;
}

-(void)decode:(NSData *)data
{
    //NSDictionary *dic = [NSDictionary jsonData2Dic:data];
}

-(NSString *)toJson
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:[NSNumber numberWithUnsignedInteger:_duration] forKey:@"duration"];
    
    //取得base64
    //TODO ========
    
    
    return [NSDictionary dic2jsonString:dic];
}



@end
