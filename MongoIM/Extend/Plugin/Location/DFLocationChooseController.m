//
//  DFLocationChooseController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/7.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFLocationChooseController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "DFLocationInfo.h"

#define TopOffset 64
#define MapViewHeight 200

@interface DFLocationChooseController ()<MAMapViewDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) AMapSearchAPI *search;

@property (strong, nonatomic) AMapPOIAroundSearchRequest *request;

@property (strong, nonatomic) MAMapView *mapView;

@property (assign, nonatomic) BOOL firstLocated;

@property (assign, nonatomic) BOOL firstSearch;

@property (assign, nonatomic) BOOL enableSearch;

@property (assign, nonatomic) CLLocationCoordinate2D currentCoordinate;

@property (strong, nonatomic) NSMutableArray *locations;

@property (strong, nonatomic) DFLocationInfo *choosedLocation;

@property (strong, nonatomic) UITableView *tableView;

@property (strong, nonatomic) UIButton *locationFocusButton;


@end

@implementation DFLocationChooseController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _locations = [NSMutableArray array];
        _firstLocated = NO;
        _firstSearch = NO;
        _enableSearch = YES;
        
        
    }
    return self;
}

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择位置";
    
    
    [self initPoiSearch];
    
    [self initMapView];
    
    [self addLocationPin];
    
    [self addLocationFocusButton];
    
    [self initTableView];
}

-(UIBarButtonItem *)rightBarButtonItem{
    return [UIBarButtonItem text:@"发送" selector:@selector(sendLocation) target:self];
}

-(UIBarButtonItem *)leftBarButtonItem
{
    return [UIBarButtonItem text:@"关闭" selector:@selector(dismiss) target:self];
}

-(void) initMapView
{
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, TopOffset, CGRectGetWidth(self.view.bounds), MapViewHeight)];
    _mapView.delegate = self;
    
    _mapView.showsUserLocation = YES;
    _mapView.showsCompass = NO;
    _mapView.showsScale = NO;
    [self.view addSubview:_mapView];
}

-(void) initPoiSearch
{
    _search = [[AMapSearchAPI alloc] init];
    _search.delegate = self;
    
    _request = [[AMapPOIAroundSearchRequest alloc] init];
    //request.keywords = @"方恒";
    //request.types = @"";
    _request.sortrule = 0;
    _request.requireExtension = YES;
}

-(void) addLocationPin
{
    CGFloat pinWidth  = 18;
    CGFloat pinHeight = 38;
    CGFloat pinVerticalOffset = 35;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - pinWidth)/2, TopOffset+ MapViewHeight/2-pinVerticalOffset, pinWidth, pinHeight)];
    imageView.image = [UIImage imageNamed:@"located_pin"];
    [self.view addSubview:imageView];
}

-(void) addLocationFocusButton
{
    CGFloat x, y, width, height, margin;
    margin = 10;
    width = 50;
    height = width;
    x = self.view.frame.size.width - width - margin;
    y = CGRectGetMaxY(_mapView.frame) - height - margin;
    
    _locationFocusButton = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [_locationFocusButton addTarget:self action:@selector(onClickLocationFocusButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_locationFocusButton];
    
    [self setLocationFocusButtonFocused:NO];
}

-(void) initTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_mapView.frame), self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(_mapView.frame)) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.hidden = YES;
    [self.view addSubview:_tableView];
}



#pragma mark - MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation && !_firstLocated)
    {
        _currentCoordinate = userLocation.coordinate;
        
        [self changeRegion:userLocation.coordinate];
        _firstLocated = YES;
        [self setLocationFocusButtonFocused:YES];
        
        //_mapView.showsUserLocation = NO;
    }
}

-(void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    //点击cell时只是改变区域 不需要搜索
    if (!_enableSearch) {
        _enableSearch = YES;
        return;
    }
    
    [_locations removeAllObjects];
    
    CLLocationCoordinate2D coordinate = mapView.region.center;
    
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [_search AMapReGoecodeSearch: regeo];
    
    //发起周边搜索
    _request.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [_search AMapPOIAroundSearch: _request];
    
    if (!_firstSearch) {
        _firstSearch = YES;
        return;
    }
    [self setLocationFocusButtonFocused:NO];
}




