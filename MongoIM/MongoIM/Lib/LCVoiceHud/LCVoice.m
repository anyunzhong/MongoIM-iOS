//
//  LCVoice.m
//  LCVoiceHud
//
//  Created by 郭历成 on 13-6-21.
//  Contact titm@tom.com
//  Copyright (c) 2013年 Wuxiantai Developer Team.(http://www.wuxiantai.com) All rights reserved.
//

#import "LCVoice.h"
#import <AVFoundation/AVFoundation.h>

#pragma mark - <DEFINES>

#define WAVE_UPDATE_FREQUENCY   0.05

#pragma mark - <CLASS> LCVoice

@interface LCVoice () <AVAudioRecorderDelegate>
{
    NSTimer * timer_;
}

@property(nonatomic,retain) AVAudioRecorder * recorder;

@end

@implementation LCVoice

-(void) dealloc{
    
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
    self.recordPath = nil;
}

#pragma mark - Publick Function

-(void)startRecordWithPath:(NSString *)path
{
    NSError * err = nil;
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory :AVAudioSessionCategoryPlayAndRecord error:&err];
    
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    [audioSession setActive:YES error:&err];
    
    err = nil;
    if(err){
        NSLog(@"audioSession: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
//    NSMutableDictionary * recordSettings = [NSMutableDictionary dictionary];
//    
//    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
//    [recordSettings setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
//    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
//    [recordSettings setValue:[NSNumber numberWithInt:AVAudioQualityLow] forKey:AVEncoderAudioQualityKey];
    
    
    NSDictionary *recordSettings = @{AVFormatIDKey: @(kAudioFormatLinearPCM),
                               AVSampleRateKey: @8000.00f,
                               AVNumberOfChannelsKey: @1,
                               AVLinearPCMBitDepthKey: @16,
                               AVLinearPCMIsNonInterleaved: @NO,
                               AVLinearPCMIsFloatKey: @NO,
                               AVLinearPCMIsBigEndianKey: @NO};
    
    self.recordPath = path;
    NSURL * url = [NSURL fileURLWithPath:self.recordPath];
    
    err = nil;
    
    NSData * audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    
    if(audioData)
    {
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm removeItemAtPath:[url path] error:&err];
    }
    
    err = nil;
    
    if(self.recorder){[self.recorder stop];self.recorder = nil;}
    
    self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&err];
    
    if(!_recorder){
        NSLog(@"recorder: %@ %ld %@", [err domain], (long)[err code], [[err userInfo] description]);
        return;
    }
    
    [_recorder setDelegate:self];
    [_recorder prepareToRecord];
    _recorder.meteringEnabled = YES;
    
    BOOL audioHWAvailable = audioSession.inputAvailable;
    if (! audioHWAvailable) {
        return;
    }
    
    [_recorder recordForDuration:(NSTimeInterval) 600];
    
    self.recordTime = 0;
    [self resetTimer];
    
    timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
}

-(void) stopRecordWithCompletionBlock:(void (^)())completion
{
    dispatch_async(dispatch_get_main_queue(),completion);
    
    [self resetTimer];
}

#pragma mark - Timer Update

- (void)updateMeters {
    
    self.recordTime += WAVE_UPDATE_FREQUENCY;
    if (_recorder) {
        [_recorder updateMeters];
    }
    
    float peakPower = [_recorder averagePowerForChannel:0];
    double ALPHA = 0.05;
    double peakPowerForChannel = pow(10, (ALPHA * peakPower));
    NSUInteger level = 0;
    
    //NSLog(@"level: %f" , peakPowerForChannel/0.1);
    
    level = ceil(peakPowerForChannel/0.1);
    
    if (_delegate != nil && [_delegate respondsToSelector:@selector(updateVoiceLevel:)]) {
        [_delegate updateVoiceLevel:level];
    }
    
}

#pragma mark - Helper Function


-(void) resetTimer
{
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

-(void) cancelRecording
{
    if (self.recorder.isRecording) {
        [self.recorder stop];
    }
    
    self.recorder = nil;
}

- (void)cancelled {
    
    [self resetTimer];
    [self cancelRecording];
}

@end
