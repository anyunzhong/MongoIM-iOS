//
//  DFBaseEmotion.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define EmotionViewPageWidth [UIScreen mainScreen].bounds.size.width
#define EmotionViewPageHeight 179


@interface DFBaseEmotion : NSObject

@property (nonatomic, strong) NSString *tabIconLocal;

@property (nonatomic, strong) NSString *tabIconUrl;

@property (nonatomic, assign) NSUInteger pages;

@property (nonatomic, assign) NSUInteger total;

@property (nonatomic, assign) CGFloat xOffset;

@property (nonatomic, assign) NSInteger pageIndexOffset;



-(UIView *) getView;

@end
