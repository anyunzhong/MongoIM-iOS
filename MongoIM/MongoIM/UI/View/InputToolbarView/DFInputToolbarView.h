//
//  DFInputToolbarView.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/17.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define BtnSize 35


//整个输入栏状态
typedef NS_ENUM(NSUInteger, InputToolbarState){
    InputToolbarStateNone,
    InputToolbarStateText,
    InputToolbarStateVoice,
    InputToolbarStateEmotions,
    InputToolbarStatePlugins
};


@protocol DFInputToolbarViewDelegate <NSObject>

@required

//btn
-(void) onClickTextAndVoiceBtn;
-(void) onClickEmotionsBtn;
-(void) onClickPluginsBtn;


//msg
-(void) onSendButtonClick:(NSString *) message;
-(void) onTextViewLinesChange:(NSInteger) lines;



//voice
-(void) onVoiceRecordStart;
-(void) onVoiceRecordFinished;
-(void) onVoiceRecordCancelled;
-(void) onVoiceRecordTouchLeave;
-(void) onVoiceRecordTouchReturn;

@optional


@end



@interface DFInputToolbarView : UIView<UITextViewDelegate>

@property (weak,nonatomic) id<DFInputToolbarViewDelegate> delegate;


+(instancetype) sharedInstance;

-(InputToolbarState) getInputToolbarState;
-(void) setInputToolbarState:(InputToolbarState) state;
-(void) hideKeyboard;


@end
