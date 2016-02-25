//
//  DFLineCellAdapterManager.h
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFBaseMessageCell.h"

#import "DFTextMessageCell.h"
#import "DFEmotionMessageCell.h"
#import "DFImageMessageCell.h"
#import "DFVoiceMessageCell.h"
#import "DFInfoNotifyMessageCell.h"
#import "DFLocationMessageCell.h"
#import "DFRedBagMessageCell.h"
#import "DFShareMessageCell.h"
#import "DFNameCardMessageCell.h"
#import "DFShortVideoMessageCell.h"

@protocol DFMessageClickDelegate <NSObject>

@required

-(void) onClick:(DFMessage *) message controller:(UINavigationController *) controller;

@end


@interface DFMessageCellManager : NSObject

+(instancetype) sharedInstance;

-(void) registerCell:(NSString *) contentType cellClass:(Class ) cellClass;

-(DFBaseMessageCell *) getCell:(NSString *) contentType;


-(void) registerMessageClickHandler:(NSString *) contentType delegate:(id<DFMessageClickDelegate>) delegate;

-(id<DFMessageClickDelegate>) getMessageClickHandler:(NSString *) contentType;

@end
