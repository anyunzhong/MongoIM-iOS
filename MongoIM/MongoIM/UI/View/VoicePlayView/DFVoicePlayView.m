//
//  DFVoicePlayView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/5/23.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFVoicePlayView.h"

#import "DFVoicePlayManager.h"

#define PlayIconSize 22
#define PlayIconPadding 18


@interface DFVoicePlayView()

@property (strong,nonatomic) UIImageView *playingView;

@property (strong, nonatomic) NSArray *sendImagesArray;
@property (strong, nonatomic) NSArray *receiveImagesArray;


@property (assign, nonatomic) BOOL isPlaying;

@property (strong, nonatomic) DFMessage *message;

@end



@implementation DFVoicePlayView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
        
        _isPlaying = NO;
        
        _sendImagesArray = [NSArray arrayWithObjects:
         [UIImage imageNamed:@"SenderVoiceNodePlaying001"],
         [UIImage imageNamed:@"SenderVoiceNodePlaying002"],
         [UIImage imageNamed:@"SenderVoiceNodePlaying003"],nil];
        _receiveImagesArray = [NSArray arrayWithObjects:
         [UIImage imageNamed:@"ReceiverVoiceNodePlaying001"],
         [UIImage imageNamed:@"ReceiverVoiceNodePlaying002"],
         [UIImage imageNamed:@"ReceiverVoiceNodePlaying003"],nil];
    }
    return self;
}


-(void) initView
{
    
    [self addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    
    if (_playingView == nil) {
        _playingView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _playingView.animationDuration =1;
        [self addSubview:_playingView];
    }
}

-(void) initPlayingImages
{
    
}


-(void)updateWithVoiceMessage:(DFMessage *)message
{
    _message = message;
    
    CGFloat x, y ,width ,height;
    
    width = PlayIconSize;
    height = width;
    y = 15;
    if (message.direction == MessageDirectionSend) {
        x = self.frame.size.width - width - PlayIconPadding;
        _playingView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    }else{
        x = PlayIconPadding;
        _playingView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    }
    
    _playingView.frame = CGRectMake(x, y, width, height);
}



-(void) onClickButton:(id)sender
{
    
    if (_isPlaying) {
        [self stopPlaying];
    }else{
        [self startPlaying];
    }
}


-(void) startPlaying
{
    _isPlaying = YES;
    
    [[DFVoicePlayManager sharedInstance] play:self message:_message];

    if (_message.direction == MessageDirectionSend) {
        _playingView.animationImages = _sendImagesArray;
    }else{
        _playingView.animationImages = _receiveImagesArray;
    }
    
    [_playingView startAnimating];
    
}

-(void)stopPlaying
{
    _isPlaying = NO;
    
    
    if (_message.direction == MessageDirectionSend) {
        _playingView.image = [UIImage imageNamed:@"SenderVoiceNodePlaying"];
    }else{
        _playingView.image = [UIImage imageNamed:@"ReceiverVoiceNodePlaying"];
    }
    
    [_playingView stopAnimating];
    
    [[DFVoicePlayManager sharedInstance] stopPlay];
    
}
@end
