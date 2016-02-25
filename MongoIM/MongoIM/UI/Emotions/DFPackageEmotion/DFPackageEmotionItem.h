//
//  DFPackageEmotionItem.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/21.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFPackageEmotionItem : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *remoteGif;
@property (strong, nonatomic) NSString *localGif;
@property (strong, nonatomic) NSString *remoteThumb;
@property (strong, nonatomic) NSString *localThumb;

- (instancetype)initWithDic:(NSDictionary *) dic rootPath: (NSString *) rootPath;

@end
