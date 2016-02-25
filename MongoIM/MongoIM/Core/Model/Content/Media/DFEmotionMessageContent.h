//
//  DFEmotionMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import "DFPackageEmotionItem.h"

@interface DFEmotionMessageContent : DFMediaMessageContent

@property (strong, nonatomic)  DFPackageEmotionItem *emotionItem;

@end
