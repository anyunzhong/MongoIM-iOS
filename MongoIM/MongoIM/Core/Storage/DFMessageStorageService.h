//
//  DFMessageStorageService.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMessage.h"
#import "DFCommonStorageService.h"

@interface DFMessageStorageService : DFCommonStorageService

+(instancetype) sharedInstance;


-(void) insertMessage:(DFMessage *) message;

-(NSMutableArray *) getMessages: (ConversationType) type targetId:(NSString *) targetId start:(NSUInteger) start size:(NSUInteger)size;


@end
