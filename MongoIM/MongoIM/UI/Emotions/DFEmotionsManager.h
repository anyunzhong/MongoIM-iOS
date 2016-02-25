//
//  DFPluginsManager.h
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "DFBaseEmotion.h"

//default emotions
#import "DFEmojiEmotion.h"
#import "DFPackageEmotion.h"

#import "MLExpressionManager.h"



@interface DFEmotionsManager : NSObject


+(instancetype) sharedInstance;

-(MLExpression *) sharedMLExpression;

-(void) addEmotion:(DFBaseEmotion *) emotion;

-(NSMutableArray *) getEmotions;

@end
