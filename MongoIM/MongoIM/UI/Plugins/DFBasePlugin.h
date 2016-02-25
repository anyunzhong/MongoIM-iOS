//
//  DFBasePlugin.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "DFMessageContent.h"
#import "MessageContentType.h"

@interface DFBasePlugin : NSObject

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;

@property (strong, nonatomic) UIViewController *parentController;

-(void) onClick;

-(void) send:(DFMessageContent *) content type:(NSString *) type;


@end
