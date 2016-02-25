//
//  MIMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/20.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+JSON.h"

@interface DFMessageContent : NSObject

-(NSData *) encode;
-(NSString *) toJson;
-(void) decode:(NSData *) data;
@end
