//
//  DFInfoNotifyMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/5.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFInfoNotifyMessageCell.h"

#import "DFInfoNotifyMessageContent.h"

#import "MLLabel+Size.h"

#define InfoLableVerticalAjust 10

#define InfoLabelFont [UIFont systemFontOfSize:13]

#define MsgViewLineHeightMulti 1.2f

@interface DFInfoNotifyMessageCell()

@property (strong, nonatomic) MLLinkLabel *infoLabel;

@end

@implementation DFInfoNotifyMessageCell

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
    if (_infoLabel == nil) {
        _infoLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.backgroundColor = [UIColor colorWithWhite:165/255.0 alpha:1.0];
        _infoLabel.font = InfoLabelFont;
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.numberOfLines = 0;
        _infoLabel.layer.cornerRadius = 3;
        _infoLabel.layer.masksToBounds = YES;
        _infoLabel.adjustsFontSizeToFitWidth = NO;
        _infoLabel.textInsets = UIEdgeInsetsZero;
        _infoLabel.lineHeightMultiple = MsgViewLineHeightMulti;
        
        [self.baseContentView addSubview:_infoLabel];
    }

    
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    CGFloat x, y ,width ,height;
    
    
    DFInfoNotifyMessageContent *infoNotifyMessage = (DFInfoNotifyMessageContent *) message.messageContent;
    CGSize size = infoNotifyMessage.size;
    width = size.width+InfoLableVerticalAjust;
    height = size.height+8;
    x= (CellWidth - width)/2;
    y= 0;
    _infoLabel.frame = CGRectMake(x, y, width, height);
    _infoLabel.text = infoNotifyMessage.content;
    
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    DFInfoNotifyMessageContent *infoNotifyMessage = (DFInfoNotifyMessageContent *)message.messageContent;
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:infoNotifyMessage.content];
    CGSize size = [MLLinkLabel getViewSize:attrString maxWidth:CellWidth*0.8 font:InfoLabelFont lineHeight:MsgViewLineHeightMulti lines:0];
    infoNotifyMessage.size = size;
    return size.height+InfoLableVerticalAjust + [super getCellHeight:message];
}



@end
