//
//  DFEmotionsView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/18.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFEmotionsView.h"

#import "DFBaseEmotion.h"

#import "DFEmojiEmotion.h"

#import "DFEmotionsManager.h"

#import "Key.h"

#import "UIImageView+WebCache.h"

#define EmotionTabItemWidth 50
#define EmotionTabItemHeight 37
#define EmotionTabItemIconSize 25

#define EmotionSendBtnWidth 70
#define EmotionSendBtnHeight 37

#define EmotionAddBtnWidth 50

#define PageControlHeight 15


@interface DFEmotionsView() <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *emotions;

@property (nonatomic, assign) NSUInteger totalPages;


@property (nonatomic, strong) UIScrollView *tabScrollView;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) NSMutableArray *tabArray;

@property (nonatomic, strong) NSMutableDictionary *pageDic;

@end


@implementation DFEmotionsView


static  DFEmotionsView *__view=nil;

+(instancetype) sharedInstance:(CGRect)rect
{
    @synchronized(self){
        if (__view == nil) {
            __view = [[DFEmotionsView alloc] initWithFrame:rect];
        }
    }
    return __view;
}



#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _emotions = [[DFEmotionsManager sharedInstance] getEmotions];
        _totalPages = 0;
        
        _tabArray = [NSMutableArray array];
        _pageDic = [NSMutableDictionary dictionary];
        
        [self initView];
        
        [self addNotify];
    }
    return self;
}

-(void)dealloc
{
    [self removeNotify];
}
-(void) initView
{
    self.backgroundColor = [UIColor whiteColor];
    
    
    
    
    [self initMainScrollView];
    [self addEmotionsToMainScrollView];
    
    
    [self initPageControl];
    
    [self initTabScrollView];
    [self initSendAndAddBtn];
    
}





-(void) initSendAndAddBtn
{
    CGFloat x, y, width, height;
    
    x = self.frame.size.width - EmotionSendBtnWidth ;
    y = self.frame.size.height - EmotionTabItemHeight;
    width = EmotionSendBtnWidth;
    height = EmotionSendBtnHeight;
    
    if (_sendBtn == nil) {
        
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        _sendBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"EmotionsSendBtnGrey"]];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_sendBtn addTarget:self action:@selector(onClickSendBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_sendBtn];
        
    }
    
    //添加表情按钮
    //添加表情
    x=0;
    UIButton *btn = [self getEmotionTabButton:CGRectMake(x, y, EmotionAddBtnWidth, height) icon:@"EmotionAdd" iconUrl:nil];
    [self addSubview:btn];
}



-(void) initMainScrollView
{
    //计算总的页数
    for (DFBaseEmotion *emotion in _emotions) {
        _totalPages += emotion.pages;
    }
    
    
    CGFloat x, y, width, height;
    
    x = 0;
    y = 0;
    width = self.frame.size.width;
    height = self.frame.size.height - EmotionTabItemHeight;
    
    if (_mainScrollView == nil) {
        
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _mainScrollView.bounces = YES;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.contentSize = CGSizeMake(width*_totalPages, height);
        _mainScrollView.delegate = self;
        
        [self addSubview:_mainScrollView];
    }
    
    //顶部加线
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:220/255.0 alpha:1.0];
    [self addSubview:line];
    
    
}



-(void) addEmotionsToMainScrollView
{
    CGFloat x, y, width, height, xOffset = 0;
    
    NSInteger pageIndex = 1;
    
    for (int i = 0; i<_emotions.count; i++) {
        
        DFBaseEmotion *emotion = [_emotions objectAtIndex:i];
        
        UIView *view = [emotion getView];
        
        x = xOffset;
        y = 0;
        width = view.frame.size.width;
        height = view.frame.size.height;
        
        view.frame = CGRectMake(x, y, width, height);
        [_mainScrollView addSubview:view];
        
        emotion.xOffset = x;
        emotion.pageIndexOffset = pageIndex;
        
        xOffset+= width;
        
        
        //初始化每个emotion对应的page
        for (int page=1; page<=emotion.pages; page++) {
            [_pageDic setObject:[NSNumber numberWithInt:i] forKey:[NSNumber numberWithInteger:pageIndex]];
            pageIndex++;
        }
    }
}


-(void) initPageControl
{
    CGFloat x,y,width,height;
    x = 0;
    height = PageControlHeight;
    width = self.frame.size.width;
    y = self.frame.size.height - height - EmotionTabItemHeight;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self addSubview:_pageControl];
    
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:140/255.0 alpha:1.0];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];
    
    if (_emotions != nil && _emotions.count >0) {
        DFBaseEmotion *firstEmotion = [_emotions objectAtIndex:0];
        _pageControl.numberOfPages = firstEmotion.pages;
        _pageControl.currentPage = 0;
    }
    
    
}



-(void) initTabScrollView
{
    CGFloat x, y, width, height;
    
    
    
    x = EmotionAddBtnWidth;
    y = self.frame.size.height - EmotionTabItemHeight;
    width = self.frame.size.width - EmotionTabItemWidth;
    height = EmotionTabItemHeight;
    
    if (_tabScrollView == nil) {
        
        _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _tabScrollView.bounces = YES;
        _tabScrollView.pagingEnabled = NO;
        _tabScrollView.showsHorizontalScrollIndicator = NO;
        _tabScrollView.showsVerticalScrollIndicator = NO;
        _tabScrollView.contentSize = CGSizeMake(EmotionTabItemWidth*(_emotions.count + 2), height);
        _tabScrollView.delegate = self;
        
        [self addSubview:_tabScrollView];
        
    }
    
    //顶部加线
    UIView *line =[[UIView alloc] initWithFrame:CGRectMake(x, y, self.frame.size.width, 0.5)];
    line.backgroundColor = [UIColor colorWithWhite:200/255.0 alpha:1.0];
    [self addSubview:line];
    
    
    [self initEmotionTabs];
}