#pragma mark - AMapSearchDelegate

-(void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    for (AMapPOI *p in response.pois) {
        
        DFLocationInfo *info = [[DFLocationInfo alloc] init];
        info.name = p.name;
        info.address = p.address;
        info.coordinate  = CLLocationCoordinate2DMake(p.location.latitude, p.location.longitude);
        info.checked = NO;
        [_locations addObject:info];
        
    }
    
    [_tableView reloadData];
    _tableView.hidden = NO;
    [_tableView setContentOffset:CGPointMake(0,0) animated:YES];
    
    
}

- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        NSString *result = [NSString stringWithFormat:@"%@", response.regeocode.formattedAddress];
        NSLog(@"ReGeo: %@", result);
        
        DFLocationInfo *info = [[DFLocationInfo alloc] init];
        info.name = response.regeocode.formattedAddress;
        info.address = info.name;
        info.coordinate  = CLLocationCoordinate2DMake(request.location.latitude, request.location.longitude);
        info.checked = YES;
        
        [_locations insertObject:info atIndex:0];
        
        _choosedLocation = info;
        
        
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_locations count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *firstRowIdentifier = @"first_row";
    NSString *otherRowIdentifier = @"other_row";
    
    DFLocationInfo *info = [_locations objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:firstRowIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:firstRowIdentifier];
        }
        
        cell.textLabel.text = info.name;
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:otherRowIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:otherRowIdentifier];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        
        cell.textLabel.text = info.name;
        cell.detailTextLabel.text = info.address;
        
        
    }
    
    if (info.checked) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

#pragma mark - UITableViewDataSource

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    for (DFLocationInfo *info in _locations) {
        info.checked = NO;
    }
    
    DFLocationInfo *info = [_locations objectAtIndex:indexPath.row];
    _choosedLocation = info;
    info.checked = YES;
    
    [_tableView reloadData];
    
    if (indexPath.row != 0) {
        _enableSearch = NO;
        [self changeRegion:info.coordinate];
        [self setLocationFocusButtonFocused:NO];
    }
    
    
}

#pragma mark - Method
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void) changeRegion:(CLLocationCoordinate2D) coordinate
{
    MACoordinateRegion region = MACoordinateRegionMake(coordinate, MACoordinateSpanMake(0.03, 0.03));
    
    [_mapView setRegion:region animated:YES];
}

-(void) setLocationFocusButtonFocused:(BOOL) focus
{
    if (focus) {
        [_locationFocusButton setImage:[UIImage imageNamed:@"location_my_current"] forState:UIControlStateNormal];
    }else{
        [_locationFocusButton setImage:[UIImage imageNamed:@"location_my"] forState:UIControlStateNormal];
    }
}

-(void) onClickLocationFocusButton:(id) sender
{
    _firstLocated = NO;
    _firstSearch = NO;
    [self changeRegion:_currentCoordinate];
    [self setLocationFocusButtonFocused:YES];
}

-(void) sendLocation
{
    if (_delegate && [_delegate respondsToSelector:@selector(onChooseLocation:)]) {
        
        _mapView.showsUserLocation = NO;
        
        //截图 按 长/宽 ＝ 10:6 尺寸截图
        CGFloat margin = 50;
        CGFloat x, y, width, height;
        x = margin;
        width = _mapView.frame.size.width -2*margin;
        height = width*0.6;
        y = (_mapView.frame.size.height - height)/2;
        CGRect inRect = CGRectMake(x, y,width,height);
        UIImage *thumbImage = [_mapView takeSnapshotInRect:inRect];
        _choosedLocation.thumbImage = thumbImage;
        [_delegate onChooseLocation:_choosedLocation];
        
        [self dismiss];
    }
    
}

-(void) dismiss
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end

