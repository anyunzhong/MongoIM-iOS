//
//  DFRongCloudMessageHandler.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/30.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFBaseMessageHandler.h"

@interface DFRongCloudMessageHandler : DFBaseMessageHandler

- (instancetype)initWithAppKey:(NSString *) appKey token:(NSString *) token;

@end
