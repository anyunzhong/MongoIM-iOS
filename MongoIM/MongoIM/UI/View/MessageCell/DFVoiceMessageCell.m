//
//  DFTempVoiceMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/28.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFVoiceMessageCell.h"

#import "DFVoiceBubbleView.h"

#import "DFVoicePlayView.h"

#import "DFVoiceMessageContent.h"


#define VoiceBubbleHeight 60

#define PlayIconSize 22
#define PlayIconPadding 18

#define LengthLabelHeight 20;
#define LengthLabelWidth 20;



@interface DFVoiceMessageCell()

@property (strong,nonatomic) DFVoiceBubbleView *bubbleView;

@property (strong,nonatomic) DFVoicePlayView *playingView;

@property (strong,nonatomic) UILabel *lengthLabel;

@end


@implementation DFVoiceMessageCell

#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

-(void) initCell
{
    if (_bubbleView == nil) {
        _bubbleView = [[DFVoiceBubbleView alloc] initWithFrame:CGRectZero];
        [self.messageContentView addSubview:_bubbleView];
        //_bubbleView.backgroundColor = [UIColor darkGrayColor];
    }
    
    if (_playingView == nil) {
        _playingView = [[DFVoicePlayView alloc] initWithFrame:CGRectZero];
        [_bubbleView addSubview:_playingView];
    }
    
    if (_lengthLabel == nil) {
        _lengthLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _lengthLabel.textColor = [UIColor lightGrayColor];
        _lengthLabel.font = [UIFont systemFontOfSize:14];
        [self.messageContentView addSubview:_lengthLabel];
    }
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    CGFloat x, y ,width ,height;
    
    
    DFVoiceMessageContent *voiceMessage = (DFVoiceMessageContent *)message.messageContent;
    
    //气泡
    width = [self getVoiceMessageBubbleWidth:voiceMessage];
    height = VoiceBubbleHeight;
    
    y= 0;
    x=0;
    if (self.isSender) {
        x = LengthLabelWidth;
    }
    if (self.isSender) {
        _bubbleView.direction = BubbleDirectionRight;
    }else{
        _bubbleView.direction = BubbleDirectionLeft;
    }
    _bubbleView.frame = CGRectMake(x, y, width, height);
    
    
    x=0;
    y=0;
    height = height - 10;
    width = width - 10;
    _playingView.frame = CGRectMake(x, y, width, height);
    [_playingView updateWithVoiceMessage:message];
    
    y = 20;
    height = LengthLabelHeight;
    width = LengthLabelWidth;
    
    if (self.isSender) {
        x = 0;
    }else{
        x = CGRectGetWidth(_bubbleView.frame);
    }
    _lengthLabel.text = [NSString stringWithFormat:@"%lu''", (unsigned long)voiceMessage.duration];
    _lengthLabel.frame = CGRectMake(x, y, width, height);

    
    
}

-(CGSize)getMessageContentViewSize
{
    DFVoiceMessageContent *voiceMessage = (DFVoiceMessageContent *)self.message.messageContent;
    
    CGFloat width = [self getVoiceMessageBubbleWidth:voiceMessage]+LengthLabelWidth; //加语音长度label
    
    return CGSizeMake(width, VoiceBubbleHeight);
    
}

-(CGFloat) getVoiceMessageBubbleWidth:(DFVoiceMessageContent *) voiceMessage
{
    if (voiceMessage.bubbleWidth !=0) {
        return voiceMessage.bubbleWidth;
    }
    CGFloat width = BubbleContentPadding + voiceMessage.duration*20;
    if (width < 70) {
        width = 70;
    }
    if (width > MaxBubbleWidth) {
        width = MaxBubbleWidth - 40;
    }
    
    voiceMessage.bubbleWidth = width;
    
    return width;
}


-(CGFloat)getCellHeight:(DFMessage *)message
{
    return VoiceBubbleHeight + [super getCellHeight:message];
}




#pragma mark - Method


-(void)onMenuShow:(BOOL)show
{
    _bubbleView.selected = show;
}


#pragma mark - DFBaseBubbleViewDelegate

@end
