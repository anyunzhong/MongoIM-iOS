//
//  DFChatViewController.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/17.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


//main components
#import "DFInputToolbarView.h"
#import "DFMessageTableView.h"
#import "DFPluginsView.h"
#import "DFEmotionsView.h"

#import "DFMessage.h"

#import "DFBaseViewController.h"


@interface DFMessageViewController : DFBaseViewController<UITableViewDelegate,UITableViewDataSource, DFInputToolbarViewDelegate, DFMessageTableViewDelegate>

- (instancetype)initWithTargetId:(NSString *) targetId conversationType:(ConversationType) conversationType;

-(void) addMessage:(DFMessage *) message;
-(void) addMessage:(DFMessage *) message updateStatus:(BOOL) updateStatus;


-(DFMessage *) getMessage:(NSUInteger)messageId;

-(DFMessage *) getMessageByRowIndex:(NSUInteger) rowIndex;

-(void) changeMessageStatus:(MessageSendStatus) status messageId:(NSUInteger) messageId;


-(void) reloadData;


-(BOOL) showUserNick;


-(void) sendMessage:(DFMessageContent *) content contentType:(NSString *) contentType;


@end
