//
//  DFNameCardPlugin.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFNameCardPlugin.h"

@implementation DFNameCardPlugin
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_friendcard";
        self.name = @"名片";
    }
    return self;
}
@end
