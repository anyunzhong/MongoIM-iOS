//
//  DFRecorderHUD.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/26.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFRecorderHUD.h"


#define RecorderHeight 100
#define RecorderWidth 62

#define SignalHeight 100
#define SignalWidth 38

#define RecorderPadding 10

#define TipLabelHeight 25
#define TipLabelMargin 5

#define CancelViewSize 100

@interface DFRecorderHUD()

@property (strong, nonatomic) UIView *hud;

@property (strong, nonatomic) UIImageView *recorderView;

@property (strong, nonatomic) UIImageView *cancelView;

@property (strong, nonatomic) UIImageView *signalView;

@property (strong, nonatomic) UILabel *tipLabel;

@property (strong, nonatomic) NSMutableArray *signalImageArray;


@end

@implementation DFRecorderHUD


#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        [self initSignalImages];
        [self setHudState:RecorderHudStateNormal];
    }
    return self;
}

-(void) initView
{
    CGFloat x,y,width,height;
    x=0;
    y=0;
    width=self.frame.size.width;
    height=self.frame.size.height;
    
    if (_hud == nil) {
        _hud = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
        _hud.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.9];
        _hud.layer.cornerRadius = 5;
        [self addSubview:_hud];
    }
    
    CGFloat totalWidth = RecorderWidth + SignalWidth + RecorderPadding;
    
    x = (self.frame.size.width -totalWidth)/2;
    y = x;
    width = RecorderWidth;
    height = RecorderHeight;
    
    if (_recorderView == nil) {
        _recorderView = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,width,height)];
        [self addSubview:_recorderView];
        _recorderView.image = [UIImage imageNamed:@"RecordingBkg"];
    }
    
    x = CGRectGetMaxX(_recorderView.frame) + RecorderPadding;
    width = SignalWidth;
    height = SignalHeight;
    if (_signalView == nil) {
        _signalView = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,width,height)];
        [self addSubview:_signalView];
    }
    
    
    x = TipLabelMargin;
    y = self.frame.size.height - TipLabelHeight- TipLabelMargin;
    width = self.frame.size.width - 2 * TipLabelMargin;
    height = TipLabelHeight;
    if (_tipLabel == nil) {
        _tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(x,y,width,height)];
        _tipLabel.font = [UIFont systemFontOfSize:14];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor whiteColor];
        _tipLabel.layer.cornerRadius = 5;
        _tipLabel.layer.masksToBounds = YES;
        [self addSubview:_tipLabel];
    }
    
    x = (self.frame.size.width - CancelViewSize)/2;
    y = x;
    width = CancelViewSize;
    height = width;
    if (_cancelView == nil) {
        _cancelView = [[UIImageView alloc] initWithFrame:CGRectMake(x,y,width,height)];
        [self addSubview:_cancelView];
        _cancelView.image = [UIImage imageNamed:@"RecordCancel"];
    }
    
}


-(void) initSignalImages
{
    _signalImageArray = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"RecordingSignal00%d",i]];
        [_signalImageArray addObject:image];
    }
}

#pragma mark - Method


-(void)setSignalLevel:(NSUInteger) signalLevel
{
    if (signalLevel == 0 || signalLevel > 8) {
        return;
    }
    
    UIImage *image = [_signalImageArray objectAtIndex:signalLevel];
    _signalView.image = image;
    
}

-(void)setHudState:(RecorderHudState) hudState
{
    switch (hudState) {
        case RecorderHudStateNormal:{
            
            _recorderView.hidden = NO;
            _signalView.hidden = NO;
            _cancelView.hidden = YES;
            _tipLabel.backgroundColor = [UIColor clearColor];
            _tipLabel.text = @"手指上滑, 取消发送";
            
            break;
        }
        case RecorderHudStateCancel:{
            
            _recorderView.hidden = YES;
            _signalView.hidden = YES;
            _cancelView.hidden = NO;
            _tipLabel.backgroundColor = [UIColor colorWithRed:159/255.0 green:45/255.0 blue:0 alpha:1.0];
            _tipLabel.text = @"松开手指, 取消发送";
            
            break;
        }

        default:
            break;
    }
}

@end
