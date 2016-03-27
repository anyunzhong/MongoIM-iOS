
MongoIM
============

支持发送文字 语音 图片 短视频 位置 红包 名片...
<br />
<br />
![http://file-cdn.datafans.net/github/mongoimios/cover1.jpg](http://file-cdn.datafans.net/github/mongoimios/cover1.jpg)

<br />

架构
============
![http://file-cdn.datafans.net/github/mongoimios/arch1.png](http://file-cdn.datafans.net/github/mongoimios/arch1.png)

<br />
### UI层风格可切换
目前已经实现微信风格 你也可以自定义风格 完全自定义风格的相关逻辑还需要开发

<br />
### 消息处理层可切换
目前已经对接上融云 支持单聊 群聊 讨论组 聊天室<br />
其它公有IM云服务还在计划中.....<br />
IM后端逻辑相对复杂 MongoIM消息处理和服务端还在开发中.... 远期目标是开发一套稳定的可部署在私有云的IM服务

<br />
### 多终端支持
iOS：[https://github.com/anyunzhong/MongoIM-iOS](https://github.com/anyunzhong/MongoIM-iOS)
<br />
Android：[https://github.com/anyunzhong/MongoIM-Android](https://github.com/anyunzhong/MongoIM-Android)
<br />
Server：开发中....



<br />
MongoIM-iOS
=============
[![Version](https://img.shields.io/cocoapods/v/MongoIM.svg?style=flat)](http://cocoapods.org/pods/MongoIM)
[![License](https://img.shields.io/cocoapods/l/MongoIM.svg?style=flat)](http://cocoapods.org/pods/MongoIM)
[![Platform](https://img.shields.io/cocoapods/p/MongoIM.svg?style=flat)](http://cocoapods.org/pods/MongoIM)
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/anyunzhong/MongoIM-iOS)

<br />
安装
============

```ruby
pod 'MongoIM'
```

<br />
快速开始
===============

```obj-c
#import "MongoIM.h"
```

####初始化
```obj-c
MongoIM *im = [MongoIM sharedInstance];
```
<br />
####设置消息处理器(消息的接收和存储 连接等)

#####1.默认消息消息处理器 目前还在完善中 需要配合MongoIM服务端项目使用 目前还在开发中

```obj-c
    DFMongoMessageHandler *messageHandler = [[DFMongoMessageHandler alloc] init];
    im.messageHandler = messageHandler;
    
```

#####2.融云消息处理器 具体请参考 [http://rongcloud.cn](http://rongcloud.cn)
引入融云框架
```obj-c
pod 'RongCloudIMLib', '~> 2.4.5'
```

然后将MongoIM/Extend/Vendor/RongCloud文件夹拖到工程
（因为融云的pod不是开源代码 打包成了framework形式 所以没有集成到Mongo.pod中 这样有另外一个好处 按需定制 你不需要集成融云 就不用拖入扩展类）

设置消息处理器为融云
```obj-c
    DFRongCloudMessageHandler *messageHandler = [[DFRongCloudMessageHandler alloc] initWithAppKey:@"你的融云Appkey" token:@"通过融云获取到的token"];
    im.messageHandler = messageHandler;
```

<br />
####会话列表
```obj-c
    DFConversationViewController *conversationController = [[DFConversationViewController alloc] init];
```

<br />
####聊天
```obj-c
    DFMessageViewController *messageViewController = [[DFMessageViewController alloc] initWithTargetId:@"目标用户ID" conversationType:@"聊天类型"];
```

<br />
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

<br />
自定义扩展
============

####自定义新的消息及显示

##### 1.新的消息类型
如果是媒体类消息(比如图片 文字 视频等) 直接继承 DFMediaMessageContent 如果是通知类消息(比如系统提示) 直接继承 DFNotifyMessageContent
当然你也可以直接继承DFMessageContent

**注意消息的内容类型 需要与后面cell注册时的类型一样 也就是说是根据实体的类型找对应的cell来显示 另外 这个类型不要与系统已经有的一样 否则会冲突**

```obj-c
    @interface YourMessageContent : DFMediaMessageContent
        @property (nonatomic, strong) NSString *your_field;
    @end
```

#####2. 消息显示
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


不需要显示头像
```obj-c

@implementation DFYourMessageCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //初始化view
        [self.baseContentView addSubview:your_view];
    }
    return self;
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
   //更新数据
    
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    return 内容的高度 + [super getCellHeight:message];
}
@end
```

#####3. 注册消息显示cell

```obj-c
   DFMessageCellManager *manager = [DFMessageCellManager sharedInstance];
   [manager registerCell:@"你的消息内容类型" cellClass:[DFYouressageCell class]];
```

####自定义插件
```obj-c
@interface YourPlugin : DFBasePlugin

@end



@implementation YourPlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_location";
        self.name = @"位置";
    }
    return self;
}

-(void)onClickDefault
{
    //处理点击后的行为
}

@end

```

注册插件
```obj-c
    DFPluginsManager *manager = [DFPluginsManager sharedInstance];
    YourPlugin *plugin = [[YourPlugin alloc] init];
    [manager addPlugin:plugin];
```

<br />
融云消息扩展
============

####新增融云消息 具体可参照默认的红包 短视频等消息的实现 具体细节可以参考融云官方文档

```obj-c
@interface YourRongCloudMessage : RCMessageContent
@property (strong, nonatomic) NSString *title;
@end

@implementation YourRongCloudMessage

-(NSData *)encode
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:_title forKey:@"title"];
    return [NSDictionary dic2jsonData:dic];
}

-(void)decodeWithData:(NSData *)data
{
    NSDictionary *dic = [NSDictionary jsonData2Dic:data];
    _title = [dic objectForKey:@"title"];
}

+(NSString *)getObjectName
{
    return @"你定义的融云消息类型";
}


+(RCMessagePersistent)persistentFlag
{
    return MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED;
}


```


####注册融云消息
```obj-c
[[RCIMClient sharedRCIMClient] registerMessageType:[YourRongCloudMessage class]];
```

####对接融云消息

将融云消息转换为MongoIM消息
```obj-c
@interface RongCloudToMongoYourMessageContentAdapter : RongCloudToMongoMessageContentAdapter
@end

@implementation RongCloudToMongoYourMessageContentAdapter

-(DFMessageContent *)getMongoMessageContent:(RCYourMessage *)yourgMessage
{
    YourMessageContent *messageContent = [[YourMessageContent alloc] init];
    messageContent.title = redBagMessage.title; //这里对应你设置的字段
    ........
    return messageContent;
}

-(NSString *)getMongoMessageType
{
    return @"你的自定义消息类型";  //不要与融云那边消息类型混淆了
}

-(NSString *)getConversationSubTitle:(RCRedBagMessage *)redBagMessage
{
    return @"会话列表需要显示的文字";
}

@end
```

将MongoIM的消息转换成融云的
```obj-c
@interface MongoToRongCloudYourMessageContentAdapter : MongoToRongCloudMessageContentAdapter
@end

@implementation MongoToRongCloudYourMessageContentAdapter

-(RCMessageContent *)getRongCloudMessageContent:(YourMessageContent *)yourMessage
{
    return [.......]; //你的转换逻辑
}
@end

```

注册新增的类型 

```obj-c
 RongCloudToMongoMessageContentAdapterManager *rongManager = [RongCloudToMongoMessageContentAdapterManager sharedInstance];
 [rongManager registerAdapter:[YourRongCloudMessage class] adapterClazz:[RongCloudToMongoYourMessageContentAdapter class]];
 
 MongoToRongCloudMessageContentAdapterManager *mongoManager = [MongoToRongCloudMessageContentAdapterManager sharedInstance];
 [mongoManager registerAdapter:[YourMessageContent class] adapterClazz:[MongoToRongCloudYourMessageContentAdapter class]];

```



