//
//  DFShortVideoMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFShortVideoMessageCell.h"
#import "DFShapedImageView.h"
#import "DFShortVideoMessageContent.h"
#import "DFToolUtil.h"
#import "DFSandboxHelper.h"

#import "DFVideoPlayController.h"

#define Bubble_Height (MaxBubbleWidth)*1.0
@interface DFShortVideoMessageCell()<DFVideoDecoderDelegate>

@property (strong,nonatomic) DFShapedImageView *imgView;

@property (nonatomic, strong) DFShortVideoMessageContent *videoMessage;

@end


@implementation DFShortVideoMessageCell

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
    
    CGFloat x, y ,width ,height;
    
    width = MaxBubbleWidth;
    height = Bubble_Height;
    y= 0;
    x= 0;
    
    
    if (_imgView == nil) {
        _imgView =[[DFShapedImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [self.messageContentView addSubview:_imgView];
    }
    
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    _videoMessage = (DFShortVideoMessageContent *) message.messageContent;
    
    _imgView.mask = [self getMaskBubbleImage];
    _imgView.image = _videoMessage.cover;
    
    
    if (_videoMessage.filePath != nil) {
        [self decodeVideo];
    }
    
    NSFileManager *manager = [NSFileManager defaultManager];
    if (_videoMessage.url != nil) {
        
        NSString *key = [DFToolUtil md5:_videoMessage.url];
        NSString *dirPath = [NSString stringWithFormat:@"%@/%@",[DFSandboxHelper getDocPath], @"/videoCache/"];
        BOOL isDir = YES;
        if (![manager fileExistsAtPath:dirPath isDirectory:&isDir]) {
            [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@%@.mov",dirPath, key];
        
        if ([manager fileExistsAtPath:filePath]) {
            _videoMessage.filePath = filePath;
            [self decodeVideo];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_videoMessage.url]];
                [data writeToFile:filePath atomically:YES];
                [self performSelectorOnMainThread:@selector(downloadFinish:) withObject:filePath waitUntilDone:NO];
            });
            
        }

    }
    
}

-(void) downloadFinish:(NSString *) filePath
{
    _videoMessage.filePath = filePath;
    [self decodeVideo];
}

-(void) decodeVideo
{
    if (_videoMessage.decorder == nil) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DFVideoDecoder *decoder = [[DFVideoDecoder alloc] initWithFile:_videoMessage.filePath];
            decoder.delegate = self;
            _videoMessage.decorder = decoder;
            [decoder decode];
        });
    }else{
        [self onDecodeFinished];
    }
}

-(void)onDecodeFinished
{
    //解码完成 刷新界面
    NSLog(@"解码完成");
    dispatch_async(dispatch_get_main_queue(), ^{
        if (_videoMessage.decorder.animation != nil) {
            [_imgView.contentLayer removeAnimationForKey:@"contents"];
            [_imgView.contentLayer addAnimation:_videoMessage.decorder.animation forKey:nil];
            
        }
    });
}


-(CGSize)getMessageContentViewSize
{
    return CGSizeMake(MaxBubbleWidth, Bubble_Height);
    
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    return Bubble_Height + [super getCellHeight:message];
}

-(void)onClick:(DFMessage *)message controller:(UINavigationController *)controller
{
    DFShortVideoMessageContent *videoMessage = (DFShortVideoMessageContent *)message.messageContent;
    DFVideoPlayController *playController = [[DFVideoPlayController alloc] initWithFile:videoMessage.filePath];
    [controller presentViewController:playController animated:YES completion:^{
        
    }];
}

@end
