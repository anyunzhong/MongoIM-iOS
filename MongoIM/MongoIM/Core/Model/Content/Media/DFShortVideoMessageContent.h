//
//  DFShortVideoMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import <UIKit/UIKit.h>
#import "DFVideoDecoder.h"

@interface DFShortVideoMessageContent : DFMediaMessageContent

@property (nonatomic, strong) UIImage *cover;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) DFVideoDecoder *decorder;



@end
