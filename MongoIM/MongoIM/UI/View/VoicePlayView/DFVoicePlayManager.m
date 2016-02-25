//
//  DFVoicePlayManager.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/5/23.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFVoicePlayManager.h"
#import <AVFoundation/AVFoundation.h>
#import "DFVoiceMessageContent.h"

@interface DFVoicePlayManager()<AVAudioPlayerDelegate>

@property (nonatomic, strong) DFVoicePlayView *previousView;

@property (nonatomic, strong) AVAudioPlayer *player;

@end


@implementation DFVoicePlayManager

static  DFVoicePlayManager *_manager=nil;

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFVoicePlayManager alloc] init];
        }
    }
    return _manager;
}


-(void)play:(DFVoicePlayView *)view message:(DFMessage *)message
{
    DFVoiceMessageContent *voiceMessage = (DFVoiceMessageContent *)message.messageContent;
    
    if (_previousView != nil && view != _previousView) {
        [_previousView stopPlaying];
    }
    _previousView = view;
    
    
//    [[AFSoundManager sharedManager] startStreamingRemoteAudioFromURL:voiceMessage.url andBlock:^(NSInteger percentage, CGFloat elapsedTime, CGFloat timeRemaining, NSError *error, BOOL finished) {
//        if (finished) {
//            [_previousView stopPlaying];
//        }
//    } isFileChanged:YES];
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];

    
    _player = [[AVAudioPlayer alloc] initWithData:voiceMessage.wavAudioData error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    [_player play];
}

-(void)stopPlay
{
    //[[AFSoundManager sharedManager] stop];
    
    [_player stop];
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    [_previousView stopPlaying];
}


@end
