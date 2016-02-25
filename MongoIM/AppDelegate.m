//
//  AppDelegate.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/10.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

#import "MongoIM.h"

#import "DFRongCloudMessageHandler.h"


#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

//默认插件presentController
#import "DFFavouriteChooseController.h"
#import "DFFavouritePlugin.h"
#import "DFRedBagCreateController.h"
#import "DFRedBagPlugin.h"
#import "DFNameCardPlugin.h"
#import "DFNameCardChooseController.h"

#import "DFLocationPlugin.h"

#import "DFRedBagMessageContent.h"
#import "DFLocationMessageContent.h"

#import "DFLocationViewController.h"

//点击消息后的行为处理

#define NavBarBgColor [UIColor colorWithRed:24/255.0 green:30/255.0 blue:43/255.0 alpha:1.0]
#define NavBarFgColor [UIColor whiteColor]
#define NavTextAttribute @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]}


@interface AppDelegate ()<DFMessageClickDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //设置导航栏和状态栏
    application.statusBarStyle = UIStatusBarStyleLightContent;
    //[UINavigationBar appearance].barTintColor =NavBarBgColor;
    [UINavigationBar appearance].tintColor = NavBarFgColor;
    [UINavigationBar appearance].titleTextAttributes = NavTextAttribute;
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;

    
    //初始化
    MongoIM *im = [MongoIM sharedInstance];
    
    
    //设置消息处理器(消息的存储与收发)
    DFRongCloudMessageHandler *messageHandler = [[DFRongCloudMessageHandler alloc] initWithAppKey:@"0vnjpoadnzn1z" token:@"sRKyxvhWO9zvlCxPAN1lU3zitpBSL7z4yCPeUt6pCkDr8o3ZrDDq7cNJHkDod7spoMDlOHJM6D7Pt1SmlZlmjw=="];
    im.messageHandler = messageHandler;
    
    
    //用户信息
    UserInfoProvider provider = ^(NSString *userId, UserInfoCallback callback){
        
        DFUserInfo *userinfo = [[DFUserInfo alloc] init];
        
        userinfo.userId = userId;
        if ([userId isEqual:@"100010"]) {
            userinfo.avatar = @"http://file-cdn.datafans.net/avatar/1.jpeg";
            userinfo.nick = @"Allen";
        }else  if ([userId isEqual:@"100020"]) {
            userinfo.avatar = @"http://file-cdn.datafans.net/avatar/2.jpg";
            userinfo.nick = @"Yanhua";
        }else{
            userinfo.avatar = @"";
            userinfo.nick = userId;
        }
        
        callback(userinfo);
        
    };
    im.userInfoProvider = provider;
    
    
    
    //添加表情包
    [self addEmotionPackage];
    
    
    
    //如果需要发送位置 请设置高德地图的key
    //申请地址: http://lbs.amap.com/
    //注意: key和bundleId需要对应
    [MAMapServices sharedServices].apiKey = @"323c95e56dc16b7da2c9ebcb67b61f03";
    [AMapSearchServices sharedServices].apiKey = @"323c95e56dc16b7da2c9ebcb67b61f03";
    
    
    //设置点击插件后需要弹出的自定义controller
    //默认已经实现的有 照片选择 拍照 选地点 如果需要自定义弹出界面 直接通过注册的方式覆盖原有实现即可
    //其它的都需要你去实现 通过传入的_plugin来发送消息 发送后记得dismiss当前controller
    //如果是自定义plugin 则直接覆盖基类onClick方法即可实现相同效果
    [self setPluginPresentController];
    
    
    //重新设置插件
    //DFRedBagPlugin *plugin = [[DFRedBagPlugin alloc] init];
    //NSArray *plugins = @[plugin];
    //[[MongoIM sharedInstance] resetPlugins:plugins];
    
    //发送位置插件
    DFLocationPlugin *locationPlugin = [[DFLocationPlugin alloc] init];
    [im addPlugin:locationPlugin];
    
    //设置点击消息后的处理方式
    //默认实现的有 图片 分享 位置三种消息 如果要设置系统自带消息的点击行为 则通过注册消息点击handler的方式执行
    //如果是自己定义的消息显示cell 则直接覆盖基类onClick方法即可实现同样效果
    [self setMessageClickHandler];
    
    
    
    //UI入口 DFConversationViewController
    DFConversationViewController *conversationController = [[DFConversationViewController alloc] init];
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:conversationController];
    UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, -20, navController.navigationBar.frame.size.width, 64)];
    bg.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [navController.navigationBar insertSubview:bg atIndex:0];
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.rootViewController = navController;
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    
    return YES;
}


