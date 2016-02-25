//
//  DFTextBubbleView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/24.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextBubbleView.h"

@implementation DFTextBubbleView

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
        return @"SenderTextNodeBkg";
    }else{
        return @"ReceiverTextNodeBkg";
    }
}

-(NSString *)getSelectedBgPath:(BubbleDirection)direction
{
    if (direction == BubbleDirectionRight) {
        return @"SenderTextNodeBkgHL";
    }else{
        return @"ReceiverTextNodeBkgHL";
    }
}
@end
