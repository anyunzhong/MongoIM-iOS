//
//  DFShapedImageView.m
//  iconTest
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 Datafans. All rights reserved.
//

#import "DFShapedImageView.h"

#define BorderWidth 0.5

@interface DFShapedImageView()

{
    CALayer *_imgMaskLayer;
    CALayer *_bgMaskLayer;
    CALayer *_bgLayer;
}

@end

@implementation DFShapedImageView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //添加背景层
        _bgLayer = [CALayer layer];
        _bgLayer.frame = self.bounds;
        _bgLayer.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1.0].CGColor;
        [self.layer addSublayer:_bgLayer];
        
        //背景蒙板
        _bgMaskLayer = [CALayer layer];
        _bgMaskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        _bgMaskLayer.contentsScale = [UIScreen mainScreen].scale;
        _bgMaskLayer.frame = _bgLayer.bounds;
        _bgLayer.mask = _bgMaskLayer;
        _bgLayer.masksToBounds = YES;
        
        
        //图片层
        _contentLayer= [CALayer layer];
        _contentLayer.frame = CGRectMake(BorderWidth, BorderWidth, self.frame.size.width-BorderWidth*2, self.frame.size.height-BorderWidth*2);
        [self.layer addSublayer:_contentLayer];

        //图片蒙板
        _imgMaskLayer = [CALayer layer];
        _imgMaskLayer.contentsCenter = CGRectMake(0.5, 0.5, 0.1, 0.1);
        _imgMaskLayer.contentsScale = [UIScreen mainScreen].scale;
        _imgMaskLayer.frame = _contentLayer.bounds;
        _contentLayer.mask = _imgMaskLayer;
        _contentLayer.masksToBounds = YES;
    }
    return self;
}


-(void)layoutSubviews
{
    _bgLayer.frame = self.bounds;
    _bgMaskLayer.frame = _bgLayer.bounds;
    _contentLayer.frame = CGRectMake(BorderWidth, BorderWidth, self.frame.size.width-BorderWidth*2, self.frame.size.height-BorderWidth*2);
    _imgMaskLayer.frame = _contentLayer.bounds;
    
}

-(void)setImage:(UIImage *)image
{
    _contentLayer.contents = (id)image.CGImage;
}

-(void)setMask:(UIImage *)mask
{
    _imgMaskLayer.contents = (id)mask.CGImage;
    _bgMaskLayer.contents = (id)mask.CGImage;
}

@end
