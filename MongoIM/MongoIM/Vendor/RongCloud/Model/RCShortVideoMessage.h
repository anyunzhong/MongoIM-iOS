//
//  RCShortVideoMessage.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCShortVideoMessage : RCMessageContent
@property (nonatomic, strong) NSString *cover;
@property (nonatomic, strong) NSString *url;
@end
