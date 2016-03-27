//
//  DFImageMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/2.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFImageMessageCell.h"

#import "DFImageMessageContent.h"

#import "UIImageView+WebCache.h"

#import "DFShapedImageView.h"

#import "DFBaseMessageHandler.h"
#import "MongoIM.h"
#import "MessageContentType.h"

#import "MWPhotoBrowser.h"

#define IMAGE_BUBBLE_WIDTH  MaxBubbleWidth*0.7

@interface DFImageMessageCell()

@property (strong,nonatomic) DFShapedImageView *imgView;


@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) NSMutableArray *messages;


@end



@implementation DFImageMessageCell
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
    }
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    DFImageMessageContent *imageMessage = (DFImageMessageContent *) message.messageContent;
    
    CGFloat x, y ,width ,height;
    
    width = imageMessage.width;
    height = imageMessage.height;
    y= 0;
    x= 0;
    
    _imgView.mask = [self getMaskBubbleImage];
    _imgView.frame = CGRectMake(x, y, width, height);
    
    
    if (imageMessage.originImage != nil) {
        _imgView.image = imageMessage.originImage;
        return;
    }
    
    //[_imgView sd_setImageWithURL:[NSURL URLWithString:imageMessage.url] placeholderImage:imageMessage.thumbImage];
    
}


-(CGSize)getMessageContentViewSize
{
    DFImageMessageContent *imageMessage = (DFImageMessageContent *)self.message.messageContent;
    
    return CGSizeMake(imageMessage.width, imageMessage.height);
    
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    DFImageMessageContent *imageMessage = (DFImageMessageContent *)message.messageContent;
    UIImage *thumbImage = imageMessage.thumbImage;
    
    
    //计算高度
    if (imageMessage.width <=0) {
        CGFloat width = thumbImage.size.width;
        CGFloat height = thumbImage.size.height;
        
        if (thumbImage == nil) {
            width = imageMessage.originImage.size.width;
            height = imageMessage.originImage.size.height;
        }
        
        CGFloat rate = width/(double)height;
        
        if (width >= height) {
            if (width > IMAGE_BUBBLE_WIDTH) {
                imageMessage.width = IMAGE_BUBBLE_WIDTH;
                imageMessage.height = imageMessage.width / rate;
            }
        }else{
            if (height > IMAGE_BUBBLE_WIDTH) {
                imageMessage.height = IMAGE_BUBBLE_WIDTH;
                imageMessage.width = imageMessage.height * rate;
            }
            
        }
    }
    
    return imageMessage.height + [super getCellHeight:message];
}

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    
    DFBaseMessageHandler *messageHandler = [MongoIM sharedInstance].messageHandler;
    
    _messages = [messageHandler getImageMessages:message.conversationType targetId:message.targetId size:100];
    
    if (_photos == nil) {
        _photos = [NSMutableArray array];
    }
    
    [_photos removeAllObjects];
    
    
    NSUInteger currentIndex = 0;
    for (int i=0; i<_messages.count; i++) {
        
        DFMessage *msg = (DFMessage *)[_messages objectAtIndex:i];
        if (message.messageId == msg.messageId) {
            currentIndex = i;
        }
        
        DFImageMessageContent *imageMessage = (DFImageMessageContent *)msg.messageContent;
        
        
        MWPhoto *photo;
        if (![imageMessage.url hasPrefix:@"http://"]) {
            photo = [[MWPhoto alloc] initWithImage:imageMessage.originImage];
        }else{
            photo = [[MWPhoto alloc] initWithURL:[NSURL URLWithString:imageMessage.url]];
        }
        
        [_photos addObject:photo];
    }
    
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:currentIndex];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:browser];
    [controller presentViewController:nav animated:YES completion:nil];
    
}

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;
{
    return [_photos objectAtIndex:index];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    DFImageMessageContent *imageMessage = (DFImageMessageContent *)(((DFMessage *)[_messages objectAtIndex:index]).messageContent);
    return [[MWPhoto alloc] initWithImage:imageMessage.thumbImage];
}


@end
