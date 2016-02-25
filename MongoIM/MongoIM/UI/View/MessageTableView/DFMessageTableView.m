//
//  DFMessageTableView.m
//  DFWeChatView
//
//  Created by Allen Zhong on 15/4/18.
//  Copyright (c) 2015年 Datafans, Inc. All rights reserved.
//

#import "DFMessageTableView.h"


@interface DFMessageTableView()

@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end


@implementation DFMessageTableView



#pragma mark - Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}


-(void) initView
{
    
    self.separatorStyle = UITableViewCellSelectionStyleNone;
    
    if (_refreshControl == nil) {
        _refreshControl = [[UIRefreshControl alloc] init];
        [_refreshControl addTarget:self action:@selector(onPullDown:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:self.refreshControl];
    }

}

-(void) onPullDown:(id) sender
{
    if (_messageDelegate != nil && [_messageDelegate respondsToSelector:@selector(onPullDown)]) {
        [_messageDelegate onPullDown];
    }
}

-(void)onLoadFinish
{
    [_refreshControl endRefreshing];
}

@end
