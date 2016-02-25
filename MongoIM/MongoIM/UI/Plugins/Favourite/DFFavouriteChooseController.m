//
//  DFFavouriteChooseController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFFavouriteChooseController.h"
#import "DFShareMessageContent.h"

@implementation DFFavouriteChooseController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"发送链接 分享 收藏" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(onSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void) onSend:(id )sender
{
    DFShareMessageContent *content = [[DFShareMessageContent alloc] init];
    
    content.title = @"无器械健身，是否真的比健身房器械训练要好？";
    content.desc = @"最近看了两本书，一本是无器械健身，一本是囚徒健身，这两本都是提倡利用自身重量做无器械健身的，而且在书中都有点明利用健身房器械健身效果不如自重健身好，我本人只有健身房练器械的经历，所以想问一下有无达人在这两方面都有经验的，去健身房利用器械健身是否像书中说的有害？";
    content.thumb = @"http://img.taopic.com/uploads/allimg/140503/235072-14050309304870.jpg";
    content.link = @"http://daily.zhihu.com/story/3913827";
    content.sourceLogo = @"http://file.market.xiaomi.com/thumbnail/PNG/l20/AppStore/0413ed456e648472f3164dd83180f072f8d4aa023";
    content.sourceName = @"网易新闻";
    
    [self.plugin send:content type:MessageContentTypeShare];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
