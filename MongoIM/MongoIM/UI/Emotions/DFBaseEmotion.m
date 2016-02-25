//
//  DFBaseEmotion.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseEmotion.h"

@interface DFBaseEmotion()


@end


@implementation DFBaseEmotion

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tabIconLocal = @"";
        _pages = 0;
        _total = 0;
        _xOffset = 0.0;
        _pageIndexOffset=0;
    }
    return self;
}

-(UIView *)getView
{
    return nil;
}
@end
