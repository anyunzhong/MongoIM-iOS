//
//  DFEmotionMessageCell.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/11.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFEmotionMessageCell.h"
#import "DFEmotionMessageContent.h"

#import "FLAnimatedImageView.h"
#import "FLAnimatedImage.h"

#import "DFToolUtil.h"
#import "DFSandboxHelper.h"

#define EmotionItemSize 130
#define EmotionItemMargin 10

@interface DFEmotionMessageCell()

@property (nonatomic,strong) FLAnimatedImageView *emotionImageView;

@end

@implementation DFEmotionMessageCell


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
    if (_emotionImageView == nil) {
        _emotionImageView = [[FLAnimatedImageView alloc] init];
        [self.messageContentView addSubview:_emotionImageView];
    }
}

-(void)updateWithMessage:(DFMessage *)message
{
    [super updateWithMessage:message];
    
    DFEmotionMessageContent *emotionMessage = (DFEmotionMessageContent *) message.messageContent;
    
    CGFloat x, y ,width ,height;
    
    
    width = EmotionItemSize;
    height = EmotionItemSize;
    x = EmotionItemMargin;
    y = EmotionItemMargin;
    
    DFPackageEmotionItem *item = emotionMessage.emotionItem;
    
    NSData *data = nil;
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (item.localGif != nil && ![item.localGif isEqualToString:@""]) {
        data = [NSData dataWithContentsOfFile:item.localGif];
    }else if(item.remoteGif != nil){
        
        NSString *key = [DFToolUtil md5:item.remoteGif];
        NSString *dirPath = [NSString stringWithFormat:@"%@/%@",[DFSandboxHelper getDocPath], @"/gifCache/"];
        BOOL isDir = YES;
        if (![manager fileExistsAtPath:dirPath isDirectory:&isDir]) {
            [manager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@%@",dirPath, key];
        
        if ([manager fileExistsAtPath:filePath]) {
            data = [NSData dataWithContentsOfFile:filePath];
        }else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:item.remoteGif]];
                [data writeToFile:filePath atomically:YES];
                [self performSelectorOnMainThread:@selector(updateImageView:) withObject:data waitUntilDone:NO];
            });
            
        }
    }
    if (data != nil) {
        FLAnimatedImage *image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
        
        _emotionImageView.animatedImage = image;
    }
    
    _emotionImageView.frame = CGRectMake(x, y, width, height);
    
}


-(void) updateImageView:(NSData *) data
{
    FLAnimatedImage *image = [[FLAnimatedImage alloc] initWithAnimatedGIFData:data];
    
    _emotionImageView.animatedImage = image;
}


-(CGSize)getMessageContentViewSize
{
    return CGSizeMake(EmotionItemSize+2*EmotionItemMargin, EmotionItemSize+2*EmotionItemMargin);
}

-(CGFloat)getCellHeight:(DFMessage *)message
{
    return EmotionItemSize+2*EmotionItemMargin + [super getCellHeight:message];
}



@end
