//
//  DFLocationPlugin.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFLocationPlugin.h"

#import "DFLocationChooseController.h"

#import "DFLocationMessageContent.h"

@interface DFLocationPlugin()<DFLocationChooseControllerDelegate>

@property (strong, nonatomic) UINavigationController *navController;

@end


@implementation DFLocationPlugin

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_location";
        self.name = @"位置";
    }
    return self;
}

-(void)onClickDefault
{
    
    DFLocationChooseController *locationChooseController = [[DFLocationChooseController alloc] init];
    locationChooseController.delegate = self;
    _navController = [[UINavigationController alloc] initWithRootViewController:locationChooseController];
    
    [self.parentController presentViewController:_navController animated:YES completion:^{
        
    }];

    
}

-(void)onChooseLocation:(DFLocationInfo *)locationInfo
{
    DFLocationMessageContent *content = [[DFLocationMessageContent alloc] init];
    content.thumbnailImage = locationInfo.thumbImage;
    content.locationName = locationInfo.address;
    content.location = locationInfo.coordinate;
    
    [self send:content type:MessageContentTypeLocation];
}
@end
