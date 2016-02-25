//
//  MITextMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import <QuartzCore/QuartzCore.h>

@interface DFTextMessageContent : DFMessageContent

@property (strong, nonatomic) NSString *text;

@property (assign, nonatomic) CGSize size;

@end
