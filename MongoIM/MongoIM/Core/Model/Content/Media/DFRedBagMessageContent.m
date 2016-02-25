//
//  DFRedBagMessageContent.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFRedBagMessageContent.h"

@implementation DFRedBagMessageContent

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _desc = @"查看红包";
        _sign = @"红包";
    }
    return self;
}
@end
