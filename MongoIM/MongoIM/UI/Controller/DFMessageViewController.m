//
//  DFChatViewController.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/17.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFMessageViewController.h"

#import "Key.h"

#import "DFMessageCellManager.h"
#import "DFBaseMessageCell.h"

#import "DFRecorderHUD.h"

#import "LCVoice.h"

#import "MessageContentType.h"
#import "DFTextMessageContent.h"
#import "DFVoiceMessageContent.h"
#import "DFEmotionMessageContent.h"

#import "MongoIM.h"

#import "DFPluginsManager.h"

#define InputToolbarViewHeight (50 + BtnSize*(_lines - 1)*0.5)
#define PluginsViewHeight 216
#define EmotionsViewHeight 216

#define ToolBarObserveKeyPath @"toolbarViewOffsetY"

#define AnimationDuration 0.2500

#define RecorderHudSize 140

#define TIME_SHOW_INTERVAL 3*60*1000

@interface DFMessageViewController ()<LCVoiceDelegate, DFBaseMessageCellDelegate>


@property (assign, nonatomic) NSTimeInterval keyboardAnimationDuration;
@property (assign, nonatomic) NSUInteger keyboardAnimationCurve;


@property (assign, nonatomic) CGFloat toolbarViewOffsetY;

@property (assign, nonatomic) NSInteger lines;


@property (strong, nonatomic) DFInputToolbarView *inputToolbarView;

@property (strong, nonatomic) DFMessageTableView *messageTableView;

@property (strong, nonatomic) DFPluginsView *pluginsView;

@property (strong, nonatomic) DFEmotionsView *emotionssView;


@property (strong, nonatomic) UIView *messageTableViewMask;


@property (strong, nonatomic) UIPanGestureRecognizer *tableViewPanGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tableViewTapGestureRecognizer;


@property (strong, nonatomic) NSMutableArray *messages;

@property (strong, nonatomic) NSMutableDictionary *messageDic;

@property (assign, nonatomic) long long lastTs;


@property (strong, nonatomic) DFRecorderHUD *recorderHud;

@property (strong, nonatomic) LCVoice *lcVoice;


@property (strong, nonatomic) NSString *targetId;
@property (assign, nonatomic) ConversationType conversationType;

@property (assign, nonatomic) BOOL firstScrollToBottom;
@end


@implementation DFMessageViewController


#pragma mark - Lifecycle


- (instancetype)initWithTargetId:(NSString *) targetId conversationType:(ConversationType) conversationType
{
    self = [super init];
    if (self) {
        
        _targetId = targetId;
        _conversationType = conversationType;
        
        
        _messages =[NSMutableArray array];
        _messageDic = [NSMutableDictionary dictionary];
        _lastTs = 0;
        
        _lines = 1;
        _keyboardAnimationDuration = 0.25;
        _keyboardAnimationCurve = 7;
        
        _lcVoice = [[LCVoice alloc] init];
        _lcVoice.delegate = self;
        
        _firstScrollToBottom = YES;
        
        
        [[DFPluginsManager sharedInstance] setParentController:self];
    }
    return self;
}

- (void)dealloc
{
    
    [_messageTableViewMask removeGestureRecognizer:_tableViewPanGestureRecognizer];
    [_messageTableViewMask removeGestureRecognizer:_tableViewTapGestureRecognizer];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self loadHistoryMessages];
    
    [self messageTableViewScrollToBottom];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self addNotify];
    
    [self addObserver];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self removeNotify];
    
    [self removeObserver];
}


