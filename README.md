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

Arch
============
![http://file-cdn.datafans.net/github/mongoimios/intro.png_600.jpeg](http://file-cdn.datafans.net/github/mongoimios/intro.png_600.jpeg)

###### UI层风格可切换 目前已经实现微信风格
###### 消息处理层可切换 目前已经对接上融云

Installation
============

```ruby
pod 'MongoIM'
```

Usage
===============

```obj-c
#import "MongoIM.h"
```

#####初始化
```obj-c
MongoIM *im = [MongoIM sharedInstance];
```

#####设置消息处理器(消息的接收和存储 连接等)

###### 默认消息消息处理器 目前还在完善中 需要配合MongoIM服务端项目使用 目前还在开发中

```obj-c
    DFMongoMessageHandler *messageHandler = [[DFMongoMessageHandler alloc] init];
    im.messageHandler = messageHandler;
    
```
###### 融云消息处理器 具体请参考 [http://rongcloud.cn](http://rongcloud.cn)
```obj-c
    DFRongCloudMessageHandler *messageHandler = [[DFRongCloudMessageHandler alloc] initWithAppKey:@"你的融云Appkey" token:@"通过融云获取到的token"];
    im.messageHandler = messageHandler;
    
```



