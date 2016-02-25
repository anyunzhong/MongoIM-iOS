//
//  DFInputToolbarView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/17.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFInputToolbarView.h"
#import "Key.h"

//#import "DFDragButton.h"

#define BgColor [UIColor colorWithWhite:245/255.0 alpha:1.0]
#define TopLineColor [UIColor colorWithWhite:200/255.0 alpha:1.0]
#define TextViewBorderColor [UIColor colorWithWhite:175/255.0 alpha:1.0]

#define InputVoiceBtnBgColor [UIColor colorWithWhite:245/255.0 alpha:1.0]
#define InputVoiceBtnBorderColor [UIColor colorWithWhite:175/255.0 alpha:1.0]

#define HorizontalBtnPadding 3
#define VerticalBtnPadding 7.5



//左边按钮状态
typedef NS_ENUM(NSUInteger, TextVoiceBtnState){
    TextVoiceBtnStateText,
    TextVoiceBtnStateVoice
};

//右边笑脸按钮状态
typedef NS_ENUM(NSUInteger, EmotionsBtnState){
    EmotionsBtnStateEmotions,
    EmotionsBtnStateText
};


//中间文本框和语音按钮状态
typedef NS_ENUM(NSUInteger, InputVoiceAndTextviewState){
    InputVoiceAndTextviewStateTextview,
    InputVoiceAndTextviewStateVoice
};




@interface DFInputToolbarView()

@property (strong,nonatomic) UIView *topLineView;

@property (nonatomic, assign) InputToolbarState toolbarState;

@property (strong,nonatomic) UIButton *textVoiceBtn;

@property (strong,nonatomic) UIButton *emotionsBtn;

@property (strong,nonatomic) UIButton *pluginsBtn;


@property (strong,nonatomic) UITextView *inputTextView;
@property (strong,nonatomic) UIButton *inputVoiceBtn;

@property (assign, nonatomic) NSUInteger lines;

@property (assign, nonatomic) BOOL isCancelled;

@property (assign, nonatomic) BOOL isRecording;


@end

@implementation DFInputToolbarView


static  DFInputToolbarView *__view=nil;

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (__view == nil) {
            __view = [[DFInputToolbarView alloc] init];
        }
    }
    return __view;
}


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _lines = 1;
    }
    return self;
}

- (void)dealloc
{
    [self removeNotify];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _toolbarState = InputToolbarStateNone;
        _lines = 1;
        [self initView];
        [self addNotify];
    }
    return self;
}

