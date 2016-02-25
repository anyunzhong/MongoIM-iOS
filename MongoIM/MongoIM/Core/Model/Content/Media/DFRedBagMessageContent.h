//
//  DFRedBagMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"

@interface DFRedBagMessageContent : DFMediaMessageContent

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSString *sign;

@end
