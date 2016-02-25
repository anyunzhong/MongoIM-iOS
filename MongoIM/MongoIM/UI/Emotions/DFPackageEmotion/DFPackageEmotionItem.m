//
//  DFPackageEmotionItem.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/21.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFPackageEmotionItem.h"

@implementation DFPackageEmotionItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"";
        
        self.remoteGif = @"";
        self.remoteThumb = @"";
        
        self.localGif = @"";
        self.localThumb = @"";
    }
    return self;
}
- (instancetype)initWithDic:(NSDictionary *) dic rootPath: (NSString *) rootPath
{
    self = [super init];
    if (self) {
        self.name = [dic objectForKey:@"name"];
        
        self.remoteGif = [dic objectForKey:@"gif"];
        self.remoteThumb = [dic objectForKey:@"thumb"];
        
        self.localGif = [NSString stringWithFormat:@"%@/%@",rootPath, [dic objectForKey:@"gif_path"]];
        self.localThumb = [NSString stringWithFormat:@"%@/%@",rootPath, [dic objectForKey:@"thumb_path"]];
    }
    return self;
}

@end
