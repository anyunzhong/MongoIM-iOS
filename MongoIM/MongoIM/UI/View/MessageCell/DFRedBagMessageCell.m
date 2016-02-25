//
//  DFRedBagMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#define TitleTextFont [UIFont systemFontOfSize:15]
#define DescTextFont [UIFont systemFontOfSize:12]
#define SignTextFont [UIFont systemFontOfSize:11]

#define ThumbSize 60
#define UnitPadding 5

#define BubbleHeight 100

#import "DFRedBagMessageCell.h"
#import "DFMoneyBubbleView.h"

#import "DFRedBagMessageContent.h"

#import "DFMessageCell.h"

@interface DFRedBagMessageCell()

@property (strong,nonatomic) DFMoneyBubbleView *bubbleView;


@property (strong,nonatomic) UILabel *titleLabel;

@property (strong,nonatomic) UILabel *descLabel;

@property (strong, nonatomic) UIImageView *iconView;


@property (strong,nonatomic) UILabel *signLabel;


@end


@implementation DFRedBagMessageCell

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
        _bubbleView = [[DFMoneyBubbleView alloc] initWithFrame:CGRectZero];
        [self.messageContentView addSubview:_bubbleView];
    }
    
    if (_titleLabel == nil) {
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = TitleTextFont;
        _titleLabel.textColor = [UIColor whiteColor];
        [_bubbleView.contentView addSubview:_titleLabel];
        
        //_titleLabel.backgroundColor =[UIColor darkGrayColor];
    }
    
    if (_descLabel == nil) {
        _descLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.font = DescTextFont;
        _descLabel.textColor = [UIColor whiteColor];
        [_bubbleView.contentView addSubview:_descLabel];
        //_descLabel.backgroundColor =[UIColor redColor];
    }
    
    
    if (_signLabel == nil) {
        _signLabel =[[UILabel alloc] initWithFrame:CGRectZero];
        _signLabel.font = SignTextFont;
        _signLabel.textColor = [UIColor lightGrayColor];
        [_bubbleView.contentView addSubview:_signLabel];
        // _signLabel.backgroundColor = [UIColor greenColor];
    }
    
    if (_iconView == nil) {
        _iconView =[[UIImageView alloc] initWithFrame:CGRectZero];
        [_bubbleView.contentView addSubview:_iconView];
    }
    
    
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    DFRedBagMessageContent *bagMessage = (DFRedBagMessageContent *) message.messageContent;
    
    CGFloat x, y ,width ,height;
    
    //气泡
    width = MaxBubbleWidth;
    height = BubbleHeight;
    y= 0;
    x= 0;
    if (self.isSender) {
        _bubbleView.direction = BubbleDirectionRight;
    }else{
        _bubbleView.direction = BubbleDirectionLeft;
    }
    _bubbleView.frame = CGRectMake(x, y, width, height);
    
    
    x = 5;
    y= 2;
    width = 37.5;
    height = 41;
    _iconView.frame = CGRectMake(x, y, width, height);
    _iconView.image = [UIImage imageNamed:@"RedBag"];
    
    x = CGRectGetMaxX(_iconView.frame) + 7;
    y = CGRectGetMinY(_iconView.frame) + 1;
    width = 140;
    height = 20;
    _titleLabel.frame = CGRectMake(x, y, width, height);
    _titleLabel.text = bagMessage.title;
    
    x = CGRectGetMinX(_titleLabel.frame);
    y = CGRectGetMaxY(_titleLabel.frame) + 2;
    height = 20;
    width = CGRectGetWidth(_titleLabel.frame);
    _descLabel.frame = CGRectMake(x, y, width, height);
    _descLabel.text = bagMessage.desc;
    
    
    x = 2;
    y = 59;
    height = 20;
    width = 100;
    _signLabel.frame = CGRectMake(x, y, width, height);
    _signLabel.text = bagMessage.sign;
    
    
    
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