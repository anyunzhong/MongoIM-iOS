//
//  RCShareMessage.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/8.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCShareMessage : RCMessageContent

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *thumb;
@property (strong, nonatomic) NSString *link;
@property (strong, nonatomic) NSString *sourceLogo;
@property (strong, nonatomic) NSString *sourceName;

@end
