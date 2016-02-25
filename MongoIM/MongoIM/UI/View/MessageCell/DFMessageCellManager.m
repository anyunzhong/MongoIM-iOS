//
//  DFLineCellAdapterManager.m
//  DFTimelineView
//
//  Created by Allen Zhong on 15/9/27.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFMessageCellManager.h"

@interface DFMessageCellManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@property (strong, nonatomic) NSMutableDictionary *handlerDic;

@end



@implementation DFMessageCellManager

static DFMessageCellManager  *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFMessageCellManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
        _handlerDic = [NSMutableDictionary dictionary];
    }
    return self;
}



#pragma mark - Method



-(void) registerCell:(NSString *) contentType cellClass:(Class ) cellClass;
{
    [_dic setObject:[[cellClass alloc] init]  forKey:contentType];
}


-(DFBaseMessageCell *) getCell:(NSString *) contentType
{
    return [_dic objectForKey:contentType];
}


-(void)registerMessageClickHandler:(NSString *)contentType delegate:(id<DFMessageClickDelegate>)delegate
{
    [_handlerDic setObject:delegate forKey:contentType];
}

-(id<DFMessageClickDelegate>)getMessageClickHandler:(NSString *)contentType
{
    return [_handlerDic objectForKey:contentType];
}

@end
