//
//  DFPhotoAlbumPlugin.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFPhotoCameraPlugin.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DFImageMessageContent.h"

@interface DFPhotoCameraPlugin()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImagePickerController *pickerController;

@end




@implementation DFPhotoCameraPlugin


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_video";
        self.name = @"拍摄";
    }
    return self;
}


-(void)onClickDefault
{
    if (_pickerController == nil) {
        _pickerController = [[UIImagePickerController alloc] init];
        _pickerController.delegate = self;
        _pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    
    [self.parentController presentViewController:_pickerController animated:YES completion:nil];
}



-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *finalImage = image;
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        finalImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    
    DFImageMessageContent *content = [[DFImageMessageContent alloc] init];
    content.originImage = finalImage;
    
    [self send:content type:MessageContentTypeImage];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [_pickerController dismissViewControllerAnimated:YES completion:nil];
}

@end
