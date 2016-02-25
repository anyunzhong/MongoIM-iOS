//
//  DFShareMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/8.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFShareMessageCell.h"
#import "DFShareBubbleView.h"

#import "DFShareMessageContent.h"

#import "MLLabel+Size.h"
#import "UIImageView+WebCache.h"

#import "DFWebViewController.h"

#define TitleTextFont [UIFont systemFontOfSize:16]
#define DescTextFont [UIFont systemFontOfSize:14]

#define ThumbSize 60
#define UnitPadding 5

#define DescAndThumbHeight 100

#define SourceHeight 20

#define DescLineHeightMulti 1.2f
#define TitleLineHeightMulti 1.1f

#define DescLabelMaxLines 3


#define LogoSize 13

@interface DFShareMessageCell()

@property (strong,nonatomic) DFShareBubbleView *bubbleView;


@property (strong,nonatomic) MLLinkLabel *titleLabel;
@property (strong,nonatomic) MLLinkLabel *descLabel;

@property (strong,nonatomic) UIImageView *thumbView;

@property (strong, nonatomic) UIView *sourceContainer;
@property (strong, nonatomic) UIImageView *sourceLogo;
@property (strong, nonatomic) UILabel *sourceName;

@end

@implementation DFShareMessageCell

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
        _bubbleView = [[DFShareBubbleView alloc] initWithFrame:CGRectZero];
        [self.messageContentView addSubview:_bubbleView];
    }

    
    if (_titleLabel == nil) {
        _titleLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.font = TitleTextFont;
        _titleLabel.numberOfLines = 0;
        _titleLabel.adjustsFontSizeToFitWidth = NO;
        _titleLabel.textInsets = UIEdgeInsetsZero;
        _titleLabel.lineHeightMultiple = TitleLineHeightMulti;
        
        [_bubbleView.contentView addSubview:_titleLabel];
    }

    
    
    if (_descLabel == nil) {
        _descLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _descLabel.textColor = [UIColor lightGrayColor];
        _descLabel.font = DescTextFont;
        _descLabel.numberOfLines = DescLabelMaxLines;
        _descLabel.adjustsFontSizeToFitWidth = NO;
        _descLabel.textInsets = UIEdgeInsetsZero;
        _descLabel.lineHeightMultiple = DescLineHeightMulti;
        
        [_bubbleView.contentView addSubview:_descLabel];
    }

    
    if (_thumbView == nil) {
        _thumbView =[[UIImageView alloc] initWithFrame:CGRectZero];
        [_bubbleView.contentView addSubview:_thumbView];
    }
    
    if (_sourceContainer == nil) {
        _sourceContainer = [[UIView alloc] initWithFrame:CGRectZero];
        _sourceContainer.backgroundColor = [UIColor colorWithWhite:210/255.0 alpha:1.0];
        _sourceContainer.layer.cornerRadius = 3;
        _sourceContainer.layer.masksToBounds = YES;
        [self.messageContentView addSubview:_sourceContainer];
        
        _sourceLogo = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_sourceContainer addSubview:_sourceLogo];
        
        _sourceName = [[UILabel alloc] initWithFrame:CGRectZero];
        _sourceName.textColor = [UIColor whiteColor];
        _sourceName.font = [UIFont systemFontOfSize:11];
        [_sourceContainer addSubview:_sourceName];
    }
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    DFShareMessageContent *shareMessage = (DFShareMessageContent *) message.messageContent;
    
    CGFloat x, y ,width ,height;
    
    //气泡
    width = MaxBubbleWidth;
    height = shareMessage.titleHeight + DescAndThumbHeight;
    y= 0;
    x= 0;
    if (self.isSender) {
        _bubbleView.direction = BubbleDirectionRight;
    }else{
        _bubbleView.direction = BubbleDirectionLeft;
    }
    _bubbleView.frame = CGRectMake(x, y, width, height);
    
    
    x = 0;
    y = -5;
    width = MaxBubbleWidth-BubbleContentPadding;
    height = shareMessage.titleHeight;
    _titleLabel.frame = CGRectMake(x, y, width, height);
    _titleLabel.text = shareMessage.title;
    
    y = CGRectGetMaxY(_titleLabel.frame) + UnitPadding;
    width = ThumbSize;
    height = width;
    _thumbView.frame = CGRectMake(x, y, width, height);
    [_thumbView sd_setImageWithURL:[NSURL URLWithString:shareMessage.thumb]];
    
    x = CGRectGetMaxX(_thumbView.frame) + UnitPadding;
    y = CGRectGetMinY(_thumbView.frame)-2;
    width = MaxBubbleWidth-BubbleContentPadding - ThumbSize - UnitPadding;

    if (shareMessage.descHeight == 0) {
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:shareMessage.desc];
        CGSize size = [MLLinkLabel getViewSize:attrString maxWidth:width font:DescTextFont lineHeight:DescLineHeightMulti lines:DescLabelMaxLines];
        shareMessage.descHeight = size.height;
    }
   
    height = shareMessage.descHeight;
    
    _descLabel.frame = CGRectMake(x, y, width, height);
    
    _descLabel.text = shareMessage.desc;

    if ([shareMessage.sourceName isEqualToString:@""]) {
        shareMessage.sourceName = @"未知来源";
    }
    
    CGSize sourceNameSize = [MLLabel getViewSizeByString:shareMessage.sourceName maxWidth:MaxBubbleWidth-BubbleContentPadding font:DescTextFont];
    x=6;
    y=CGRectGetMaxY(_bubbleView.frame)-5;
    width = LogoSize + sourceNameSize.width+10;
    height = 20;
    _sourceContainer.frame = CGRectMake(x, y, width, height);
    
    x=3;
    y=3;
    width = LogoSize;
    height = LogoSize;
    _sourceLogo.frame = CGRectMake(x, y, width, height);
    if ([shareMessage.sourceLogo isEqualToString:@""]) {
        _sourceLogo.image = [UIImage imageNamed:@"fileicon_link"];
    }else{
        [_sourceLogo sd_setImageWithURL:[NSURL URLWithString:shareMessage.sourceLogo]];
    }
    
    
    x = CGRectGetMaxX(_sourceLogo.frame) +5;
    width = sourceNameSize.width;
    _sourceName.frame = CGRectMake(x, y, width, height);
    _sourceName.text = shareMessage.sourceName;
    
}

-(CGSize)getMessageContentViewSize
{
     DFShareMessageContent *shareMessage = (DFShareMessageContent *) self.message.messageContent;
    return CGSizeMake(MaxBubbleWidth, shareMessage.titleHeight + DescAndThumbHeight+SourceHeight);
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    DFShareMessageContent *shareMessage = (DFShareMessageContent *) message.messageContent;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:shareMessage.title];
    CGSize size = [MLLinkLabel getViewSize:attrString maxWidth:MaxBubbleWidth-BubbleContentPadding font:TitleTextFont lineHeight:TitleLineHeightMulti lines:0];
    shareMessage.titleHeight = size.height;
    return size.height + DescAndThumbHeight + SourceHeight + [super getCellHeight:message];
}

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    DFShareMessageContent *shareMessage = (DFShareMessageContent *)message.messageContent;
    DFWebViewController *webViewController = [[DFWebViewController alloc] initWithUrl:shareMessage.link title:shareMessage.title];
    [controller pushViewController:webViewController animated:YES];
}


-(void)onMenuShow:(BOOL)show
{
    _bubbleView.selected = show;
}

@end
