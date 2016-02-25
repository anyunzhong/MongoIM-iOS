//
//  MongoToRongCloudMessageContentAdapterManager.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/9.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoToRongCloudMessageContentAdapterManager.h"
#import "MongoToRongCloudImageMessageContentAdapter.h"

@interface MongoToRongCloudMessageContentAdapterManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end

@implementation MongoToRongCloudMessageContentAdapterManager


static  MongoToRongCloudMessageContentAdapterManager *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[MongoToRongCloudMessageContentAdapterManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
    }
    return self;
}



#pragma mark - Method

-(void) registerAdapter:(Class) clazz adapterClazz:(Class) adapterClazz
{
    [_dic setObject:[[adapterClazz alloc] init] forKey: NSStringFromClass(clazz)];
}


-(MongoToRongCloudImageMessageContentAdapter *)getAdapter:(Class)clazz
{
    return [_dic objectForKey:NSStringFromClass(clazz)];
}

@end
