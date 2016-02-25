//
//  DFLocationMessageContent.h
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFMediaMessageContent.h"
#import <MapKit/MapKit.h>

@interface DFLocationMessageContent : DFMediaMessageContent

@property(nonatomic, assign) CLLocationCoordinate2D location;

@property(nonatomic, strong) NSString *locationName;

@property(nonatomic, strong) UIImage *thumbnailImage;

@property (assign, nonatomic) NSUInteger width;
@property (assign, nonatomic) NSUInteger height;

@property (strong, nonatomic) NSString *url;

@end
