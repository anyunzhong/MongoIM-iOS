//
//  DFTextBubbleView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/24.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFShareBubbleView.h"

@implementation DFShareBubbleView

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
        return @"SenderAppNodeBkg";
    }else{
        return @"ReceiverAppNodeBkg";
    }
}

-(NSString *)getSelectedBgPath:(BubbleDirection)direction
{
    if (direction == BubbleDirectionRight) {
        return @"SenderAppNodeBkg_HL";
    }else{
        return @"ReceiverAppNodeBkg_HL";
    }
}
@end
