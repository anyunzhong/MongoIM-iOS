//
//  MongoIMClient.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/29.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMessage.h"

@interface MongoIMClient : NSObject

+(instancetype) sharedInstance;

-(void) sendMessage:(DFMessage *) message;

-(NSMutableArray *)getMessages:(ConversationType)type targetId:(NSString *)targetId start:(NSUInteger)start size:(NSUInteger)size;

@end
