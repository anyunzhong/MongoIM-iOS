//
//  MongoToRongCloudMessageContentAdapterManager.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MongoToRongCloudImageMessageContentAdapter.h"

#import "MongoToRongCloudTextMessageContentAdapter.h"
#import "MongoToRongCloudVoiceMessageContentAdapter.h"
#import "MongoToRongCloudImageMessageContentAdapter.h"
#import "MongoToRongCloudLocationMessageContentAdapter.h"
#import "MongoToRongCloudRedBagMessageContentAdapter.h"
#import "MongoToRongCloudEmotionMessageContentAdapter.h"
#import "MongoToRongCloudShareMessageContentAdapter.h"
#import "MongoToRongCloudNameCardMessageContentAdapter.h"
#import "MongoToRongCloudShortVideoMessageContentAdapter.h"

@interface MongoToRongCloudMessageContentAdapterManager : NSObject

+(instancetype) sharedInstance;

-(void) registerAdapter:(Class) clazz adapterClazz:(Class) adapterClazz;

-(MongoToRongCloudImageMessageContentAdapter *) getAdapter:(Class) clazz;

@end
