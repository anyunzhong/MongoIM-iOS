//
//  DFLocationMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/6.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFLocationMessageCell.h"

#import "DFLocationMessageContent.h"

#import "UIImageView+WebCache.h"

#import "DFShapedImageView.h"

#define IMAGE_WIDTH MaxBubbleWidth
#define IMAGE_HEIGHT IMAGE_WIDTH*0.6

#define LocationLableHeight 30

@interface DFLocationMessageCell()

@property (strong,nonatomic) DFShapedImageView *imgView;

@property (strong,nonatomic) UILabel *locationNameLabel;

@end


@implementation DFLocationMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

-(void) initCell
{
    
    if (_imgView == nil) {
        _imgView =[[DFShapedImageView alloc] initWithFrame:CGRectZero];
        [self.messageContentView addSubview:_imgView];
        
        _locationNameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _locationNameLabel.textColor = [UIColor whiteColor];
        _locationNameLabel.font = [UIFont systemFontOfSize:12];
        [_imgView addSubview:_locationNameLabel];
    }
    
    CGFloat iconSize = 45;
    UIImageView *pingImageView = [[UIImageView alloc] initWithFrame:CGRectMake((IMAGE_WIDTH-iconSize)/2, (IMAGE_HEIGHT-iconSize)/2-15, iconSize, iconSize)];
    pingImageView.image = [UIImage imageNamed:@"fileicon_loc90"];
    [self.messageContentView addSubview:pingImageView];
    
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    DFLocationMessageContent *locationMessage = (DFLocationMessageContent *) message.messageContent;
    
    
    CGFloat x, y ,width ,height;
    
    width = IMAGE_WIDTH;
    height = IMAGE_HEIGHT;
    y= 0;
    x= 0;
    
    if (locationMessage.url == nil) {
        
        NSString *url = [NSString stringWithFormat:@"http://restapi.amap.com/v3/staticmap?location=%f,%f&zoom=12&size=%d*%d&key=f7548383632a917fcd362ee2ccc8d928&scale=2", locationMessage.location.longitude, locationMessage.location.latitude, (int)(IMAGE_WIDTH), (int)(IMAGE_HEIGHT)];
        
        locationMessage.url = url;
    }
    

    _imgView.mask = [self getMaskBubbleImage];
    _imgView.frame = CGRectMake(x, y, width, height);
    [_imgView sd_setImageWithURL:[NSURL URLWithString:locationMessage.url] placeholderImage:locationMessage.thumbnailImage];
    
    
    _locationNameLabel.frame = CGRectMake(10, _imgView.frame.size.height - LocationLableHeight -10, _imgView.frame.size.width-20, LocationLableHeight);
    _locationNameLabel.text = locationMessage.locationName;
    
}


-(CGSize)getMessageContentViewSize
{
    
    return CGSizeMake(IMAGE_WIDTH, IMAGE_HEIGHT);
    
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    return IMAGE_HEIGHT + [super getCellHeight:message];
}

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    
    
}

@end
