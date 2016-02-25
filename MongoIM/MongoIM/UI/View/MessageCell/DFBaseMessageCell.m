//
//  DFCommonMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/27.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFBaseMessageCell.h"

#import "DFToolUtil.h"

#import "MLLabel+Size.h"

#import "DFBaseBubbleView.h"

#import "DFMessageCellManager.h"

#define TimeLabelFont [UIFont systemFontOfSize:11]

#define TimeLabelTopMargin 10
#define TimeLabelHeight 20
#define TimeLabelBottomMargin 10

#define CellSpace 5


@interface DFBaseMessageCell()

@property (strong, nonatomic) UILabel *timeLabel;

@property (assign, nonatomic) BOOL bIsMenuShow;

@end



@implementation DFBaseMessageCell

#pragma mark - Lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bIsMenuShow = NO;
        
        [self initBaseCell];
        [self addNotify];
        
        [self initMenuItem];
    }
    return self;
}

-(void)dealloc
{
    [self removeNotify];
}

-(void) addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuShown:) name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMenuHide:) name:UIMenuControllerWillHideMenuNotification object:nil];
}

-(void) removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillShowMenuNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIMenuControllerWillHideMenuNotification object:nil];
}


-(void) initMenuItem
{
    if (_copeeItem == nil) {
        _copeeItem = [[UIMenuItem alloc] initWithTitle:@"复制"action:@selector(menuCopy:)];
    }
    if (_forwardItem == nil) {
        _forwardItem = [[UIMenuItem alloc] initWithTitle:@"转发"action:@selector(menuForward:)];
    }
    if (_collectItem == nil) {
        _collectItem = [[UIMenuItem alloc] initWithTitle:@"收藏"action:@selector(menuCollect:)];
    }
    
    if (_cancelItem == nil) {
        _cancelItem = [[UIMenuItem alloc] initWithTitle:@"撤回"action:@selector(menuCancel:)];
    }
    
    if (_deleteItem == nil) {
        _deleteItem = [[UIMenuItem alloc] initWithTitle:@"删除"action:@selector(menuDelete:)];
    }
    
    if (_moreItem == nil) {
        _moreItem = [[UIMenuItem alloc] initWithTitle:@"更多..."action:@selector(menuMore:)];
    }
    
}





-(void) initBaseCell

{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor =[UIColor clearColor];
    
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.backgroundColor = [UIColor colorWithWhite:165/255.0 alpha:1.0];
        _timeLabel.layer.cornerRadius = 3;
        _timeLabel.layer.masksToBounds = YES;
        _timeLabel.font = TimeLabelFont;
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.hidden = YES;
    }
    
    if (_baseContentView == nil) {
        _baseContentView = [[UIView alloc] initWithFrame:CGRectZero];
        //_baseContentView.backgroundColor = [UIColor colorWithWhite:245/255.0 alpha:1.0];
        [self.contentView addSubview:_baseContentView];
    }
    
}

-(void)updateWithMessage:(DFMessage *)message
{
    _message = message;
    
    _isSender =message.direction == MessageDirectionSend;
    
    
    CGFloat x, y ,width ,height, sumHeight;
    sumHeight=0;
    
    //时间
    if (message.showTime) {
        _timeLabel.hidden = NO;
        
        NSString *time = [DFToolUtil preettyTime:message.sentTime];
        
        CGSize size = [MLLabel getViewSizeByString:time font:TimeLabelFont];
        width = size.width+6;
        height = TimeLabelHeight;
        x= (CellWidth - width)/2;
        y= TimeLabelTopMargin;
        _timeLabel.frame = CGRectMake(x, y, width, height);
        _timeLabel.text = time;
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        
        sumHeight = TimeLabelTopMargin+TimeLabelHeight+TimeLabelBottomMargin;
        
    }else{
        _timeLabel.hidden = YES;
    }
    
    //容器
    x=0;
    y=sumHeight;
    width = CellWidth;
    height = [self getBaseContentViewHeight];
    _baseContentView.frame = CGRectMake(x, y, width, height);
    
}


-(CGFloat)getBaseContentViewHeight
{
    return 0;
}