-(void) initView
{
    self.backgroundColor = BgColor;
    
    //顶部横线
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _topLineView.backgroundColor = TopLineColor;
        [self addSubview:_topLineView];
    }
    
    //文本语音切换按钮
    
    if (_textVoiceBtn == nil) {
        _textVoiceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_textVoiceBtn];
        [_textVoiceBtn addTarget:self action:@selector(onClickTextVoiceBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self switchTextVoiceBtnState:TextVoiceBtnStateVoice];
        
    }
    
    
    //表情文本切花按钮
    
    if (_emotionsBtn == nil) {
        _emotionsBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [self addSubview:_emotionsBtn];
        [self switchEmotionsBtnState:EmotionsBtnStateEmotions];
        [_emotionsBtn addTarget:self action:@selector(onClickEmotionBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    //插件按钮
    
    if (_pluginsBtn == nil) {
        _pluginsBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_pluginsBtn setImage:[UIImage imageNamed:@"ToolViewPlugin"] forState:UIControlStateNormal];
        [_pluginsBtn setImage:[UIImage imageNamed:@"ToolViewPluginHL"] forState:UIControlStateHighlighted];
        [self addSubview:_pluginsBtn];
        [_pluginsBtn addTarget:self action:@selector(onClickPluginsBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    //文本输入
    if (_inputTextView == nil) {
        _inputTextView = [[UITextView alloc] initWithFrame:CGRectZero];
        [self addSubview:_inputTextView];
        
        _inputTextView.keyboardType = UIKeyboardTypeDefault;
        _inputTextView.returnKeyType = UIReturnKeySend;
        _inputTextView.layer.borderWidth = 0.5;
        _inputTextView.layer.cornerRadius = 5;
        _inputTextView.layer.borderColor = TextViewBorderColor.CGColor;
        _inputTextView.font = [UIFont systemFontOfSize:15];
        
        _inputTextView.delegate = self;
    }
    //语音输入按钮
    if (_inputVoiceBtn == nil) {
        _inputVoiceBtn = [ UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_inputVoiceBtn];
        
        //需要做两张图片
        _inputVoiceBtn.backgroundColor = InputVoiceBtnBgColor;
        _inputVoiceBtn.layer.borderWidth = 0.5;
        _inputVoiceBtn.layer.cornerRadius = 5;
        _inputVoiceBtn.layer.borderColor = InputVoiceBtnBorderColor.CGColor;
        [self changeVoiceButtonNormal:YES];
        
        _inputVoiceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        
        
        [_inputVoiceBtn addTarget:self action:@selector(onVoiceButtonTouchDown:) forControlEvents:UIControlEventTouchDown];
        
        [_inputVoiceBtn addTarget:self action:@selector(btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
        [_inputVoiceBtn addTarget:self action:@selector(btnDragged:withEvent:) forControlEvents:UIControlEventTouchDragOutside];
        
        [_inputVoiceBtn addTarget:self action:@selector(btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_inputVoiceBtn addTarget:self action:@selector(btnTouchUp:withEvent:) forControlEvents:UIControlEventTouchUpOutside];
        
        [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateTextview];
        
    }
    
}

-(void)layoutSubviews
{
    NSLog(@"layout");
    
    CGFloat x, y ,width,height;
    
    
    //顶部横线
    _topLineView.frame = CGRectMake(0, 0, self.frame.size.width, 0.5);
    
    
    //文本语音
    x = HorizontalBtnPadding;
    width = BtnSize;
    height = BtnSize;
    y = CGRectGetHeight(self.frame) - VerticalBtnPadding - height;
    _textVoiceBtn.frame = CGRectMake(x, y, width, height);
    
    
    //表情
    x = CGRectGetWidth(self.frame) - (HorizontalBtnPadding + BtnSize)*2;
    _emotionsBtn.frame = CGRectMake(x, y, width, height);
    
    
    //插件
    
    x = x+BtnSize+HorizontalBtnPadding;
    _pluginsBtn.frame = CGRectMake(x, y, width, height);
    
    
    
    x = CGRectGetMaxX(_textVoiceBtn.frame) + HorizontalBtnPadding*2;
    width = CGRectGetMinX(_emotionsBtn.frame) - x  - HorizontalBtnPadding*2;
    height = BtnSize + BtnSize*(_lines - 1)*0.5;
    y = CGRectGetMaxY(_textVoiceBtn.frame) - height;
    _inputTextView.frame = CGRectMake(x, y, width, height);
    
    
    height = BtnSize;
    y = CGRectGetMinY(_textVoiceBtn.frame);
    _inputVoiceBtn.frame = CGRectMake(x, y, width, height);
}




#pragma mark - Notification

-(void) addNotify
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEmojiClicked:) name:NOTIFY_EMOTION_EMOJI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEmojiSend:) name:NOTIFY_EMOTION_EMOJI_SEND object:nil];
    
}

-(void) removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_EMOTION_EMOJI object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_EMOTION_EMOJI_SEND object:nil];
}

-(void) onEmojiClicked:(NSNotification *) notify
{
    
    NSDictionary *dic = notify.userInfo;
    NSString *emojiName = [dic objectForKey:@"text"];
    
    NSString *text = _inputTextView.text;
    if (text == nil) {
        text = @"";
    }
    
    
    if ([emojiName isEqualToString:@""]) {
        if ([text isEqualToString:@""]) {
            return;
        }
        NSRange range = [text rangeOfString:@"[" options:NSBackwardsSearch];
        if (range.length != 0) {
            text = [text substringToIndex:range.location];
        }else{
            text = [text substringToIndex:(text.length-1)];
        }
        
    }else{
        text = [NSString stringWithFormat:@"%@%@",text,emojiName];
    }
    
    _inputTextView.text = text;
    
    [self onTextViewChange];
    
    NSDictionary *dicInfo = @{@"text":text};
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_TEXTVIEW_CONTENT_CHANGE object:nil userInfo:dicInfo];
}


