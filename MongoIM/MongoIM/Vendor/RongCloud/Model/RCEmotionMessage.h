//
//  RCEmotionMessage.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/11.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

@interface RCEmotionMessage : RCMessageContent

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *remoteGif;
@property (strong, nonatomic) NSString *localGif;
@property (strong, nonatomic) NSString *remoteThumb;
@property (strong, nonatomic) NSString *localThumb;

@end