-(void) initEmotionTabs
{
    CGFloat x, y, width, height;
    
    for (int i = 0; i<_emotions.count + 1; i++) {
        
        x = i*EmotionTabItemWidth;
        y = 0;
        width = EmotionTabItemWidth;
        height = EmotionTabItemHeight;
        
        //表情设置
        if (i == _emotions.count) {
            
            UIButton *btn = [self getEmotionTabButton:CGRectMake(x, y, width, height) icon:@"EmotionsSetting" iconUrl:nil];
            [_tabScrollView addSubview:btn];
            continue;
        }
        
        //表情添加
//        if (i == _emotions.count+1) {
//            
//            UIButton *btn = [self getEmotionTabButton:CGRectMake(x, y, width, height) icon:@"EmotionsBagAdd" iconUrl:nil];
//            [_tabScrollView addSubview:btn];
//            continue;
//        }
        
        DFBaseEmotion *emotion = [_emotions objectAtIndex:i];
        
        
        UIButton *btn = [self getEmotionTabButton:CGRectMake(x, y, width, height) icon:emotion.tabIconLocal iconUrl:emotion.tabIconUrl];
        [_tabScrollView addSubview:btn];
        btn.tag = i;
        [btn addTarget:self action:@selector(onClickEmtionTab:) forControlEvents:UIControlEventTouchUpInside];
        
        [_tabArray addObject:btn];
        
        if (i == 0) {
            btn.selected = YES;
        }
    }
}


-(UIButton *) getEmotionTabButton:(CGRect) frame icon:(NSString *) icon iconUrl:(NSString *) url
{
    UIButton *btn = [[UIButton alloc] initWithFrame:frame];
    [btn setImage:[UIImage imageNamed:@"EmotionsBagTabBg"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"EmotionsBagTabBgFocus"] forState:UIControlStateSelected];
    
    //添加icon
    CGFloat x, y, width, height;
    x = (frame.size.width - EmotionTabItemIconSize)/2;
    y = (frame.size.height - EmotionTabItemIconSize)/2;
    width = EmotionTabItemIconSize;
    height = EmotionTabItemIconSize;
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    if (url == nil) {
        iconView.image = [UIImage imageNamed:icon];
    }else{
        //iconView.image = iconImage;
        [iconView sd_setImageWithURL:[NSURL URLWithString:url]];
    }
    
    [btn addSubview:iconView];
    
    return btn;
}


#pragma mark - Method

-(void) onClickSendBtn:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFY_EMOTION_EMOJI_SEND object:nil userInfo:nil];
    _sendBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"EmotionsSendBtnGrey"]];
    [_sendBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
}


-(void) onClickEmtionTab:(UIButton * )btn
{
    NSInteger index = btn.tag;
    
    DFBaseEmotion *emotion = [_emotions objectAtIndex:index];
    
    CGFloat x, y, width, height;
    x = emotion.xOffset;
    y = 0;
    width = self.frame.size.width;
    height = self.frame.size.height;
    
    
    [_mainScrollView scrollRectToVisible:CGRectMake(x, y, width, height) animated:NO];
    
    [self onEmotionTabSelected:index];
    [self refreshPageControl:index currentPage:emotion.pageIndexOffset];
}


-(void) onEmotionTabSelected:(NSInteger)index
{
    for (int i=0; i<_tabArray.count; i++) {
        UIButton *btn = [_tabArray objectAtIndex:i];
        btn.selected = i==index?YES:NO;
    }
    
    CGFloat x, y, width, height;
    
    x = (index-2)*EmotionTabItemWidth;
    y = 0;
    width = _tabScrollView.frame.size.width;
    height = _tabScrollView.frame.size.height;
    
    [_tabScrollView scrollRectToVisible:CGRectMake(x, y, width, height) animated:YES];
    
    
}


-(void) refreshPageControl:(NSInteger)tabIndex currentPage:(NSInteger) currentPage
{
    DFBaseEmotion *emotion = [_emotions objectAtIndex:tabIndex];
    _pageControl.numberOfPages = emotion.pages;
    _pageControl.currentPage = currentPage - emotion.pageIndexOffset;
}


#pragma mark - Notification

-(void) addNotify
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTextViewChange:) name:NOTIFY_TEXTVIEW_CONTENT_CHANGE object:nil];
    
}

-(void) removeNotify
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_TEXTVIEW_CONTENT_CHANGE object:nil];
}


-(void) onTextViewChange:(NSNotification *)notify
{
    NSDictionary *dic = notify.userInfo;
    NSString *text = [dic objectForKey:@"text"];
    BOOL isEmpty = [text isEqualToString:@""];
    NSString *bg = isEmpty?@"EmotionsSendBtnGrey":@"EmotionsSendBtnBlue";
    UIColor *color = isEmpty?[UIColor darkGrayColor]:[UIColor whiteColor];
    _sendBtn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:bg]];
    [_sendBtn setTitleColor:color forState:UIControlStateNormal];
}




#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _mainScrollView) {
        NSUInteger currentPage = scrollView.contentOffset.x/scrollView.frame.size.width + 1;
        
        NSInteger tabIndex = [[_pageDic objectForKey:[NSNumber numberWithInteger:currentPage]] integerValue];
        
        [self onEmotionTabSelected:tabIndex];
        [self refreshPageControl:tabIndex currentPage:currentPage];
    }
}


@end
