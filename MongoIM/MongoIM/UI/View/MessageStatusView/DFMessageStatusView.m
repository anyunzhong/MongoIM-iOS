//
//  DFMessageStatusView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFMessageStatusView.h"

#define IndicatorViewSize 20
#define FailImageViewSize 20



@interface DFMessageStatusView()

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) UIImageView *failImageView;

@end


@implementation DFMessageStatusView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

-(void) initView
{
    CGFloat x, y;
    x = (CGRectGetWidth(self.frame) - IndicatorViewSize)/2;
    y = (CGRectGetHeight(self.frame) - IndicatorViewSize)/2;
    if (_indicatorView == nil) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, IndicatorViewSize, IndicatorViewSize)];
        [self addSubview:_indicatorView];
        _indicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    }
    
    x = (CGRectGetWidth(self.frame) - FailImageViewSize)/2;
    y = (CGRectGetHeight(self.frame) - FailImageViewSize)/2;
    if (_failImageView == nil) {
        _failImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, FailImageViewSize, FailImageViewSize)];
        _failImageView.image = [UIImage imageNamed:@"MessageSendFail"];
        _failImageView.hidden = YES;
        [self addSubview:_failImageView];
    }

}


-(void)changeStatus:(MessageSendStatus)status
{
    if (status == MessageSendStatusSending) {
        [_indicatorView startAnimating];
    }else{
        [_indicatorView stopAnimating];
    }
    
    _failImageView.hidden = status == MessageSendStatusFailed ? NO:YES;
}
@end
