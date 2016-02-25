//
//  DFMessageStatusView.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/29.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFMessage.h"

@interface DFMessageStatusView : UIView

-(void) changeStatus:(MessageSendStatus)status;

@end
