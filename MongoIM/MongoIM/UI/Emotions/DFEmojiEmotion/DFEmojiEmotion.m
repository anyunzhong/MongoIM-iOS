//
//  DFEmojiEmotion.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/19.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFEmojiEmotion.h"
#import "Key.h"

#define EmojiItemSize 45

//#define EmojiItemIconSize 30


#define Total 105 //包含删除按钮的数量 多少页加多少

#define Columns 7
#define Rows 3
#define BtnTagDelete 0

@interface DFEmojiEmotion()

@property (strong, nonatomic) NSMutableDictionary *dic;

@end

@implementation DFEmojiEmotion

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tabIconLocal = @"EmotionsEmojiHL";
        self.total = Total;
        self.pages = ceil(Total/(double)(Columns*Rows));
    }
    return self;
}


-(UIView *) getView
{
    CGFloat x, y, width, height, horizontalSpace, verticalSpace;
    
    horizontalSpace = (EmotionViewPageWidth - EmojiItemSize * Columns)/(Columns+1);
    verticalSpace = (EmotionViewPageHeight - EmojiItemSize * Rows)/(Rows+1);
    
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pages * EmotionViewPageWidth, EmotionViewPageHeight)];
    NSInteger index = 1;
    for (int page = 1; page <= self.pages ; page++) {
        
        for (int row = 1; row <= Rows ; row++) {
            
            for (int column = 1; column <= Columns ; column++) {
                
                if (index > Total +1) {
                    break;
                }
                x = (page - 1)*EmotionViewPageWidth + horizontalSpace + (column - 1) *(horizontalSpace+EmojiItemSize);
                y = verticalSpace + (row - 1)*(verticalSpace+EmojiItemSize);
                width = EmojiItemSize;
                height = EmojiItemSize;
                
                UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
                [view addSubview:btn];
                //btn.backgroundColor = [UIColor darkGrayColor];
                [btn addTarget:self action:@selector(onEmotionClicked:) forControlEvents:UIControlEventTouchUpInside];
                
                //每页最后一个特殊处理
                if ((column == Columns && row == Rows) || index == Total+1 ) {
                    [btn setImage:[UIImage imageNamed:@"DeleteEmoticonBtn"] forState:UIControlStateNormal];
                    if (index == Total+1) {
                        index++;
                    }
                    btn.tag = BtnTagDelete;
                    continue;
                }
                
                NSString *name = [self getEmotionName:index];
                [btn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ClippedExpression.bundle/%@", name]] forState:UIControlStateNormal];
                [btn setImageEdgeInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
                btn.tag = index;
                
                index++;
                
            }
            
        }
        
    }
    
    
    
    return view;
}


-(void) onEmotionClicked:(UIButton *) btn
{
    NSInteger index = btn.tag;
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (index == BtnTagDelete) {
        [dic setObject:@"" forKey:@"text"];
    }else{
        [dic setObject:[self getTextByIndex:index] forKey:@"text"];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_EMOTION_EMOJI object:nil userInfo:dic];
    
}

-(NSString *) getTextByIndex:(NSInteger) index
{
    if ( _dic == nil) {
        
        _dic = [NSMutableDictionary dictionary];
        
        
        NSBundle *bundle=[NSBundle mainBundle];
        NSString *path=[bundle pathForResource:@"Expression" ofType:@"plist"];
        NSDictionary *map  = [[NSDictionary alloc] initWithContentsOfFile:path];
        
        NSArray *keys = [map allKeys];
        for (int i = 0; i < [keys count]; i++)
        {
            NSString *key = [keys objectAtIndex: i];
            NSString *value = [map objectForKey: key];
            [_dic setObject:key forKey:value];
        }
    }
    
    return [_dic objectForKey:[self getEmotionName:index]];
}

-(NSString *) getEmotionName:(NSInteger)index
{
    return [NSString stringWithFormat:@"Expression_%ld", (long)index];
}
@end
