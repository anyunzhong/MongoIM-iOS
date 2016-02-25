//
//  MongoIM.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DFUserInfo.h"

//消息类型
#import "MessageContentType.h"

//消息及消息内容
#import "DFMessage.h"
#import "DFMessageContent.h"


//消息处理器
#import "DFBaseMessageHandler.h"
#import "DFMongoMessageHandler.h"

//插件管理
#import "DFPluginsManager.h"

//表情管理
#import "DFEmotionsManager.h"

//消息显示cell管理
#import "DFMessageCellManager.h"

//消息汇总界面
#import "DFConversationViewController.h"

//聊天界面
#import "DFMessageViewController.h"



typedef void (^UserInfoCallback)(DFUserInfo *);

typedef void (^UserInfoProvider)(NSString *, UserInfoCallback callback);


@interface MongoIM : NSObject

@property (nonatomic, assign) UserInfoProvider userInfoProvider;

@property (nonatomic, strong) DFBaseMessageHandler *messageHandler;


+(instancetype) sharedInstance;

//添加表情包
-(void) addEmotionPackage:(DFPackageEmotion *) emotionPackage;

//添加自定义插件
-(void) addPlugin:(DFBasePlugin *) plugin;

//点击某个插件之后 设置需要present的控制器
-(void) registerPresentController:(Class) pluginClass controller:(UIViewController *) controller;

//注册自定义消息显示适配器
-(void) registerCell:(NSString *) contentType cellClass:(Class) cellClass;

//注册消息点击后的处理行为
-(void) registerMessageClickHandler:(NSString *) contentType delegate:(id<DFMessageClickDelegate>) delegate;

//重新设置插件
-(void) resetPlugins:(NSArray *) plugins;
@end
