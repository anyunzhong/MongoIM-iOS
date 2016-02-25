//
//  DFShareMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import <QuartzCore/QuartzCore.h>

@interface DFShareMessageContent : DFMediaMessageContent

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *sourceLogo;
@property (strong, nonatomic) NSString *sourceName;


@property (assign, nonatomic) CGFloat titleHeight;
@property (assign, nonatomic) CGFloat descHeight;


@end
