//
//  DFImageMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import <UIKit/UIKit.h>

@interface DFImageMessageContent : DFMediaMessageContent

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) UIImage *originImage;
@property (strong, nonatomic) UIImage *thumbImage;

@property (assign, nonatomic) NSUInteger width;
@property (assign, nonatomic) NSUInteger height;


@end