-(void) initView
{
    self.view.backgroundColor = [UIColor colorWithWhite:235/255.0 alpha:1.0];
    
    __weak DFMessageViewController *weakself = self;
    //标题
    UserInfoProvider provider = [MongoIM sharedInstance].userInfoProvider;
    UserInfoCallback callback = ^(DFUserInfo *userinfo){
        
        if (userinfo != nil) {
            weakself.title = userinfo.nick;
        }
    };
    
    provider(_targetId, callback);
    
    CGFloat x, y ,width,height;
    
    
    //输入工具栏
    x = 0.0f;
    y = CGRectGetHeight(self.view.frame) - InputToolbarViewHeight ;
    width = CGRectGetWidth(self.view.frame);
    height = InputToolbarViewHeight;
    
    if (_inputToolbarView == nil) {
        _inputToolbarView = [DFInputToolbarView sharedInstance];
        _inputToolbarView.frame = CGRectMake(x, y, width, height);
        //_inputToolbarView = [[DFInputToolbarView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:_inputToolbarView];
        _inputToolbarView.delegate = self;
        
        _toolbarViewOffsetY = y;
        
    }
    
    //消息表格
    y = 0;
    height = CGRectGetMinY(_inputToolbarView.frame);
    
    if (_messageTableView == nil) {
        _messageTableView = [[DFMessageTableView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:_messageTableView];
        _messageTableView.delegate = self;
        _messageTableView.dataSource = self;
        _messageTableView.messageDelegate = self;
        _messageTableView.backgroundColor =[UIColor clearColor];
        
        if (_messageTableViewMask == nil) {
            _messageTableViewMask = [[UIView alloc] initWithFrame:_messageTableView.frame];
            [self.view addSubview:_messageTableViewMask];
            //_messageTableViewMask.backgroundColor = [UIColor redColor];
            _messageTableViewMask.hidden = YES;
        }
        
        if (_tableViewPanGestureRecognizer == nil) {
            _tableViewPanGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewPanAndTap:)];
            [_messageTableViewMask addGestureRecognizer:_tableViewPanGestureRecognizer];
            _tableViewPanGestureRecognizer.maximumNumberOfTouches = 1;
            
        }
        
        if (_tableViewTapGestureRecognizer == nil) {
            _tableViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTableViewPanAndTap:)];
            [_messageTableViewMask addGestureRecognizer:_tableViewTapGestureRecognizer];
        }
        
        
    }
    
    
    //插件面板
    
    y = CGRectGetMaxY(_inputToolbarView.frame);
    height = PluginsViewHeight;
    if (_pluginsView == nil) {
        _pluginsView = [DFPluginsView sharedInstance:CGRectMake(0, 0, width, height)];
        _pluginsView.frame = CGRectMake(x, y, width, height);
        //_pluginsView = [[DFPluginsView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:_pluginsView];
        _pluginsView.hidden = YES;
    }
    
    
    //表情面板
    
    height = EmotionsViewHeight;
    if (_emotionssView == nil) {
        _emotionssView = [DFEmotionsView sharedInstance:CGRectMake(0, 0, width, height)];
        _emotionssView.frame = CGRectMake(x, y, width, height);
        //_emotionssView.frame = CGRectMake(x, y, width, height);
        //_emotionssView = [[DFEmotionsView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:_emotionssView];
        _emotionssView.hidden = YES;
    }
    
    
    //录音HUD
    width = RecorderHudSize;
    height = width;
    x = (CGRectGetWidth(self.view.frame) - width)/2;
    y = (CGRectGetHeight(self.view.frame) - height)/2;
    if (_recorderHud == nil) {
        _recorderHud = [[DFRecorderHUD alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.view addSubview:_recorderHud];
        _recorderHud.hidden = YES;
    }
    
    [self.view bringSubviewToFront:_inputToolbarView];
    
    
}



-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}




#pragma mark - Notification

-(void) addNotify

{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboradShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboradHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageSent:) name:NOTIFY_MESSAGE_SENT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageFailed:) name:NOTIFY_MESSAGE_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMessageReceived:) name:NOTIFY_MESSAGE_RECEIVED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onEmotionClick:) name:NOTIFY_EMOTION_MESSAGE object:nil];
}


-(void) removeNotify

{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MESSAGE_SENT object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MESSAGE_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MESSAGE_RECEIVED object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_EMOTION_MESSAGE object:nil];
    
}

