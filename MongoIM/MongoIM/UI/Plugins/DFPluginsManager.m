//
//  DFPluginsManager.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFPluginsManager.h"

@interface DFPluginsManager()


@property (strong, nonatomic) NSMutableArray *plugins;
@property (strong, nonatomic) NSMutableDictionary *presentControllerDic;

@end


@implementation DFPluginsManager

static  DFPluginsManager *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFPluginsManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _plugins = [NSMutableArray array];
        _presentControllerDic = [NSMutableDictionary dictionary];
    }
    return self;
}



#pragma mark - Method

-(void) addPlugin:(DFBasePlugin *) plugin
{
    [_plugins addObject:plugin];
}

-(NSMutableArray *) getPlugins
{
    return _plugins;
}

-(void)setParentController:(UIViewController *)controller
{
    for (DFBasePlugin *p in _plugins) {
        p.parentController = controller;
    }
}


-(void)registerPresentController:(Class)clazz controller:(UIViewController *)controller
{
    [_presentControllerDic setObject:controller forKey:NSStringFromClass(clazz)];
}


-(UIViewController *)getPresentController:(Class)clazz
{
    UIViewController *controller =  [_presentControllerDic objectForKey:NSStringFromClass(clazz)];
    if (controller == nil) {
        return nil;
    }
    
    return controller;
}

-(void)resetPlugins:(NSArray *)plugins
{
    [_plugins removeAllObjects];
    [_plugins addObjectsFromArray:plugins];
}
@end
