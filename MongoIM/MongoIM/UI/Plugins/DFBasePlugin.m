//
//  DFBasePlugin.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFBasePlugin.h"
#import "DFMessageViewController.h"
#import "DFPluginsManager.h"

@implementation DFBasePlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        _icon = @"";
        _name = @"";
    }
    return self;
}

-(void) onClickDefault
{
    
}

-(void)send:(DFMessageContent *)content type:(NSString *)type
{
    [( (DFMessageViewController *) self.parentController) sendMessage:content contentType:type];
}


-(void) onClick
{
    UIViewController *viewController = [[DFPluginsManager sharedInstance] getPresentController:[self class]];
    if (viewController == nil) {
        //执行默认实现
        [self onClickDefault];
        
    }else{
        
        if ([viewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navController  = (UINavigationController *)viewController;
            NSArray *array = navController.viewControllers;
            if (array.count >0) {
                UIViewController *con = [array objectAtIndex:0];
                if ([con isKindOfClass:[DFPluginPresentController class]]) {
                    ((DFPluginPresentController *)con).plugin = self;
                }
            }
        }else{
            if ([viewController isKindOfClass:[DFPluginPresentController class]]) {
                ((DFPluginPresentController *)viewController).plugin = self;
            }
        }
        
        
        [self.parentController presentViewController:viewController animated:YES completion:^{
            
        }];

    }
}

@end
