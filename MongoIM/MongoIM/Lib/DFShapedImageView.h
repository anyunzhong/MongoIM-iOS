//
//  DFShapedImageView.h
//  iconTest
//
//  Created by Allen Zhong on 16/2/14.
//  Copyright © 2016年 Datafans. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DFShapedImageView : UIImageView

@property (nonatomic, strong) UIImage *mask;
@property (nonatomic, strong) CALayer *contentLayer;

@end
