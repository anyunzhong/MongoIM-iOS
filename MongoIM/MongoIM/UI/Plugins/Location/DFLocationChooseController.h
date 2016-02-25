//
//  DFLocationChooseController.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/7.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DFBaseViewController.h"
#import "DFLocationInfo.h"

@protocol DFLocationChooseControllerDelegate <NSObject>

@required

-(void) onChooseLocation:(DFLocationInfo *) locationInfo;

@end
@interface DFLocationChooseController : DFBaseViewController

@property (weak, nonatomic) id<DFLocationChooseControllerDelegate> delegate;

@end
