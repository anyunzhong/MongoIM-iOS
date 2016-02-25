MongoIM-iOS
=============

即时通信 IM 支持发送文字 语音 图片 短视频 位置 红包 名片...

[![Alt][screenshot1_thumb]][screenshot1]    [![Alt][screenshot2_thumb]][screenshot2]    [![Alt][screenshot3_thumb]][screenshot3]    [![Alt][screenshot4_thumb]][screenshot4]    [![Alt][screenshot5_thumb]][screenshot5]    [![Alt][screenshot6_thumb]][screenshot6]    [![Alt][screenshot7_thumb]][screenshot7]    [![Alt][screenshot8_thumb]][screenshot8]    [![Alt][screenshot9_thumb]][screenshot9]

[screenshot1_thumb]: http://file-cdn.datafans.net/github/mongoimios/1.png_250.jpeg
[screenshot1]: http://file-cdn.datafans.net/github/mongoimios/1.png
[screenshot2_thumb]: http://file-cdn.datafans.net/github/mongoimios/2.png_250.jpeg
[screenshot2]: http://file-cdn.datafans.net/github/mongoimios/2.png
[screenshot3_thumb]: http://file-cdn.datafans.net/github/mongoimios/3.png_250.jpeg
[screenshot3]: http://file-cdn.datafans.net/github/mongoimios/3.png
[screenshot4_thumb]: http://file-cdn.datafans.net/github/mongoimios/4.png_250.jpeg
[screenshot4]: http://file-cdn.datafans.net/github/mongoimios/4.png
[screenshot5_thumb]: http://file-cdn.datafans.net/github/mongoimios/5.png_250.jpeg
[screenshot5]: http://file-cdn.datafans.net/github/mongoimios/5.png
[screenshot6_thumb]: http://file-cdn.datafans.net/github/mongoimios/6.png_250.jpeg
[screenshot6]: http://file-cdn.datafans.net/github/mongoimios/6.png
[screenshot7_thumb]: http://file-cdn.datafans.net/github/mongoimios/7.png_250.jpeg
[screenshot7]: http://file-cdn.datafans.net/github/mongoimios/7.png
[screenshot8_thumb]: http://file-cdn.datafans.net/github/mongoimios/8.png_250.jpeg
[screenshot8]: http://file-cdn.datafans.net/github/mongoimios/8.png
[screenshot9_thumb]: http://file-cdn.datafans.net/github/mongoimios/9.png_250.jpeg
[screenshot9]: http://file-cdn.datafans.net/github/mongoimios/9.png

架构
============
![http://file-cdn.datafans.net/github/mongoimios/arch.png_600.jpeg](http://file-cdn.datafans.net/github/mongoimios/arch.png_600.jpeg)

###### UI层风格可切换 目前已经实现微信风格
###### 消息处理层可切换 目前已经对接上融云 支持单聊 群聊 讨论组 聊天室

安装
============

```ruby
pod 'MongoIM'
```

快速开始
===============

```obj-c
#import "MongoIM.h"
```

#####初始化
```obj-c
MongoIM *im = [MongoIM sharedInstance];
```

####设置消息处理器(消息的接收和存储 连接等)

####### 默认消息消息处理器 目前还在完善中 需要配合MongoIM服务端项目使用 目前还在开发中

```obj-c
    DFMongoMessageHandler *messageHandler = [[DFMongoMessageHandler alloc] init];
    im.messageHandler = messageHandler;
    
```
####### 融云消息处理器 具体请参考 [http://rongcloud.cn](http://rongcloud.cn)
```obj-c
    DFRongCloudMessageHandler *messageHandler = [[DFRongCloudMessageHandler alloc] initWithAppKey:@"你的融云Appkey" token:@"通过融云获取到的token"];
    im.messageHandler = messageHandler;
    
```


####会话列表
```obj-c
    DFConversationViewController *conversationController = [[DFConversationViewController alloc] init];
```

####聊天
```obj-c
    DFMessageViewController *messageViewController = [[DFMessageViewController alloc] initWithTargetId:@"目标用户ID" conversationType:@"聊天类型"];
```


界面及相关逻辑
===============

####设置用户头像 昵称等

```obj-c
    UserInfoProvider provider = ^(NSString *userId, UserInfoCallback callback){
        
        可以直接从本地读取 也可以从网络获取
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
        
        //回调信息
        callback(userinfo);
        
    };
    im.userInfoProvider = provider;
```

####添加表情包

```obj-c

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

```


####点击插件后弹出的界面
```obj-c
    //默认已经实现的有 照片选择 拍照 选地点 如果需要自定义弹出界面 直接通过注册的方式覆盖原有实现即可
    //其它的都需要你去实现 通过传入的_plugin来发送消息 发送后记得dismiss当前controller
    //如果是自定义plugin 则直接覆盖基类onClick方法即可实现相同效果
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
```

####配置需要使用的插件
```obj-c
    DFRedBagPlugin *plugin = [[DFRedBagPlugin alloc] init];
    NSArray *plugins = @[plugin];
    [[MongoIM sharedInstance] resetPlugins:plugins];
```

####点击消息气泡执行的动作
```obj-c

    //默认实现的有 图片 分享 位置三种消息 如果要设置系统自带消息的点击行为 则通过注册消息点击handler的方式执行
    //如果是自己定义的消息显示cell 则直接覆盖基类onClick方法即可实现同样效果
    [[MongoIM sharedInstance] registerMessageClickHandler:MessageContentTypeRedBag delegate:self];

    -(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"点击了消息" message:@"抢到红包了吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
```

####位置发送和显示 需要使用高德地图
```obj-c
    //申请地址: http://lbs.amap.com/
    //注意: key和bundleId需要对应
    [MAMapServices sharedServices].apiKey = @"323c95e56dc16b7da2c9ebcb67b61f03";
    [AMapSearchServices sharedServices].apiKey = @"323c95e56dc16b7da2c9ebcb67b61f03";
```


自定义扩展
============

####自定义新的消息及显示

**新的消息类型**
如果是媒体类消息(比如图片 文字 视频等) 直接继承 DFMediaMessageContent 如果是通知类消息(比如系统提示) 直接继承 DFNotifyMessageContent
当然你也可以直接继承DFMessageContent

```obj-c
    @interface YourMessageContent : DFMediaMessageContent
        @property (nonatomic, strong) NSString *your_field;
    @end
```

**消息显示**
如果需要显示头像 直接继承DFMessageCell 如果不需要 直接继承DFBaseMessageCell
例如：定义一个需要显示头像类型的cell
```obj-c
   
@implementation DFYourMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化相关view
        [self.messageContentView addSubview:your_view];
    }
    return self;
}


-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    //将数据绑定到view上
    
}

-(CGSize)getMessageContentViewSize
{
    //返回中间内容需要的尺寸
    return CGSizeMake(宽度,高度);
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    return 内容的高度 + [super getCellHeight:message];
}

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    //点击消息后处理
}


-(void)onMenuShow:(BOOL)show
{
    //长按显示菜单后处理 比如将bubble颜色变深
}
@end
```

####自定义插件

####自定义表情显示
