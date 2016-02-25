//
//  MongoIM.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/21.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "MongoIM.h"

#import "DFSandboxHelper.h"
#import "NSDictionary+JSON.h"

@implementation MongoIM


static MongoIM *_im=nil;


#pragma mark - Lifecycle

+(instancetype) sharedInstance
{
    @synchronized(self){
        if (_im == nil) {
            _im = [[MongoIM alloc] init];
        }
    }
    return _im;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self imInit];
    }
    return self;
}



-(void)imInit
{
    [self initPlugins];
    
    [self initEmotions];
    
    [self initCells];
}

-(void)imInitWithMongoHander:(NSString *)senderId
{
    [self imInit];
    
    _messageHandler = [[DFMongoMessageHandler alloc] initWithSenderId:senderId];
    
}



-(void) initPlugins
{
    DFPluginsManager *manager = [DFPluginsManager sharedInstance];
    
    DFPhotoAlbumPlugin *photoAlbumPlugin = [[DFPhotoAlbumPlugin alloc] init];
    [manager addPlugin:photoAlbumPlugin];
    
    DFPhotoCameraPlugin *photoCameraPlugin = [[DFPhotoCameraPlugin alloc] init];
    [manager addPlugin:photoCameraPlugin];
    
    DFShortVideoPlugin *videoPlugin = [[DFShortVideoPlugin alloc] init];
    [manager addPlugin:videoPlugin];
    
    DFRedBagPlugin *redBagPlugin = [[DFRedBagPlugin alloc] init];
    [manager addPlugin:redBagPlugin];
    
    DFFavouritePlugin *favPlugin = [[DFFavouritePlugin alloc] init];
    [manager addPlugin:favPlugin];
    
    DFNameCardPlugin *nameCardPlugin = [[DFNameCardPlugin alloc] init];
    [manager addPlugin:nameCardPlugin];
    
}


-(void) initEmotions
{
    DFEmotionsManager *manager = [DFEmotionsManager sharedInstance];
    
    DFEmojiEmotion *emoji = [[DFEmojiEmotion alloc] init];
    [manager addEmotion:emoji];
}


-(void) initCells
{
    DFMessageCellManager *manager = [DFMessageCellManager sharedInstance];
    
    [manager registerCell:MessageContentTypeText cellClass:[DFTextMessageCell class]];
    
    [manager registerCell:MessageContentTypeVoice cellClass:[DFVoiceMessageCell class]];
    
    [manager registerCell:MessageContentTypeImage cellClass:[DFImageMessageCell class]];
    
    [manager registerCell:MessageContentTypeLocation cellClass:[DFLocationMessageCell class]];
    
    [manager registerCell:MessageContentTypeRedBag cellClass:[DFRedBagMessageCell class]];
    
    [manager registerCell:MessageContentTypeShare cellClass:[DFShareMessageCell class]];
    
    [manager registerCell:MessageContentTypeEmotion cellClass:[DFEmotionMessageCell class]];
    
    [manager registerCell:MessageContentTypeNameCard cellClass:[DFNameCardMessageCell class]];
    
    [manager registerCell:MessageContentTypeShortVideo cellClass:[DFShortVideoMessageCell class]];
    
    [manager registerCell:MessageContentTypeInfoNotify cellClass:[DFInfoNotifyMessageCell class]];
    
}


-(void) addEmotionPackage:(DFPackageEmotion *) emotionPackage
{
    [[DFEmotionsManager sharedInstance] addEmotion:emotionPackage];
}


-(void)addPlugin:(DFBasePlugin *)plugin
{
    DFPluginsManager *manager = [DFPluginsManager sharedInstance];
    [manager addPlugin:plugin];
}

-(void)registerPresentController:(Class)pluginClass controller:(UIViewController *)controller
{
    DFPluginsManager *manager = [DFPluginsManager sharedInstance];
    [manager registerPresentController:pluginClass controller:controller];
}

-(void) registerCell:(NSString *) contentType cellClass:(Class) cellClass;
{
    DFMessageCellManager *manager = [DFMessageCellManager sharedInstance];
    [manager registerCell:contentType cellClass:cellClass];
}

-(void)registerMessageClickHandler:(NSString *)contentType delegate:(id<DFMessageClickDelegate>)delegate
{
    DFMessageCellManager *manager = [DFMessageCellManager sharedInstance];
    [manager registerMessageClickHandler:contentType delegate:delegate];
}

-(void)resetPlugins:(NSArray *)plugins
{
    [[DFPluginsManager sharedInstance] resetPlugins:plugins];
}

@end
