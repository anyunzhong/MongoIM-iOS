//
//  DFMessageStatusView.h
//  coder
//
//  Created by Allen Zhong on 15/5/14.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectionStatus.h"


#define BarStatusViewWidth 100
#define BarStatusViewHeight 25

@interface DFBarStatusView : UIView

@property (nonatomic, assign) NSUInteger unreadCount;

-(void) changeStatus:(CONNECTION_STATUS) status;

@end
