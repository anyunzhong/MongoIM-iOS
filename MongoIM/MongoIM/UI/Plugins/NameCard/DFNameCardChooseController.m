//
//  DFNameCardChooseController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/13.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFNameCardChooseController.h"
#import "DFNameCardMessageContent.h"

@implementation DFNameCardChooseController

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(50, 100, 200, 100)];
    button.backgroundColor = [UIColor darkGrayColor];
    [button setTitle:@"发送名片" forState: UIControlStateNormal];
    [button addTarget:self action:@selector(onSend:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void) onSend:(id )sender
{
    DFNameCardMessageContent *content = [[DFNameCardMessageContent alloc] init];
    content.userId = @"100010";
    content.userNick = @"Allen";
    content.userNum = @"datafans";
    content.userAvatar= @"http://file-cdn.datafans.net/avatar/1.jpeg";
    
    [self.plugin send:content type:MessageContentTypeNameCard];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}


@end
