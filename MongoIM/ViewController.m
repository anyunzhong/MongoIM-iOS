//
//  ViewController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/10.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (instancetype)init
{
    self = [super initWithTargetId:@"100020" conversationType:ConversationTypePrivate];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MongoIM";
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
