//
//  DFPluginsView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/18.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFPluginsView.h"

#import "DFPluginsManager.h"

#define TopLineColor [UIColor colorWithWhite:220/255.0 alpha:1.0]


#define PluginsEveryPage320 8
#define PluginsEveryPage320Plus 10

#define PageControlHeight 35

#define PluginViewWidth 59
#define PluginViewHeight 70

#define PluginViewIconWidth 59

@interface DFPluginsView() <UIScrollViewDelegate>

@property (strong,nonatomic) UIView *topLineView;

@property (assign, nonatomic) NSUInteger pluginsEveryPage;

@property (strong, nonatomic) NSMutableArray *plugins;

@property (assign, nonatomic) NSUInteger pages;

@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) UIScrollView *scrollView;


@end


@implementation DFPluginsView


static  DFPluginsView *__view=nil;

+(instancetype) sharedInstance:(CGRect)rect
{
    @synchronized(self){
        if (__view == nil) {
            __view = [[DFPluginsView alloc] initWithFrame:rect];
        }
    }
    return __view;
}



#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        _plugins = [[DFPluginsManager sharedInstance] getPlugins];
        
        [self initView];
    }
    return self;
}


-(void) initView
{
    self.backgroundColor = [UIColor colorWithWhite:250/255.0 alpha:1.0];
    
    NSUInteger pluginsCount = _plugins.count;
    if (pluginsCount <= 0) {
        return;
    }
    
    _pluginsEveryPage = PluginsEveryPage320;
    if (self.frame.size.width > 320) {
        _pluginsEveryPage = PluginsEveryPage320Plus;
    }
    
    _pages = ceil(pluginsCount/(double)_pluginsEveryPage);
    
    [self initPageControl];
    [self initScrollView];
    [self addPluginsToScrollView];
    [self addTopLineView];
}


-(void) initPageControl
{
    CGFloat x,y,width,height;
    x = 0;
    height = PageControlHeight;
    width = self.frame.size.width;
    y = self.frame.size.height - height;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(x, y, width, height)];
    [self addSubview:_pageControl];
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:140/255.0 alpha:1.0];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:225/255.0 alpha:1.0];;
    _pageControl.numberOfPages = _pages;
    _pageControl.currentPage = 0;
    
    _pageControl.hidden = _pages <=1?YES:NO;
    
}


-(void) initScrollView
{
    CGFloat x,y,width,height;
    x = 0;
    height = self.frame.size.height - PageControlHeight + 15;
    width = self.frame.size.width;
    y = 0;
    
    _scrollView = [[ UIScrollView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    _scrollView.backgroundColor =[UIColor clearColor];
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(width*_pages, height);
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
}

-(void) addPluginsToScrollView
{
    for (int index = 0; index < _pages; index ++) {
        
        CGFloat x,y,width,height;
        y = 0;
        height = _scrollView.frame.size.height;
        width = _scrollView.frame.size.width;
        x = index * width;
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        [_scrollView addSubview:contentView];
        [self addPluginsToContentView:contentView index:index];
    }
    
}

-(void) addTopLineView
{
    if (_topLineView == nil) {
        _topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0.4)];
        _topLineView.backgroundColor = TopLineColor;
        [self addSubview:_topLineView];
    }
}

-(void) addPluginsToContentView:(UIView *) contentView index:(NSUInteger)index
{
    CGFloat x,y,width,height;
    
    CGFloat horizontalSpace = (_scrollView.frame.size.width - (_pluginsEveryPage/2) * PluginViewWidth)/(_pluginsEveryPage/2 + 1);
    CGFloat verticalSpace = (_scrollView.frame.size.height - 2 * PluginViewHeight)/3;
    
    int counter = 0;
    
    for (unsigned long i = index * _pluginsEveryPage; counter<_pluginsEveryPage && i < _plugins.count; i++) {
        
        x = horizontalSpace + counter*(horizontalSpace + PluginViewWidth);
        if (counter >  (_pluginsEveryPage/2-1)) {
            x = horizontalSpace + (counter-_pluginsEveryPage/2)*(horizontalSpace + PluginViewWidth);
        }
        
        y = verticalSpace;
        if (counter > (_pluginsEveryPage/2-1)) {
            y = 2*verticalSpace + PluginViewHeight;
        }
        
        height = PluginViewHeight;
        width = PluginViewWidth;
        
        
        DFBasePlugin *plugin = [_plugins objectAtIndex:i];
        
        UIButton *pluginBtn = [self getPluginView:CGRectMake(x, y, width, width) icon:plugin.icon name:plugin.name];
        [contentView addSubview:pluginBtn];
        
        [pluginBtn addTarget:self action:@selector(onClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        pluginBtn.tag = i;
        
        counter++;
        
    }
    
}


-(UIButton *) getPluginView:(CGRect) frame  icon:(NSString *) icon name:(NSString *)name
{
    UIButton *pluginBtn = [[UIButton alloc] initWithFrame:frame];
    //[pluginBtn setBackgroundImage:[UIImage imageNamed:@"Plugins_BG"] forState:UIControlStateNormal];
    [pluginBtn setBackgroundImage:[UIImage imageNamed:@"Plugins_BG_HL"] forState:UIControlStateHighlighted];
    
    CGFloat x,y,width,height;
    x = 0;
    y = 0;
    width = frame.size.width;
    height = width;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    imageView.image = [UIImage imageNamed:icon];
    imageView.layer.borderColor = [UIColor colorWithWhite:150/255.0 alpha:1.0].CGColor;
    imageView.layer.borderWidth = 0.5;
    imageView.layer.cornerRadius = 5;
    [pluginBtn addSubview:imageView];
    
    
    height = 20;
    y = frame.size.height;
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
    nameLabel.text = name;
    nameLabel.font = [UIFont systemFontOfSize:12];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.textColor = [UIColor colorWithWhite:105/255.0 alpha:1.0];
    [pluginBtn addSubview:nameLabel];
    
    
    
    
    return pluginBtn;
}


#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger index = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    _pageControl.currentPage = index;
}

#pragma mark - Method

-(void) onClickBtn:(UIButton *) btn
{
    NSInteger i = btn.tag;
    DFBasePlugin *plugin = [_plugins objectAtIndex:i];
    [plugin onClick];
}
@end
