//
//  DFMessageTableView.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/18.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DFMessageTableViewDelegate <NSObject>

@optional

-(void) onPullDown;

@end
@interface DFMessageTableView : UITableView

@property (weak, nonatomic) id<DFMessageTableViewDelegate> messageDelegate;

-(void) onLoadFinish;

@end
