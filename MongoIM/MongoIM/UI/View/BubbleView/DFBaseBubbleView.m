//
//  DFBaseBubbleView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/24.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseBubbleView.h"

@implementation DFBaseBubbleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _bgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:_bgView];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:_contentView];
        //_contentView.backgroundColor =[UIColor yellowColor];
        
        
        

    }
    return self;
}

-(void)layoutSubviews
{
    _bgView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _contentView.frame = CGRectMake(20, 15, self.frame.size.width - BubbleContentPadding , self.frame.size.height - BubbleContentPadding);
}


-(NSString *) getBgPath:(BubbleDirection)direction
{
    return nil;
}

-(NSString *)getSelectedBgPath:(BubbleDirection)direction
{
    return nil;
}

-(void)setDirection:(BubbleDirection)direction
{
    _direction = direction;
    self.selected = NO;
}


-(void)setSelected:(BOOL)selected
{
    UIImage *image = nil;
    if (selected) {
        image = [UIImage imageNamed:[self getSelectedBgPath:_direction]];
    }else{
        image = [UIImage imageNamed:[self getBgPath:_direction]];
    }
    
    if (_direction == BubbleDirectionRight) {
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 14, 30, 20) resizingMode:UIImageResizingModeStretch];
    }else{
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(30, 20, 30, 14) resizingMode:UIImageResizingModeStretch];
    }
    
    _bgView.image = image;
}


@end
