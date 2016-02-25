//
//  DFMessageContentManager.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMessageContent.h"

@interface DFMessageContentManager : NSObject

+(instancetype) sharedInstance;

-(void) register:(NSString *) type messageContent:(DFMessageContent *) messageContent;
-(DFMessageContent *) create:(NSString *)type;

@end
