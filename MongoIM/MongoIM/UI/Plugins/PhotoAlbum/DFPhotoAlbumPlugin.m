//
//  DFPhotoAlbumPlugin.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFPhotoAlbumPlugin.h"
#import "DFImageMessageContent.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface DFPhotoAlbumPlugin()<TZImagePickerControllerDelegate>

@end



@implementation DFPhotoAlbumPlugin


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.icon = @"sharemore_pic";
        self.name = @"照片";
    }
    return self;
}

-(void) onClickDefault
{
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    imagePickerVc.allowPickingVideo = NO;
    [self.parentController presentViewController:imagePickerVc animated:YES completion:nil];
    
}


#pragma mark - TZImagePickerControllerDelegate


- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets
{
    for (UIImage *image in photos) {
        
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
        NSLog(@"%f %f", image.size.width, image.size.height);
        
        [self send:content type:MessageContentTypeImage];
    }
}
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *) photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos
{
}
@end
