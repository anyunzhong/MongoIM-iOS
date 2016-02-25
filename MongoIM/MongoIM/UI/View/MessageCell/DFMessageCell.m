//
//  DFMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/27.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMessageCell.h"
#import "MongoIM.h"
#import "UIImageView+WebCache.h"

#import "DFMessageStatusView.h"

#define NickLabelFont [UIFont systemFontOfSize:12]

#define MaxBubbleWidth CellWidth*0.7
#define UserAvatarSize 48
#define BubblePadding 10

#define StatusViewSize 20

//昵称及上下margin
#define NickViewAndSpaceHeight 20

@interface DFMessageCell()

@property (strong, nonatomic) UIImageView *userAvatarView;

@property (strong,nonatomic) UILabel *userNickLabel;

@property (strong, nonatomic) DFMessageStatusView *messageStatusView;

@property (strong, nonatomic) UIImage *senderMaskImage;
@property (strong, nonatomic) UIImage *receiverMaskImage;

@property (strong, nonatomic) DFUserInfo *userinfo;

@end


@implementation DFMessageCell


#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initMessageCell];
    }
    return self;
}

-(void) initMessageCell
{
    if (_userAvatarView == nil) {
        _userAvatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.baseContentView addSubview:_userAvatarView];
        _userAvatarView.layer.borderWidth = 0.4;
        _userAvatarView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    
    if (_userNickLabel == nil) {
        _userNickLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNickLabel.font = NickLabelFont;
        _userNickLabel.textColor = [UIColor colorWithWhite:180/255.0 alpha:1.0];
        _userNickLabel.hidden = YES;
        [self.baseContentView addSubview:_userNickLabel];
    }
    
    if (_messageContentView == nil) {
        _messageContentView = [[UIView alloc] initWithFrame:CGRectZero];
        //_messageContentView.backgroundColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
        [self.baseContentView addSubview:_messageContentView];
        
        UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
        [_messageContentView addGestureRecognizer:longPressRecognizer];
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [_messageContentView addGestureRecognizer:tapRecognizer];
    }
    
    if (_messageStatusView == nil) {
        _messageStatusView = [[DFMessageStatusView alloc] initWithFrame:CGRectMake(0, 0, StatusViewSize, StatusViewSize)];
        [self.baseContentView addSubview:_messageStatusView];
    }
    
    
}


-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    CGFloat x, y ,width ,height;
    
    //用户头像
    if (self.isSender) {
        x = CellWidth - Padding - UserAvatarSize;
    }else{
        x = Padding;
    }
    
    y = 3; //和bubble上边缘对齐
    
    width = UserAvatarSize;
    height = width;
    
    _userAvatarView.frame = CGRectMake(x, y, width, height);
    
    if (_userinfo == nil) {
        
        __weak DFMessageCell *weakself = self;
        
        UserInfoCallback callback = ^(DFUserInfo *userinfo){
            _userinfo = userinfo;
            if (userinfo.avatar != nil && ![userinfo.avatar isEqualToString:@""]) {
                [weakself.userAvatarView sd_setImageWithURL:[NSURL URLWithString:userinfo.avatar]];
            }else{
                weakself.userAvatarView.image = [UIImage imageNamed:@"DefaultHead"];
            }

            weakself.userNickLabel.text = userinfo.nick;
        };
        
        UserInfoProvider provider = [MongoIM sharedInstance].userInfoProvider;
        provider(message.senderId, callback);
        
    }else{
        if (_userinfo.avatar != nil && ![_userinfo.avatar isEqualToString:@""]) {
            [_userAvatarView sd_setImageWithURL:[NSURL URLWithString:_userinfo.avatar]];
        }else{
            _userAvatarView.image = [UIImage imageNamed:@"DefaultHead"];
        }

       _userNickLabel.text = _userinfo.nick;
    }
    
    
    // 昵称
    if (!self.isSender && message.showUserNick) {
        x = CGRectGetMaxX(_userAvatarView.frame) + Padding;
        y = CGRectGetMinY(_userAvatarView.frame) +2;
        height = 15;
        width = CellWidth - x - 30;
        _userNickLabel.frame = CGRectMake(x, y, width, height);
        _userNickLabel.hidden = NO;
        
    }else{
        _userNickLabel.hidden = YES;
    }
    
    
    //内容区域容器
    
    width = [self getMessageContentViewSize].width;
    height = [self getMessageContentViewSize].height;
    
    
    if (self.isSender) {
        x=CellWidth-width-UserAvatarSize-Padding*2;
    }else{
        x=CGRectGetMaxX(_userAvatarView.frame) + Padding;
    }
    
    if (!self.isSender && message.showUserNick){
        y = NickViewAndSpaceHeight;
    }else{
        y=0;
    }
    
    _messageContentView.frame = CGRectMake(x, y, width, height);
    
    
    //状态
    
    CGFloat centerX, centerY;
    if (self.isSender) {
        centerX = CGRectGetMinX(_messageContentView.frame)-StatusViewSize;
    }else{
        centerX = CGRectGetMaxX(_messageContentView.frame)+StatusViewSize;
    }
    
    centerY = _messageContentView.center.y -3; //因为bubble图片有空白边缘 所以上移才会在bubble中间
    _messageStatusView.center = CGPointMake(centerX, centerY);
    
    [_messageStatusView changeStatus:message.sendStatus];
    
    
}

-(CGFloat)getBaseContentViewHeight
{
    CGFloat nickHeight = (self.isSender? 0: NickViewAndSpaceHeight);
    return nickHeight+[self getMessageContentViewSize].height;
}

-(CGSize) getMessageContentViewSize
{
    return CGSizeMake(0, 0);
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    BOOL isSender = message.direction == MessageDirectionSend;
    CGFloat nickHeight = (isSender? 0: NickViewAndSpaceHeight);
    return nickHeight+ [super getCellHeight:message];
}



-(void) onLongPress:(UILongPressGestureRecognizer *) recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan){
        [self onLongPress];
    }
}

-(void) onTap:(UILongPressGestureRecognizer *) recognizer
{
    [self onTap];
}

-(void)onLongPress
{
    [self showMenu:@[]];
}

-(void)onTap
{
    [self onSigleTap];
}

-(UIImage *)getMaskBubbleImage
{
    UIImage *image;
    if (self.isSender) {
        if (_senderMaskImage == nil) {
            UIImage *maskImage = [UIImage imageNamed:@"SenderTextNodeBkg"];
            _senderMaskImage = [maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 14, 20, 20) resizingMode:UIImageResizingModeStretch];
        }
        image = _senderMaskImage;
        
    }else{
        if (_receiverMaskImage == nil) {
            UIImage *maskImage = [UIImage imageNamed:@"ReceiverTextNodeBkg"];
            _receiverMaskImage = [maskImage resizableImageWithCapInsets:UIEdgeInsetsMake(40, 14, 20, 20) resizingMode:UIImageResizingModeStretch];
        }
        image = _receiverMaskImage;
    }
    
    return image;
    
}

@end
