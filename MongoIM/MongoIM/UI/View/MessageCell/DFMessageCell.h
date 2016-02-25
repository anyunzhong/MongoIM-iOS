//
//  DFMessageCell.h
//  MongoIM
//
//  Created by Allen Zhong on 16/1/27.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFBaseMessageCell.h"

#define MaxBubbleWidth CellWidth*0.7

#define Padding 8

@interface DFMessageCell : DFBaseMessageCell

@property (strong, nonatomic) UIView *messageContentView;


-(CGSize) getMessageContentViewSize;

-(UIImage *) getMaskBubbleImage;

-(void) onLongPress;

-(void) onTap;

@end
