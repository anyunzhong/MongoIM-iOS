//
//  DFPluginsManager.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "DFBasePlugin.h"

#import "DFPhotoAlbumPlugin.h"
#import "DFPhotoCameraPlugin.h"
#import "DFShortVideoPlugin.h"
#import "DFRedBagPlugin.h"
#import "DFFavouritePlugin.h"
#import "DFNameCardPlugin.h"

#import "DFPluginPresentController.h"




@interface DFPluginsManager : NSObject


+(instancetype) sharedInstance;

-(void) addPlugin:(DFBasePlugin *) plugin;

-(NSMutableArray *) getPlugins;

-(void) setParentController:(UIViewController *) controller;

-(void) registerPresentController:(Class) clazz controller:(UIViewController *) controller;

-(UIViewController *) getPresentController:(Class) clazz;

-(void) resetPlugins:(NSArray *) plugins;


@end
