//
//  RongCloudToMongoMessageContentAdapterManager.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RongCloudToMongoMessageContentAdapter.h"

#import "RongCloudToMongoTextMessageContentAdapter.h"
#import "RongCloudToMongoVoiceMessageContentAdapter.h"
#import "RongCloudToMongoImageMessageContentAdapter.h"
#import "RongCloudToMongoLocationMessageContentAdapter.h"
#import "RongCloudToMongoRedBagMessageContentAdapter.h"
#import "RongCloudToMongoShareMessageContentAdapter.h"
#import "RongCloudToMongoEmotionMessageContentAdapter.h"
#import "RongCloudToMongoNameCardMessageContentAdapter.h"
#import "RongCloudToMongoShortVideoMessageContentAdapter.h"
#import "RongCloudToMongoInfomationNotificationMessageContentAdapter.h"

@interface RongCloudToMongoMessageContentAdapterManager : NSObject

+(instancetype) sharedInstance;

-(void) registerAdapter:(Class) clazz adapterClazz:(Class) adapterClazz;

-(RongCloudToMongoMessageContentAdapter *) getAdapter:(Class) clazz;

@end
