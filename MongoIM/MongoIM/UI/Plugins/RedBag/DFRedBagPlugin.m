//
//  DFRedBagPlugin.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFRedBagPlugin.h"
#import "DFRedBagCreateController.h"
#import "DFRedBagMessageContent.h"


@interface DFRedBagPlugin()

@property  (nonatomic, strong) DFRedBagCreateController *controller;

@property (strong, nonatomic) UINavigationController *navController;

@end

@implementation DFRedBagPlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_redbag";
        self.name = @"红包";
    }
    return self;
}

@end
