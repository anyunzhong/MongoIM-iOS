//
//  DFRecentMessageCell.h
//  coder
//
//  Created by Allen Zhong on 15/5/5.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFConversation.h"
#import "SWTableViewCell.h"


@protocol DFConversationCellDelegate <NSObject>

@optional

-(void) onDeleteConversation:(DFConversation *) conversation;

@end

@interface DFConversationCell : SWTableViewCell

@property (weak, nonatomic) id<DFConversationCellDelegate> cellDelegate;

+(CGFloat) getCellHeight;

-(void) updateWithConversation:(DFConversation *) conversation;

@end
