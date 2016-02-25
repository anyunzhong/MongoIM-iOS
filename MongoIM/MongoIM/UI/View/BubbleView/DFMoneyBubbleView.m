//
//  DFTextBubbleView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/24.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFMoneyBubbleView.h"

@implementation DFMoneyBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(NSString *) getBgPath:(BubbleDirection)direction
{
    if (direction == BubbleDirectionRight) {
        return @"c2cSenderMsgNodeBG";
    }else{
        return @"c2cReceiverMsgNodeBG";
    }
}

-(NSString *) getSelectedBgPath:(BubbleDirection)direction
{
    if (direction == BubbleDirectionRight) {
        return @"c2cSenderMsgNodeBG_HL";
    }else{
        return @"c2cReceiverMsgNodeBG_HL";
    }
}

@end