-(void) onEmojiSend:(NSNotification *) notify
{
    [self sendMessage];
}


#pragma mark - Btn State Change
-(void) switchTextVoiceBtnState:(TextVoiceBtnState) state
{
    switch (state) {
            case TextVoiceBtnStateText:
            [_textVoiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
            [_textVoiceBtn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
            break;
            case TextVoiceBtnStateVoice:
            [_textVoiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoice"] forState:UIControlStateNormal];
            [_textVoiceBtn setImage:[UIImage imageNamed:@"ToolViewInputVoiceHL"] forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
}



-(void) switchEmotionsBtnState:(EmotionsBtnState) state
{
    switch (state) {
            case EmotionsBtnStateText:
            [_emotionsBtn setImage:[UIImage imageNamed:@"ToolViewKeyboard"] forState:UIControlStateNormal];
            [_emotionsBtn setImage:[UIImage imageNamed:@"ToolViewKeyboardHL"] forState:UIControlStateHighlighted];
            break;
            case EmotionsBtnStateEmotions:
            [_emotionsBtn setImage:[UIImage imageNamed:@"ToolViewEmotion"] forState:UIControlStateNormal];
            [_emotionsBtn setImage:[UIImage imageNamed:@"ToolViewEmotionHL"] forState:UIControlStateHighlighted];
            break;
        default:
            break;
    }
}



-(void) switchInputVoiceAndTextviewState:(InputVoiceAndTextviewState) state
{
    switch (state) {
            case InputVoiceAndTextviewStateVoice:
        {
            _inputTextView.hidden = YES;
            _inputVoiceBtn.hidden = NO;
            break;
        }
            
            case InputVoiceAndTextviewStateTextview:
        {
            _inputVoiceBtn.hidden = YES;
            _inputTextView.hidden = NO;
            break;
        }
        default:
            break;
    }
}



#pragma mark - Button On Click

-(void) onClickTextVoiceBtn:(id) sender
{
    switch (_toolbarState) {
            case InputToolbarStateNone:
        {
            [self switchTextVoiceBtnState:TextVoiceBtnStateText];
            [self switchEmotionsBtnState:EmotionsBtnStateEmotions];
            _toolbarState = InputToolbarStateVoice;
            [_inputTextView resignFirstResponder];
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateVoice];
            break;
        }
            case InputToolbarStateVoice:
        {
            [self switchTextVoiceBtnState:TextVoiceBtnStateVoice];
            _toolbarState = InputToolbarStateText;
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateTextview];
            [_inputTextView becomeFirstResponder];
            
            break;
        }
            case InputToolbarStateText:
        {
            [self switchTextVoiceBtnState:TextVoiceBtnStateText];
            [self switchEmotionsBtnState:EmotionsBtnStateEmotions];
            _toolbarState = InputToolbarStateVoice;
            [_inputTextView resignFirstResponder];
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateVoice];
            break;
        }
            case InputToolbarStateEmotions:
        {
            [self switchTextVoiceBtnState:TextVoiceBtnStateText];
            [self switchEmotionsBtnState:EmotionsBtnStateEmotions];
            _toolbarState = InputToolbarStateVoice;
            [_inputTextView resignFirstResponder];
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateVoice];
            break;
        }
            case InputToolbarStatePlugins:
        {
            _toolbarState = InputToolbarStateVoice;
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateVoice];
        }
            
        default:
            break;
    }
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onClickTextAndVoiceBtn)]) {
        [_delegate onClickTextAndVoiceBtn];
    }
    
}





