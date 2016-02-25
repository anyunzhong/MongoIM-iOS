//
//  DFBaseBubbleView.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/24.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, BubbleDirection)
{
    BubbleDirectionRight,
    BubbleDirectionLeft,
};



#define BubbleContentPadding 40

@interface DFBaseBubbleView : UIView

@property (assign, nonatomic) BubbleDirection direction;

@property (strong, nonatomic) UIImageView *bgView;

@property (strong, nonatomic) UIView *contentView;

@property (assign, nonatomic) BOOL selected;

-(NSString *) getBgPath:(BubbleDirection)direction;
-(NSString *) getSelectedBgPath:(BubbleDirection)direction;

@end
