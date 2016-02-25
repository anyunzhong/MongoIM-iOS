//
//  DFFavouritePlugin.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/8.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFFavouritePlugin.h"

@interface DFFavouritePlugin()

@end

@implementation DFFavouritePlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_myfav";
        self.name = @"收藏";
    }
    return self;
}

@end
