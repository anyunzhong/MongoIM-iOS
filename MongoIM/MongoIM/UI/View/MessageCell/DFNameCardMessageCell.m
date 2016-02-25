//
//  DFNameCardMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFNameCardMessageCell.h"
#import "DFShareBubbleView.h"

#import "DFNameCardMessageContent.h"

#import "MLLabel+Size.h"
#import "UIImageView+WebCache.h"

#define BubbleHeight 115

#define Margin 20

#define AvatarSize 45

@interface DFNameCardMessageCell()

@property (strong,nonatomic) DFShareBubbleView *bubbleView;


@property (strong,nonatomic) UILabel *nickLabel;
@property (strong,nonatomic) UILabel *numLabel;

@property (strong,nonatomic) UIImageView *avatarView;

@end

@implementation DFNameCardMessageCell

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
    
    CGFloat x, y, width, height;
    
    //bubble
    x=0;
    y=0;
    width = MaxBubbleWidth;
    height = BubbleHeight;
    
    if (_bubbleView == nil) {
        _bubbleView = [[DFShareBubbleView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.messageContentView addSubview:_bubbleView];
    }
    
    x = Margin;
    y = Padding;
    width = 50;
    height = 25;
    
    //[名片]
    UILabel *namecardLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    namecardLabel.font = [UIFont systemFontOfSize:16];
    namecardLabel.text = @"名片";
    namecardLabel.textColor = [UIColor darkGrayColor];
    [_bubbleView addSubview:namecardLabel];
    
    
    //divider
    y = CGRectGetMaxY(namecardLabel.frame)+2;
    width = MaxBubbleWidth - 2*Margin;
    height = 0.4;
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    line.backgroundColor = [UIColor colorWithWhite:220/255.0 alpha:1.0];
    [_bubbleView addSubview:line];
    
    
    //头像
    y = CGRectGetMaxY(line.frame) +10;
    width = AvatarSize;
    height = width;
    _avatarView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_bubbleView addSubview:_avatarView];
    
    
    //昵称
    x = CGRectGetMaxX(_avatarView.frame) + 10;
    y = CGRectGetMinY(_avatarView.frame);
    width = 130;
    height = 25;
    _nickLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _nickLabel.font = [UIFont systemFontOfSize:16];
    _nickLabel.textColor = [UIColor darkGrayColor];
    [_bubbleView addSubview:_nickLabel];
    
    
    //号码
    x = CGRectGetMaxX(_avatarView.frame) + 10;
    y = CGRectGetMinY(_avatarView.frame)+22;
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _numLabel.font = [UIFont systemFontOfSize:13];
    _numLabel.textColor = [UIColor lightGrayColor];
    [_bubbleView addSubview:_numLabel];

    
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    if (self.isSender) {
        _bubbleView.direction = BubbleDirectionRight;
    }else{
        _bubbleView.direction = BubbleDirectionLeft;
    }
    
    DFNameCardMessageContent *nameCardMessage = (DFNameCardMessageContent *)message.messageContent;
    
    [_avatarView sd_setImageWithURL:[NSURL URLWithString:nameCardMessage.userAvatar]];

    _nickLabel.text = nameCardMessage.userNick;
    _numLabel.text = nameCardMessage.userNum;
    
}

-(CGSize)getMessageContentViewSize
{
    return CGSizeMake(MaxBubbleWidth, BubbleHeight);
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    return BubbleHeight + [super getCellHeight:message];
}


-(void)onMenuShow:(BOOL)show
{
    _bubbleView.selected = show;
}

@end