-(void) onKeyboradShow:(NSNotification *) notify
{
    [self onKeyboardChange:notify];
    
}


-(void) onKeyboradHide:(NSNotification *) notify
{
    //[self onKeyboardChange:notify];
    
}


-(void) onKeyboardChange:(NSNotification *) notify
{
    NSDictionary *info = notify.userInfo;
    CGRect frame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardAnimationDuration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    _keyboardAnimationCurve = [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [self changeInputToolbarViewOffsetY:(frame.origin.y - InputToolbarViewHeight) ];
}



#pragma mark - Observer

-(void) addObserver
{
    [self addObserver:self forKeyPath:ToolBarObserveKeyPath options:NSKeyValueObservingOptionNew context:nil];
}


-(void) removeObserver
{
    [self removeObserver:self forKeyPath:ToolBarObserveKeyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:ToolBarObserveKeyPath]) {
        CGFloat newOffsetY = [[change valueForKey:NSKeyValueChangeNewKey] floatValue];
        
        [self changeInputToolbarViewPosition:newOffsetY];
    }
    
}

-(void) changeInputToolbarViewOffsetY:(CGFloat) offsetY
{
    [self setValue: [NSNumber numberWithDouble:offsetY] forKey:ToolBarObserveKeyPath];
    
}

-(void) changeInputToolbarViewPosition:(CGFloat) newOffsetY
{
    CGFloat x,y,width,height;
    CGRect frame = _inputToolbarView.frame;
    x = frame.origin.x;
    y = newOffsetY;
    width = frame.size.width;
    height = frame.size.height;
    
    _messageTableViewMask.hidden = !(newOffsetY < (self.view.frame.size.height - InputToolbarViewHeight));
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_keyboardAnimationDuration];
    [UIView setAnimationCurve:_keyboardAnimationCurve];
    
    _inputToolbarView.frame = CGRectMake(x, y, width, height);
    
    //其它几个跟着动
    [self changeMessageTableViewPosition:newOffsetY];
    [self changeEmotionsViewPosition:newOffsetY];
    [self changePluginsViewPosition:newOffsetY];
    
    [UIView commitAnimations];
}

-(void) changeMessageTableViewPosition:(CGFloat) newOffsetY {
    CGFloat x,y,width,height;
    CGRect frame = _messageTableView.frame;
    x = frame.origin.x;
    y = newOffsetY - frame.size.height;
    width = frame.size.width;
    height = frame.size.height;
    _messageTableView.frame = CGRectMake(x, y, width, height);
    
    [self messageTableViewScrollToBottom];
}


-(void) changeEmotionsViewPosition:(CGFloat) newOffsetY {
    CGFloat x,y,width,height;
    CGRect frame = _messageTableView.frame;
    x = frame.origin.x;
    y = newOffsetY + InputToolbarViewHeight;
    width = frame.size.width;
    height = frame.size.height;
    _emotionssView.frame = CGRectMake(x, y, width, height);
}

-(void) changePluginsViewPosition:(CGFloat) newOffsetY {
    CGFloat x,y,width,height;
    CGRect frame = _messageTableView.frame;
    x = frame.origin.x;
    y = newOffsetY + InputToolbarViewHeight;
    width = frame.size.width;
    height = frame.size.height;
    _pluginsView.frame = CGRectMake(x, y, width, height);
}



#pragma mark - DFInputToolbarViewDelegate


-(void)onClickTextAndVoiceBtn
{
    if ([_inputToolbarView getInputToolbarState] != InputToolbarStateText) {
        [self toolbarViewAnimateToBottom];
    }
}


-(void)onClickEmotionsBtn
{
    [self toolbarViewAnimateToMiddle];
    
    _emotionssView.hidden = NO;
    _pluginsView.hidden = YES;
    
}


