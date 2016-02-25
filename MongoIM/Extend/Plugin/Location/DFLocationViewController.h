//
//  DFLocationViewController.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/12.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBaseViewController.h"
#import "DFLocationMessageContent.h"

@interface DFLocationViewController : DFBaseViewController
- (instancetype)initWithLocation:(DFLocationMessageContent *) locationMessage;

@end
