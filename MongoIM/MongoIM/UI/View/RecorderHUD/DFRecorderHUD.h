//
//  DFRecorderHUD.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/26.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, RecorderHudState)
{
    RecorderHudStateNormal,
    RecorderHudStateCancel,
};


@interface DFRecorderHUD : UIView

@property (nonatomic, assign) NSUInteger signalLevel;

@property (nonatomic, assign) RecorderHudState hudState;

@end