-(void) onClickEmotionBtn:(id) sender
{
    switch (_toolbarState) {
            case InputToolbarStateNone:
            case InputToolbarStateVoice:
        {
            [self switchEmotionsBtnState:EmotionsBtnStateText];
            [self switchTextVoiceBtnState:TextVoiceBtnStateVoice];
            _toolbarState = InputToolbarStateEmotions;
            [_inputTextView resignFirstResponder];
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateTextview];
            break;
        }
            case InputToolbarStateEmotions:
        {
            [self switchEmotionsBtnState:EmotionsBtnStateEmotions];
            _toolbarState = InputToolbarStateText;
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateTextview];
            [_inputTextView becomeFirstResponder];
            
            break;
        }
            case InputToolbarStateText:
        {
            [self switchEmotionsBtnState:EmotionsBtnStateText];
            [self switchTextVoiceBtnState:TextVoiceBtnStateVoice];
            _toolbarState = InputToolbarStateEmotions;
            [self switchInputVoiceAndTextviewState:InputVoiceAndTextviewStateTextview];
            [_inputTextView resignFirstResponder];
            break;
        }
            case InputToolbarStatePlugins:
        {
            [self switchEmotionsBtnState:EmotionsBtnStateText];
            [self switchTextVoiceBtnState:TextVoiceBtnStateVoice];
            _toolbarState = InputToolbarStateEmotions;
        }
        default:
            break;
    }
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onClickEmotionsBtn)]) {
        [_delegate onClickEmotionsBtn];
    }
    
    
}





-(void) onClickPluginsBtn:(id) sender
{
    switch (_toolbarState) {
            case InputToolbarStateNone:
        {
            _toolbarState = InputToolbarStatePlugins;
            [_inputTextView resignFirstResponder];
            break;
        }
            case InputToolbarStateVoice:
        {
            _toolbarState = InputToolbarStatePlugins;
            [_inputTextView resignFirstResponder];
            
            break;
        }
            case InputToolbarStateText:
        {
            _toolbarState = InputToolbarStatePlugins;
            [_inputTextView resignFirstResponder];
            
            
            break;
        }
            case InputToolbarStateEmotions:
        {
            _toolbarState = InputToolbarStatePlugins;
            break;
        }
            case InputToolbarStatePlugins:
        {
            [_inputTextView becomeFirstResponder];
            _toolbarState = InputToolbarStateText;
            
        }
            
        default:
            break;
    }
    
    
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onClickPluginsBtn)]) {
        [_delegate onClickPluginsBtn];
    }
    
}





#pragma mark - Voice Button Events

- (void)btnDragged:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        BOOL previewTouchInside = CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchInside) {
            // UIControlEventTouchDragExit
            [self onVoiceButtonDragExit];
        } else {
            // UIControlEventTouchDragOutside
            
        }
    } else {
        BOOL previewTouchOutside = !CGRectContainsPoint(outerBounds, [touch previousLocationInView:sender]);
        if (previewTouchOutside) {
            // UIControlEventTouchDragEnter
            [self onVoiceButtonDragEnter];
        } else {
            // UIControlEventTouchDragInside
        }
    }
}




- (void)btnTouchUp:(UIButton *)sender withEvent:(UIEvent *)event {
    UITouch *touch = [[event allTouches] anyObject];
    CGFloat boundsExtension = 5.0f;
    CGRect outerBounds = CGRectInset(sender.bounds, -1 * boundsExtension, -1 * boundsExtension);
    BOOL touchOutside = !CGRectContainsPoint(outerBounds, [touch locationInView:sender]);
    if (touchOutside) {
        // UIControlEventTouchUpOutside
        [self onVoiceButtonTouchUpOutside];
    } else {
        // UIControlEventTouchUpInside
        [self onVoiceButtonTouchUpInside];
    }
}


