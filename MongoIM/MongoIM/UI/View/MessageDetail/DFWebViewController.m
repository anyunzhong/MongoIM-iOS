//
//  DFWebViewController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/2/12.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFWebViewController.h"
#import <WebKit/WebKit.h>

@interface DFWebViewController()

@property (nonatomic, strong) NSString *url;
@property (strong,nonatomic) WKWebView *webView;
@property (strong,nonatomic) UIProgressView *progress;

@end

@implementation DFWebViewController

- (instancetype)initWithUrl:(NSString *)url title:(NSString *) title
{
    self = [super init];
    if (self) {
        self.title = title;
        _url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:_webView];
    
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:_url]];
    [_webView loadRequest:request];
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    _progress = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 10)];
    [self.view addSubview:_progress];
    
    
}

-(UIBarButtonItem *)leftBarButtonItem
{
    return [self defaultReturnBarButtonItem];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath  isEqual: @"estimatedProgress"]) {
        _progress.hidden = _webView.estimatedProgress == 1;
        [_progress setProgress:_webView.estimatedProgress animated:YES];
    }
}


@end