-(void) addEmotionPackage
{
    //模拟一组小黄鸡动态表情 一共32个
    
    NSMutableArray *items = [NSMutableArray array];
    for (int i=1; i<=32; i++) {
        DFPackageEmotionItem *item = [[DFPackageEmotionItem alloc] init];
        item.remoteGif = [NSString stringWithFormat:@"http://file-cdn.datafans.net/emotion/yellow_chicken/gif/%d.gif", i];
        item.remoteThumb = [NSString stringWithFormat:@"http://file-cdn.datafans.net/emotion/yellow_chicken/png/%d.png", i];
        //item.localGif 本地gif 如果有 优先显示本地的资源
        //item.localThumb 本地静态图 如果存在 优先显示本地资源
        
        item.name = [NSString stringWithFormat:@"小黄鸡%d",i];
        [items addObject:item];
    }
    
    //用于聊天窗口 表情窗底部那一排显示在tab上的小图标
    NSString *iconPath = @"http://file-cdn.datafans.net/emotion/yellow_chicken/icon3x.png";
    DFPackageEmotion *emotion = [[DFPackageEmotion alloc] initWithIcon:iconPath total:items.count items:items];
    [[MongoIM sharedInstance] addEmotionPackage:emotion];


    //模拟一组小鸟动态表情 一共16个
    
    NSMutableArray *items2 = [NSMutableArray array];
    for (int i=1; i<=16; i++) {
        DFPackageEmotionItem *item = [[DFPackageEmotionItem alloc] init];
        item.remoteGif = [NSString stringWithFormat:@"http://file-cdn.datafans.net/emotion/bird/gif/%d.gif", i];
        item.remoteThumb = [NSString stringWithFormat:@"http://file-cdn.datafans.net/emotion/bird/png/%d.png", i];
        //item.localGif 本地gif 如果有 优先显示本地的资源
        //item.localThumb 本地静态图 如果存在 优先显示本地资源
        
        item.name = [NSString stringWithFormat:@"蓝小鸟%d",i];
        [items2 addObject:item];
    }
    
    //用于聊天窗口 表情窗底部那一排显示在tab上的小图标
    NSString *iconPath2 = @"http://file-cdn.datafans.net/emotion/bird/icon3x.png";
    DFPackageEmotion *emotion2 = [[DFPackageEmotion alloc] initWithIcon:iconPath2 total:items2.count items:items2];
    [[MongoIM sharedInstance] addEmotionPackage:emotion2];

}


-(void) setPluginPresentController
{
    //自定义的presentController 必需继承DFPluginPresentController 否则无法传入plugin
    //收藏
    DFFavouriteChooseController *favouriteController = [[DFFavouriteChooseController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:favouriteController];
    [[MongoIM sharedInstance] registerPresentController:[DFFavouritePlugin class] controller:nav];
    
    //红包
    DFRedBagCreateController *redBagController = [[DFRedBagCreateController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:redBagController];
    [[MongoIM sharedInstance] registerPresentController:[DFRedBagPlugin class] controller:nav2];
    
    //名片
    DFNameCardChooseController *nameCardController = [[DFNameCardChooseController alloc] init];
    UINavigationController *nav3 = [[UINavigationController alloc] initWithRootViewController:nameCardController];
    [[MongoIM sharedInstance] registerPresentController:[DFNameCardPlugin class] controller:nav3];
    
}


-(void) setMessageClickHandler
{
    [[MongoIM sharedInstance] registerMessageClickHandler:MessageContentTypeRedBag delegate:self];
}



#pragma mark - DFMessageClickDelegate

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    DFMessageContent *content = message.messageContent;
    
    if ([content isKindOfClass:[DFRedBagMessageContent class]]) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"点击了消息" message:@"抢到红包了吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else if ([content isKindOfClass:[DFLocationMessageContent class]]) {
        
        DFLocationMessageContent *locationMessage = (DFLocationMessageContent *)message.messageContent;
        DFLocationViewController *locationController = [[DFLocationViewController alloc] initWithLocation:locationMessage];
        [controller pushViewController:locationController animated:YES];
    }
    
}





- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
