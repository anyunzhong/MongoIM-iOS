//
//  DFDefaultMessageHandler.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/29.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFBaseMessageHandler.h"

@interface DFMongoMessageHandler : DFBaseMessageHandler

- (instancetype)initWithSenderId:(NSString *) senderId;

@end
