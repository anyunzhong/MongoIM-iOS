//
//  DFTempTextMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/27.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFTextMessageCell.h"

#import "DFTextMessageContent.h"

#import "MLLabel+Size.h"
#import "DFEmotionsManager.h"
#import "NSString+MLExpression.h"
#import "DFTextBubbleView.h"


#define MsgViewLineHeightMulti 1.2f

#define TextBubbleMinWidth 30

#define TextFont [UIFont systemFontOfSize:16]


@interface DFTextMessageCell()

@property (strong,nonatomic) MLLinkLabel *textView;

@property (strong,nonatomic) DFTextBubbleView *bubbleView;

@property (strong,nonatomic) UIMenuItem *translateItem;

@end

@implementation DFTextMessageCell


#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
        
        _translateItem = [[UIMenuItem alloc] initWithTitle:@"翻译"action:@selector(menuTranslate:)];
    }
    return self;
}

-(void) initCell
{
    if (_bubbleView == nil) {
        _bubbleView = [[DFTextBubbleView alloc] initWithFrame:CGRectZero];
        [self.messageContentView addSubview:_bubbleView]; 
    }
    
    if (_textView == nil) {
        _textView =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _textView.textColor = [UIColor blackColor];
        _textView.font = TextFont;
        _textView.numberOfLines = 0;
        //_textView.textAlignment = NSTextAlignmentLeft;
        _textView.adjustsFontSizeToFitWidth = NO;
        _textView.textInsets = UIEdgeInsetsZero;
        _textView.lineHeightMultiple = MsgViewLineHeightMulti;
        
        _textView.dataDetectorTypes = MLDataDetectorTypeAll;
        _textView.allowLineBreakInsideLinks = NO;
        _textView.linkTextAttributes = nil;
        _textView.activeLinkTextAttributes = nil;
        [_bubbleView.contentView addSubview:_textView];
    }
    
}




-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    CGFloat x, y ,width ,height;
    
    
    DFTextMessageContent *textMessage = (DFTextMessageContent *) message.messageContent;
    
    //计算文字需要的范围
    NSAttributedString *text = [textMessage.text expressionAttributedStringWithExpression: [[DFEmotionsManager sharedInstance] sharedMLExpression]];
    CGSize textSize = textMessage.size;
    
    if (textSize.width == 0) {
        textSize = [MLLabel getViewSize:text maxWidth:MaxBubbleWidth-BubbleContentPadding font:TextFont lineHeight:MsgViewLineHeightMulti lines:0];
    }
    
    NSLog(@"直接获取高度");
    
    
    //气泡
    width = BubbleContentPadding + textSize.width;
    height = BubbleContentPadding + textSize.height;
    y= 0;
    if (self.isSender) {
        x= CGRectGetWidth(self.messageContentView.frame) - width;
        _bubbleView.direction = BubbleDirectionRight;
    }else{
        x= 0;
        _bubbleView.direction = BubbleDirectionLeft;
    }
    _bubbleView.frame = CGRectMake(x, y, width, height);
    
    
    //[super updateStatusViewFrame:_bubbleView];
    
    
    //文字
    x = 0;
    y = 0;
    width = textSize.width;
    height = textSize.height;
    _textView.frame = CGRectMake(x, y, width, height);
    //[_textView showMessage:textMessage.text];
    
    _textView.attributedText = text;
    [_textView sizeToFit];
    
    
}

-(CGSize) getMessageContentViewSize
{
    
    DFTextMessageContent *textMessage = (DFTextMessageContent *) self.message.messageContent;
    
    
    CGSize textSize = textMessage.size;
    
    if (textSize.width == 0) {
        NSAttributedString *text = [textMessage.text expressionAttributedStringWithExpression: [[DFEmotionsManager sharedInstance] sharedMLExpression]];
        textSize = [MLLabel getViewSize:text maxWidth:MaxBubbleWidth-BubbleContentPadding font:TextFont lineHeight:MsgViewLineHeightMulti lines:0];
    }
    return CGSizeMake(textSize.width+BubbleContentPadding, textSize.height+BubbleContentPadding);
}


-(CGFloat)getCellHeight:(DFMessage *)message
{
    
    DFTextMessageContent *textMessage = (DFTextMessageContent *) message.messageContent;
    
    //计算文字需要的范围
    NSAttributedString *text = [textMessage.text expressionAttributedStringWithExpression: [[DFEmotionsManager sharedInstance] sharedMLExpression]];
    CGSize textSize = [MLLinkLabel getViewSize:text maxWidth:MaxBubbleWidth-BubbleContentPadding font:TextFont lineHeight:MsgViewLineHeightMulti lines:0];
    textMessage.size = textSize;
    
    NSLog(@"生成高度");
    
    if (textSize.width < TextBubbleMinWidth) {
        textSize.width = TextBubbleMinWidth;
    }
    
    
    return textSize.height + BubbleContentPadding+[super getCellHeight:message];
}



#pragma mark - Method


- (void)menuTranslate:(id)sender
{
    NSLog(@"translate.....");
}

-(void)onMenuShow:(BOOL)show
{
    _bubbleView.selected = show;
}


-(NSArray *)getMenuActionSelector
{
    return @[@"menuTranslate:"];
}

-(void)onMenuCopy
{
    DFTextMessageContent *textMessage = (DFTextMessageContent *) self.message.messageContent;
    [UIPasteboard generalPasteboard].string = textMessage.text;
}

#pragma mark - DFBaseBubbleViewDelegate

-(void) onLongPress
{
    [self showMenu:@[self.copeeItem, _translateItem]];
}

@end
