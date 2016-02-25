//
//  DFTipMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFNotifyMessageContent.h"
#import <QuartzCore/QuartzCore.h>

@interface DFInfoNotifyMessageContent : DFNotifyMessageContent

@property (strong, nonatomic) NSString *content;

@property (assign, nonatomic) CGSize size;

@end