-(void)onClickPluginsBtn
{
    
    [self toolbarViewAnimateToMiddle];
    
    
    _emotionssView.hidden = YES;
    _pluginsView.hidden = NO;
}



-(void)onMessageSent:(NSNotification *) notify
{
    NSUInteger messageId = [[notify.userInfo objectForKey:@"messageId"] unsignedIntegerValue];
    
    [self changeMessageStatus:MessageSendStatusSent messageId:messageId];
}


-(void)onMessageFailed:(NSNotification *) notify
{
    NSUInteger messageId = [[notify.userInfo objectForKey:@"messageId"] unsignedIntegerValue];
    
    [self changeMessageStatus:MessageSendStatusFailed messageId:messageId];
}

-(void)onMessageReceived:(NSNotification *) notify
{
    DFMessage *message = [notify.userInfo objectForKey:@"message"];
    
    [self addMessage:message];
}

-(void) onEmotionClick:(NSNotification *) notify
{
    DFPackageEmotionItem *item = [notify.userInfo objectForKey:@"item"];
    
    DFEmotionMessageContent *content = [[DFEmotionMessageContent alloc] init];
    content.emotionItem = item;
    [self sendMessage:content contentType:MessageContentTypeEmotion];
}



-(void)onSendButtonClick:(NSString *)text
{
    DFTextMessageContent *textMessageContent = [[DFTextMessageContent alloc] init];
    textMessageContent.text = text;
    [self sendMessage:textMessageContent contentType:MessageContentTypeText];
    
    _lines = 1;
    [self layoutToolbarView];
}

-(void)onTextViewLinesChange:(NSInteger)lines
{
    NSLog(@"lines: %ld", (long)lines);
    
    if (lines > 5) {
        return;
    }
    
    _lines = lines;
    
    [self layoutToolbarView];
}





-(void)onVoiceRecordStart
{
    NSLog(@"start recording");
    
    _recorderHud.hidden = NO;
    [_recorderHud setHudState:RecorderHudStateNormal];
    [_recorderHud setSignalLevel:5];
    
    [self startRecording];
}


-(void) onVoiceRecordFinished
{
    NSLog(@"finish recording");
    _recorderHud.hidden = YES;
    [self stopRecording];
    
}


-(void)onVoiceRecordCancelled
{
    NSLog(@"cancel recording");
    _recorderHud.hidden = YES;
    
    [_lcVoice stopRecordWithCompletionBlock:^{
        
    }];
    
}

-(void)onVoiceRecordTouchLeave
{
    NSLog(@"leave btn ");
    [_recorderHud setHudState:RecorderHudStateCancel];
}


-(void)onVoiceRecordTouchReturn
{
    NSLog(@"return normal");
    [_recorderHud setHudState:RecorderHudStateNormal];
}





-(void) startRecording
{
    NSString *cafPath = [NSString stringWithFormat:@"%@record_sound.caf", NSTemporaryDirectory()];
    
    [_lcVoice startRecordWithPath:cafPath];
}


-(void) stopRecording
{
    
    [_lcVoice stopRecordWithCompletionBlock:^{
        if (_lcVoice.recordTime >= 1) {
            NSLog(@"path: %@", _lcVoice.recordPath);
            
            DFVoiceMessageContent *voiceMessageContent = [[DFVoiceMessageContent alloc] init];
            
            voiceMessageContent.duration = _lcVoice.recordTime;
            voiceMessageContent.wavAudioData = [NSData dataWithContentsOfFile:_lcVoice.recordPath];
            
            [self sendMessage:voiceMessageContent contentType:MessageContentTypeVoice];
            
            
        }else{
            //提示录音时间太短
        }
    }];
}
#pragma mark - Method MessageTableView

