//
//  DFPackageEmotion.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/21.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBaseEmotion.h"
#import "DFPackageEmotionItem.h"

@interface DFPackageEmotion : DFBaseEmotion

- (instancetype)initWithIcon:(NSString *) icon total:(NSInteger) total items: (NSMutableArray *) items;

@end
