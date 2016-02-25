//
//  DFCommonMessageCell.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/27.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DFMessage.h"

#define CellWidth [UIScreen mainScreen].bounds.size.width

@protocol DFBaseMessageCellDelegate <NSObject>

@optional

-(void) onDeleteMessage:(NSUInteger)messageId;

@end

@interface DFBaseMessageCell : UITableViewCell

@property (weak, nonatomic) id<DFBaseMessageCellDelegate> delegate;

@property (strong, nonatomic) DFMessage *message;
@property (assign, nonatomic) BOOL isSender;
@property (strong, nonatomic) UIView *baseContentView;

@property (strong,nonatomic) UIMenuItem *copeeItem;
@property (strong,nonatomic) UIMenuItem *forwardItem;
@property (strong,nonatomic) UIMenuItem *collectItem;
@property (strong,nonatomic) UIMenuItem *cancelItem ;
@property (strong,nonatomic) UIMenuItem *deleteItem ;
@property (strong,nonatomic) UIMenuItem *moreItem;



-(void) updateWithMessage:(DFMessage *) message;
-(CGFloat) getCellHeight:(DFMessage *) message;
-(CGFloat) getReuseCellHeight:(DFMessage *) message;



-(CGFloat) getBaseContentViewHeight;

-(void) onClick:(DFMessage *) message controller:(UINavigationController *) controller;

-(UINavigationController *) getController;

//menu相关

-(void) onMenuShow:(BOOL) show;

-(void) showMenu:(NSArray *) items;

-(void) showCustomMenu:(NSArray *) items;

-(void) onSigleTap;

- (void)onMenuCopy;

@end
