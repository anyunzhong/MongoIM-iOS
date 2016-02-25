//
//  DFLocationViewController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/12.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFLocationViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface DFLocationViewController()
@property (strong, nonatomic) MAMapView *mapView;
@property (strong, nonatomic) DFLocationMessageContent *locationMessage;
@end


@implementation DFLocationViewController


- (instancetype)initWithLocation:(DFLocationMessageContent *) locationMessage
{
    self = [super init];
    if (self) {
        _locationMessage = locationMessage;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
}


-(UIBarButtonItem *)leftBarButtonItem
{
    return [self defaultReturnBarButtonItem];
}


-(void) initMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 64, CGRectGetWidth(self.view.bounds), self.view.frame.size.height-64)];
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    [self.view addSubview:_mapView];

    MACoordinateRegion region = MACoordinateRegionMake(_locationMessage.location, MACoordinateSpanMake(0.06, 0.06));
    [_mapView setRegion:region animated:YES];
    
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = _locationMessage.location;
    pointAnnotation.title = _locationMessage.locationName;
    
    [_mapView addAnnotation:pointAnnotation];
}

@end