-(CGFloat) getReuseCellHeight:(DFMessage *)message
{
    if (message.cellHeight != 0) {
        //NSLog(@"重用高度 %f", message.cellHeight);
        return message.cellHeight;
    }
    CGFloat height = [self getCellHeight:message];
    message.cellHeight = height;
    //NSLog(@"计算高度 %f", message.cellHeight);
    return height;
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    if (message.showTime) {
        return TimeLabelTopMargin+TimeLabelHeight+TimeLabelBottomMargin+CellSpace;
    }
    
    return CellSpace;
}




#pragma mark - Menu

-(void) onMenuShown:(NSNotification *) notify
{
    
    if (self.bIsMenuShow) {
        [self onMenuShow:YES];
    }
}

-(void) onMenuHide:(NSNotification *) notify
{
    if (self.bIsMenuShow) {
        [self onMenuShow:NO];
    }
    self.bIsMenuShow = NO;
}


-(void)onMenuShow:(BOOL)show
{
    
}


-(BOOL) canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    
    NSArray *selectors = [self getMenuActionSelector];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:@"menuDelete:"];
    [array addObject:@"menuCopy:"];
    [array addObject:@"menuCancel:"];
    [array addObject:@"menuForward:"];
    //[array addObject:@"menuCollect:"];
    
    for (NSString *str in selectors) {
        [array addObject:str];
    }
    
    if (array == nil) {
        return NO;
    }
    
    for (NSString *s in array) {
        if (action == NSSelectorFromString(s)) {
            return YES;
        }
    }
    return NO;
}

-(NSArray *) getMenuActionSelector
{
    return @[];
}

-(void) showMenu:(NSArray *)items
{
    [self showMenu:items withDefault:YES];
}

-(void)showCustomMenu:(NSArray *)items
{
    [self showMenu:items withDefault:NO];
}

-(void) showMenu:(NSArray *)items withDefault:(BOOL) withDefault
{
    self.bIsMenuShow = YES;
    
    [self becomeFirstResponder];
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    
    if (withDefault) {
        NSMutableArray *array = [NSMutableArray array];
        [array addObject:_deleteItem];
        //[array addObject:_copeeItem];
        //[array addObject:_cancelItem];
        //[array addObject:_forwardItem];
        //[array addObject:_collectItem];
        //[array addObject:_moreItem];
        
        for (UIMenuItem *item in items) {
            [array addObject:item];
        }
        [menu setMenuItems:array];
    }else{
        [menu setMenuItems:items];
    }

    
    
    CGFloat x, y, width,height;
    x = 0;
    y = 0;
    width = _baseContentView.frame.size.width;
    height = _baseContentView.frame.size.height;
    [menu setTargetRect:CGRectMake(x, y, width, height) inView:_baseContentView];
    [menu setMenuVisible:YES animated:YES];
    [menu setArrowDirection:UIMenuControllerArrowDown];
}

-(void)onSigleTap
{
    if (self.bIsMenuShow) {
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuVisible:NO animated:YES];
    }else{
        //普通单击
        id handler = [[DFMessageCellManager sharedInstance] getMessageClickHandler:self.message.contentType];
        if (handler != nil && [handler respondsToSelector:@selector(onClick:controller:)]) {
            [handler onClick:self.message controller:[self getController]];
        }else{
            [self onClick:self.message controller:[self getController]];
        }

        
    }
    
}

-(UINavigationController *)getController
{
    UITableView *tableView = (UITableView *)self.superview.superview;
    UIViewController *controller = (UIViewController *)tableView.dataSource;
    return controller.navigationController;
}

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    
}


-(void)onMenuCopy
{
    
}


#pragma mark - MenuAction

- (void)menuCopy:(id)sender
{
    NSLog(@"copy.....");
    [self onMenuCopy];
}

- (void)menuForward:(id)sender
{
    NSLog(@"forward.....");
}

- (void)menuCollect:(id)sender
{
    NSLog(@"collect.....");
}

- (void)menuCancel:(id)sender
{
    NSLog(@"cancel.....");
}

- (void)menuDelete:(id)sender
{
    NSLog(@"delete.....");
    
    if (_delegate && [_delegate respondsToSelector:@selector(onDeleteMessage:)]) {
        [_delegate onDeleteMessage:_message.messageId];
    }
    
}

- (void)menuMore:(id)sender
{
    NSLog(@"more.....");
}

@end
