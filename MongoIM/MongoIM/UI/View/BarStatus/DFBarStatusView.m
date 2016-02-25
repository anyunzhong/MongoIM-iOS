//
//  DFMessageStatusView.m
//  coder
//
//  Created by Allen Zhong on 15/5/14.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBarStatusView.h"

#define LabelFont [UIFont boldSystemFontOfSize:18]
@interface DFBarStatusView()

@property (nonatomic,strong) UILabel *stateLabel;
@property (nonatomic,strong) UILabel *stateAnimateLabel;
@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;


@end

@implementation DFBarStatusView

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
    CGFloat x,y = 0.0,width,height = 0.0;
    
    if (_stateLabel == nil) {
        x = 0;
        y = 0;
        width = self.frame.size.width;
        height = self.frame.size.height;
        _stateLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _stateLabel.textColor = [UIColor whiteColor];
        _stateLabel.font  = LabelFont;
        _stateLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_stateLabel];
        _stateLabel.text =@"消息";
        _stateLabel.hidden = NO;
        //_stateLabel.backgroundColor = [UIColor redColor];
    }
    
    if (_indicatorView == nil) {
        x = 0;
        width = height;
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self addSubview:_indicatorView];
        _indicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleWhite;
        _indicatorView.hidden = YES;
    }
    
    if (_stateAnimateLabel == nil) {
        x = CGRectGetMaxX(_indicatorView.frame) +5;
        width = self.frame.size.width - x;
        _stateAnimateLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _stateAnimateLabel.textColor = [UIColor whiteColor];
        _stateAnimateLabel.font  = LabelFont;
        _stateAnimateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_stateAnimateLabel];
        _stateAnimateLabel.hidden = YES;
    }
    
}

-(void)changeStatus:(CONNECTION_STATUS)status
{
    switch (status) {
            
            case CLOSED:
            [self showAnimateView:NO];
            _stateLabel.text = @"未连接";
            break;
            case CONNECTING:
            [self showAnimateView:YES];
            _stateAnimateLabel.text = @"连接中...";
            break;
            case CLOSING:
            [self showAnimateView:YES];
            _stateAnimateLabel.text = @"关闭中...";
            break;
            case RUNNING:
        {
            [self showAnimateView:NO];
            _stateLabel.text = @"消息";
            
            break;
        }
            case FETCHING:
            [self showAnimateView:YES];
            _stateAnimateLabel.text = @"收取中...";
            break;
            
            case FETCHED:
        {
            [self showAnimateView:NO];
            _stateLabel.text = @"消息";
            break;
        }
            
        default:
        
            break;
    }
    
}

-(void) showAnimateView:(BOOL) show
{
    _stateLabel.hidden = show;
    _stateAnimateLabel.hidden = !show;
    _indicatorView.hidden = !show;
}

-(void)setUnreadCount:(NSUInteger)unreadCount
{
    if (unreadCount > 0) {
        _stateLabel.text = [NSString stringWithFormat:@"消息(%lu)",(unsigned long)unreadCount];
    }else{
        _stateLabel.text = @"消息";
    }
}
@end
