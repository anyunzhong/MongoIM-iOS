//
//  DFRecentMessageCell.m
//  coder
//
//  Created by Allen Zhong on 15/5/5.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFConversationCell.h"

#import "UIImageView+WebCache.h"

#import "DFToolUtil.h"

#import "JSBadgeView.h"

#import "DFUserInfo.h"
#import "MongoIM.h"

#define CellHeight 70

#define TimeLabelWidth 70

#define AvatarLeftPadding 15
#define AvatarRightPadding 12
#define AvatarVerticalPadding 12

#define BadgeViewSize 18

@interface DFConversationCell()<SWTableViewCellDelegate>

@property (nonatomic,strong) UIImageView *avatarImageView;
@property (nonatomic,strong) UIView *avatarMaskView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *subTitleLabel;
@property (nonatomic,strong) UILabel *timeLabel;

@property (nonatomic,strong) JSBadgeView *badgeView;

@property (nonatomic, strong) DFConversation *conversation;

@property (strong, nonatomic) DFUserInfo *userinfo;

@end


@implementation DFConversationCell

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
    //滑动cell
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor] title:@"删除"];
    self.rightUtilityButtons = rightUtilityButtons;
    self.delegate = self;
    
    
    CGFloat x, y, width, height;
    
    if (_avatarImageView == nil) {
        x = AvatarLeftPadding;
        y = AvatarVerticalPadding;
        height = (CellHeight - 2*AvatarVerticalPadding);
        width = height;
        _avatarImageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _avatarImageView.layer.cornerRadius = 5;
        _avatarImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_avatarImageView];
    }
    
    if (_avatarMaskView == nil) {
        _avatarMaskView = [[UIView alloc] initWithFrame:_avatarImageView.frame];
        [self.contentView addSubview:_avatarMaskView];
    }
    
    if (_titleLabel == nil) {
        
        x = CGRectGetMaxX(_avatarImageView.frame) + AvatarRightPadding;
        y = CGRectGetMinY(_avatarImageView.frame)+3;
        width = [UIScreen mainScreen].bounds.size.width - x - TimeLabelWidth;
        height = 20;
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _titleLabel.font = [UIFont systemFontOfSize:17];
        [self.contentView addSubview:_titleLabel];
    }
    
    if (_subTitleLabel == nil) {
        
        x = CGRectGetMinX(_titleLabel.frame);
        y = CGRectGetMaxY(_titleLabel.frame)+6;
        width = CGRectGetWidth(_titleLabel.frame);
        height = 20;
        _subTitleLabel =[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _subTitleLabel.textColor = [UIColor lightGrayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_subTitleLabel];
    }
    
    if (_timeLabel == nil) {
        
        x = [UIScreen mainScreen].bounds.size.width - TimeLabelWidth - 9;
        y = 11;
        width = TimeLabelWidth;
        height = 15;
        _timeLabel =[[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_timeLabel];
    }
    
    if (_badgeView == nil) {
        x = CGRectGetMaxX(_avatarImageView.frame) - BadgeViewSize/2;
        y = CGRectGetMinY(_avatarImageView.frame) - BadgeViewSize/2;
        width = BadgeViewSize;
        height = width;
        _badgeView = [[JSBadgeView alloc] initWithParentView:_avatarMaskView alignment:JSBadgeViewAlignmentTopRight];
        [_badgeView setBadgeTextFont:[UIFont boldSystemFontOfSize:11]];
        [_avatarMaskView addSubview:_badgeView];
        
    }
    
}

-(void)updateWithConversation:(DFConversation *)conversation
{
    _conversation = conversation;
    
    if (_userinfo == nil) {
        
        __weak DFConversationCell *weakself = self;
        
        NSString *targetId = conversation.targetId;
        UserInfoCallback callback = ^(DFUserInfo *userinfo){
            
            _userinfo = userinfo;
            
            if (userinfo.avatar != nil && ![userinfo.avatar isEqualToString:@""]) {
                [weakself.avatarImageView sd_setImageWithURL:[NSURL URLWithString:userinfo.avatar]];
            }else{
                weakself.avatarImageView.image = [UIImage imageNamed:@"DefaultHead"];
            }
            weakself.titleLabel.text = userinfo.nick;
            conversation.title = userinfo.nick;
        };
        
        UserInfoProvider provider = [MongoIM sharedInstance].userInfoProvider;
        provider(targetId, callback);
        
    }else{
        if (_userinfo.avatar != nil && ![_userinfo.avatar isEqualToString:@""]) {
            [_avatarImageView sd_setImageWithURL:[NSURL URLWithString:_userinfo.avatar]];
        }else{
            _avatarImageView.image = [UIImage imageNamed:@"DefaultHead"];
        }
        _titleLabel.text = _userinfo.nick;

    }
    
    
    
    _subTitleLabel.text = conversation.subTitle;
    _timeLabel.text = [DFToolUtil preettyTime:conversation.updateTime];
    
    _badgeView.hidden = conversation.unreadCount >0 ? NO:YES;
    _badgeView.badgeText = [NSString stringWithFormat:@"%lu", (unsigned long)conversation.unreadCount];
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
            if (_cellDelegate && [_cellDelegate respondsToSelector:@selector(onDeleteConversation:)]) {
                [_cellDelegate onDeleteConversation:_conversation];
            }
            break;
            
        default:
            break;
    }
}


+(CGFloat)getCellHeight
{
    return CellHeight;
}

@end
