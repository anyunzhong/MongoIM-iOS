//
//  DFPhotoAlbumPlugin.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFShortVideoPlugin.h"
#import "DFVideoCaptureController.h"
#import "AFNetworking.h"
#import "DFShortVideoMessageContent.h"
#import "MBProgressHUD.h"
#import "DFMessageViewController.h"

@interface DFShortVideoPlugin()<DFVideoCaptureControllerDelegate>

@end

@implementation DFShortVideoPlugin


#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [super setIcon:@"sharemore_sight"];
        [super setName:@"小视频"];
    }
    return self;
}

-(void)onClickDefault
{
    DFVideoCaptureController *controller = [[DFVideoCaptureController alloc] init];
    controller.delegate = self;
    [self.parentController presentViewController:controller animated:YES completion:^{
        
    }];
}


-(void)onCaptureVideo:(NSString *)filePath screenShot:(UIImage *)screenShot
{

    //上传文件
    
    //DFMessageViewController *controller = (DFMessageViewController *)self.parentController;
    //MBProgressHUD *hud = [controller hudShowLoading:@"上传中..."];
    
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] init];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [manager POST:@"http://debug.crazyfit.appcomeon.com/upload/video/" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:data name:@"file" fileName:@"test.mov" mimeType:@"video/quicktime"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"%@",responseObject);

        //[hud hide:YES];
        
        DFShortVideoMessageContent *content = [[DFShortVideoMessageContent alloc] init];
        content.url = [[responseObject objectForKey:@"data"] objectForKey:@"url"];
        content.cover = screenShot;
        
        [self send:content type:MessageContentTypeShortVideo];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];

    
}

@end
