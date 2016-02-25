//
//  MITextMessageContent.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFTextMessageContent.h"

@implementation DFTextMessageContent

-(NSData *)encode
{
    return nil;
}

-(void)decode:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    
    _text = [dic objectForKey:@"text"];
}

-(NSString *)toJson
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_text forKey:@"text"];
    return [NSDictionary dic2jsonString:dic];
}


@end