-(void) messageTableViewScrollToBottom
{
    if (_firstScrollToBottom) {
        
        _firstScrollToBottom = NO;
        
        if (_messageTableView.contentSize.height -_messageTableView.bounds.size.height>0) {
            [_messageTableView setContentOffset:CGPointMake(0, _messageTableView.contentSize.height -_messageTableView.bounds.size.height + 50) animated:NO];
        }
    }else{
        
        if (_messages.count > 0) {
            [_messageTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_messages.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
    }
    
}

-(void) onTableViewPanAndTap:(UIGestureRecognizer *) gesture
{
    [_inputToolbarView hideKeyboard];
    [self toolbarViewAnimateToBottom];
    
    if ([_inputToolbarView getInputToolbarState] != InputToolbarStateText) {
        [_inputToolbarView setInputToolbarState:InputToolbarStateNone];
    }
}


#pragma mark - Method InputToolbarView

-(void) toolbarViewAnimateToBottom
{
    CGFloat offsetY = CGRectGetHeight(self.view.frame) - InputToolbarViewHeight ;
    [self changeInputToolbarViewPosition:offsetY];
}


-(void) toolbarViewAnimateToMiddle
{
    if ([_inputToolbarView getInputToolbarState] == InputToolbarStateText) {
        return;
    }
    
    CGFloat offsetY = CGRectGetHeight(self.view.frame) - InputToolbarViewHeight - PluginsViewHeight ;
    [self changeInputToolbarViewPosition:offsetY];
}

-(void) layoutToolbarView
{
    CGFloat maxY = CGRectGetMinY(_pluginsView.frame);
    CGFloat x,y,width,height;
    CGRect frame = _inputToolbarView.frame;
    x = frame.origin.x;
    height = InputToolbarViewHeight;
    y = maxY  - height;
    width = frame.size.width;
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:_keyboardAnimationDuration];
    [UIView setAnimationCurve:_keyboardAnimationCurve];
    
    _inputToolbarView.frame = CGRectMake(x, y, width, height);
    
    [UIView commitAnimations];
    
    [self toolbarViewAnimateToMiddle];
    
}


#pragma mark - Method EmotionsAndPluginsView



#pragma mark - UITableViewDataSource & Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_messages count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DFMessage *message = [_messages objectAtIndex:[indexPath row]];
    if (message.receiveStatus == MessageReceiveStatusUnread) {
        [[MongoIM sharedInstance].messageHandler setMessageReceivedStatus:message.messageId receivedStatus:MessageReceiveStatusRead];
    }
    DFBaseMessageCell *typeCell = [self getCell:message.contentType];
    
    
    NSString *reuseIdentifier = NSStringFromClass([typeCell class]);
    DFBaseMessageCell *cell = [tableView dequeueReusableCellWithIdentifier: reuseIdentifier];
    if (cell == nil ) {
        cell = [[[typeCell class] alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }else{
        NSLog(@"重用Cell: %@", reuseIdentifier);
    }
    
    [cell updateWithMessage:message];
    
    cell.delegate = self;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFMessage *message = [_messages objectAtIndex:[indexPath row]];
    DFBaseMessageCell *typeCell = [self getCell:message.contentType];
    return [typeCell getReuseCellHeight:message];
}


#pragma mark - DFMessageTableViewDelegate

-(void)onPullDown
{
    [self loadHistoryMessages];
    [_messageTableView onLoadFinish];
}

#pragma mark - Method


-(void)reloadData
{
    [_messageTableView reloadData];
}


-(BOOL)showUserNick
{
    return NO;
}

-(void) addMessage:(DFMessage *) message
{
    
    [self addMessage:message updateStatus:YES];
}


-(void)addMessage:(DFMessage *)message updateStatus:(BOOL)updateStatus
{
    message.showTime = (message.sentTime - _lastTs >= TIME_SHOW_INTERVAL)?YES:NO;
    message.showUserNick = [self showUserNick];
    
    [_messages addObject:message];
    
    message.rowIndex = _messages.count - 1;
    
    _lastTs = message.sentTime;
    
    [_messageDic setObject:message forKey:[NSNumber numberWithLongLong:message.messageId]];
    
    if (updateStatus) {
        [self changeMessageStatus:message.sendStatus messageId:message.messageId];
    }else{
        [_messageTableView reloadData];
    }
    
    [self messageTableViewScrollToBottom];
}


-(void) insertMessagesHead:(NSMutableArray *) messages
{
    //NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:0];
    //[_messages insertObjects:messages atIndexes:set];
    
    for (DFMessage *message in messages) {
        message.showUserNick = [self showUserNick];
        [_messages insertObject:message atIndex:0];
    }
    
    _lastTs = 0;
    
    NSUInteger rowIndex = 0;
    for (DFMessage *message in _messages) {
        message.showTime = (message.sentTime - _lastTs >= TIME_SHOW_INTERVAL)?YES:NO;
        _lastTs = message.sentTime;
        [_messageDic setObject:message forKey:[NSNumber numberWithLongLong:message.messageId]];
        
        message.rowIndex = rowIndex;
        rowIndex++;
        
    }
    
    [_messageTableView reloadData];
}


-(DFMessage *)getMessage:(NSUInteger)messageId
{
    return [_messageDic objectForKey:[NSNumber numberWithUnsignedInteger:messageId]];
}

-(DFMessage *)getMessageByRowIndex:(NSUInteger)rowIndex
{
    return [_messages objectAtIndex:rowIndex];
}


-(void)changeMessageStatus:(MessageSendStatus)status messageId:(NSUInteger)messageId
{
    DFMessage *message = [self getMessage:messageId];
    if (message != nil) {
        message.sendStatus = status;
    }
    [_messageTableView reloadData];
}


-(DFBaseMessageCell *) getCell:(NSString *) contentType
{
    DFMessageCellManager *manager = [DFMessageCellManager sharedInstance];
    return [manager getCell:contentType];
}

-(NSMutableArray *)loadHistoryMessages:(long long)messageId{
    return nil;
}

-(void) loadHistoryMessages
{
    NSUInteger messageId = 0;
    if (_messages != nil && _messages.count > 0) {
        messageId = ((DFMessage *)[_messages objectAtIndex:0]).messageId;
    }
    
    DFBaseMessageHandler *messageHandler = [MongoIM sharedInstance].messageHandler;
    
    NSMutableArray *array = [messageHandler getMessages:ConversationTypePrivate targetId:_targetId start:messageId size:20];
    if (array != nil && array.count > 0) {
        [self insertMessagesHead:array];
    }
}

#pragma mark - LcVoiceDelegate

-(void)updateVoiceLevel:(NSUInteger) level
{
    //NSLog(@"level: %lu",(unsigned long)level);
    _recorderHud.signalLevel = level;
}


#pragma mark - DFBaseMessageCellDelegate

-(void)onDeleteMessage:(NSUInteger)messageId
{
    DFMessage *message = [_messageDic objectForKey:[NSNumber numberWithUnsignedInteger:messageId]];
    [_messages removeObject:message];
    [_messageTableView reloadData];
    
    DFBaseMessageHandler *messageHandler = [MongoIM sharedInstance].messageHandler;
    
    [messageHandler deleteMessage:messageId];
}


#pragma mark Method

-(void) sendMessage:(DFMessageContent *) content contentType:(NSString *) contentType
{
    DFMessage *message = [[DFMessage alloc] init];
    message.messageId = 0;
    message.targetId = _targetId;
    message.direction = MessageDirectionSend;
    message.conversationType = _conversationType;
    message.receiveStatus = MessageReceiveStatusRead;
    message.sendStatus = MessageSendStatusSending;
    message.receivedTime = [[NSDate date] timeIntervalSince1970]*1000;
    message.sentTime = [[NSDate date] timeIntervalSince1970]*1000;
    message.contentType = contentType;
    
    message.messageContent = content;
    
    
    DFBaseMessageHandler *messageHandler = [MongoIM sharedInstance].messageHandler;
    
    [messageHandler sendMessage:message];
    
    [self addMessage:message];
    
}

@end
