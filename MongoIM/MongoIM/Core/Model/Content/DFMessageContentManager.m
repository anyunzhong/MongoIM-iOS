//
//  DFMessageContentManager.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMessageContentManager.h"
#import "MessageContentType.h"


#import "DFTextMessageContent.h"

@interface DFMessageContentManager()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end


@implementation DFMessageContentManager

static  DFMessageContentManager *_manager=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_manager == nil) {
            _manager = [[DFMessageContentManager alloc] init];
        }
    }
    return _manager;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        _dic = [NSMutableDictionary dictionary];
    }
    return self;
}

-(void)register:(NSString *)type messageContent:(DFMessageContent *)messageContent
{
    
}

-(DFMessageContent *)create:(NSString *)type
{
    if ([type  isEqual: MessageContentTypeText]) {
        
        return [[DFTextMessageContent alloc] init];
    }
    
    return nil;
    
}





@end