-(void) onVoiceButtonTouchDown:(UIButton *) button
{
    //NSLog(@"touch down");
    [self changeVoiceButtonNormal:NO];
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onVoiceRecordStart)]) {
        [_delegate onVoiceRecordStart];
    }
}

-(void) onVoiceButtonTouchUpOutside
{
    //NSLog(@"touch up outside");
    [self changeVoiceButtonNormal:YES];
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onVoiceRecordCancelled)]) {
        [_delegate onVoiceRecordCancelled];
    }
}



-(void) onVoiceButtonTouchUpInside
{
    //NSLog(@"touch up inside");
    [self changeVoiceButtonNormal:YES];
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onVoiceRecordFinished)]) {
        [_delegate onVoiceRecordFinished];
    }
}

-(void) onVoiceButtonDragExit
{
    //NSLog(@"drag exit");
    [self changeVoiceButtonNormal:NO];
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onVoiceRecordTouchLeave)]) {
        [_delegate onVoiceRecordTouchLeave];
    }
}


-(void) onVoiceButtonDragEnter
{
    //NSLog(@"drag enter");
    [self changeVoiceButtonNormal:YES];
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onVoiceRecordTouchReturn)]) {
        [_delegate onVoiceRecordTouchReturn];
    }
}


-(void) changeVoiceButtonNormal:(BOOL) normal
{
    if (normal) {
        [_inputVoiceBtn setTitle:@"按住 说话" forState:UIControlStateNormal];
        [_inputVoiceBtn setTitleColor:[UIColor colorWithWhite:100/255.0 alpha:1.0] forState:UIControlStateNormal];
    }else{
        
        [_inputVoiceBtn setTitle:@"松开 发送" forState:UIControlStateNormal];
        [_inputVoiceBtn setTitleColor:[UIColor colorWithWhite:200/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
}


#pragma mark - Method
-(InputToolbarState) getInputToolbarState
{
    return _toolbarState;
}

-(void) setInputToolbarState:(InputToolbarState) state
{
    _toolbarState = state;
}

-(void) hideKeyboard
{
    [_inputTextView resignFirstResponder];
}

-(NSInteger) getTextViewLines
{
    return [self numberOfLinesForMessage:_inputTextView.text];
}

- (NSUInteger)maxCharactersPerLine {
    //return ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) ? 18 : 109;
    return ceil(_inputTextView.frame.size.width / 10.7);
    
}

- (NSUInteger)numberOfLinesForMessage:(NSString *)text {
    return (text.length / [self maxCharactersPerLine]) + 1;
}


-(void) sendMessage
{
    if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onSendButtonClick:)]) {
        if (![_inputTextView.text isEqualToString:@""]) {
            [_delegate onSendButtonClick: _inputTextView.text ];
            _inputTextView.text =@"";
            _lines = 1;
        }
        
    }
}

-(void) onTextViewChange
{
    //NSLog(@"lines: %d" ,[self getTextViewLines]);
    NSUInteger currentLines = [self getTextViewLines];
    if (currentLines != _lines) {
        _lines = currentLines;
        
        if (_delegate != nil && [_delegate conformsToProtocol:@protocol(DFInputToolbarViewDelegate)]  && [_delegate respondsToSelector:@selector(onTextViewLinesChange:)]) {
            [_delegate onTextViewLinesChange:currentLines];
        }
    }
}


#pragma mark - UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text
{
    if ([text isEqualToString:@"\n"]) {
        
        [self sendMessage];
        
        return NO;
    }
    
    return YES;
}


-(void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"begin edit");
    _toolbarState = InputToolbarStateText;
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"end edit");
    //_toolbarState = InputToolbarStateNone;
}


-(void)textViewDidChange:(UITextView *)textView
{
    [self onTextViewChange];
}

@end
