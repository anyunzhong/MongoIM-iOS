//
//  DFLocationInfo.h
//  mapTest
//
//  Created by Allen Zhong on 16/2/7.
//  Copyright © 2016年 Datafans. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DFLocationInfo : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;
@property (nonatomic, assign) BOOL checked;
@property (nonatomic, strong) UIImage *thumbImage;

@end
