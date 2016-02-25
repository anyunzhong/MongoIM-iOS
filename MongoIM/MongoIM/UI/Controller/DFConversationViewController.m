//
//  DFConversationViewController.m
//  MongoIM
//
//  Created by Allen Zhong on 16/1/31.
//  Copyright © 2016年 MongoIM. All rights reserved.
//

#import "DFConversationViewController.h"
#import "DFBarStatusView.h"
#import "DFConversationCell.h"
#import "MongoIM.h"
#import "Key.h"
#import "MMPopupItem.h"
#import "MMAlertView.h"
#import "MMPopupWindow.h"

@interface DFConversationViewController()<UISearchBarDelegate,UISearchResultsUpdating, DFConversationCellDelegate>

@property (nonatomic, strong) NSMutableArray *conversations;

@property (strong,nonatomic) NSMutableArray  *searchConversations;

@property (nonatomic,assign) NSUInteger totalUnreadCount;

@property (nonatomic, strong) DFBarStatusView *barStatusView;

@property (nonatomic, strong) UISearchController *searchController;

@property (nonatomic, assign) BOOL firstAppear;

@end


@implementation DFConversationViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.style = UITableViewStyleGrouped;
        
        _conversations  = [NSMutableArray array];
        
        _firstAppear = YES;
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"消息";
    
    [self initView];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self addNotification];
    
    [self refresh];
    
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (_firstAppear) {
        self.tableView.contentOffset = CGPointMake(0, -16);
        _firstAppear = NO;
    }
}



-(void) initView
{
    
    CGFloat width,height;
    
    if (_barStatusView == nil) {
        
        width = BarStatusViewWidth;
        height = BarStatusViewHeight;
        
        _barStatusView = [[DFBarStatusView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        self.navigationItem.titleView = _barStatusView;
    }
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = YES;
    
    
    UISearchBar *searchBar = _searchController.searchBar;
    
    searchBar.placeholder = @"搜索";
    searchBar.frame = CGRectMake(0, 0, searchBar.frame.size.width, 44.0);
    for (UIView *view in searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
            break;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            break;
        }
    }
    self.tableView.tableHeaderView = self.searchController.searchBar;

}

-(UIBarButtonItem *)rightBarButtonItem
{
    return [UIBarButtonItem icon:@"barbuttonicon_add" selector:@selector(createChat:) target:self];
}


-(void) createChat:(id)sender
{
    
    [[[MMAlertView alloc] initWithInputTitle:@"发起新聊天" detail:@"请输入对方号码" placeholder:@"号码" handler:^(NSString *text) {
        
        DFMessageViewController *messageViewController = [[DFMessageViewController alloc] initWithTargetId:text conversationType:ConversationTypePrivate];
        messageViewController.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:messageViewController animated:YES];
        
    }] showWithBlock:nil];
}


-(void) hideTitleLabel:(BOOL) hide
{
    UIColor *color = hide? [UIColor clearColor]:[UIColor whiteColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    if (!hide) {
        dict = @{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont boldSystemFontOfSize:18]};
    }
    self.navigationController.navigationBar.titleTextAttributes = dict;
}


-(void) addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusChange:) name:NOTIFY_CONNETION_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(messageReceive:) name:NOTIFY_MESSAGE_RECEIVED object:nil];
}

-(void) removeNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_CONNETION_STATUS_CHANGED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFY_MESSAGE_RECEIVED object:nil];
}



#pragma mark - UITabelViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return [_searchConversations count];
    }else{
        return _conversations.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [DFConversationCell getCellHeight];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DFConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"conversationCell"];
    if (cell == nil) {
        cell = [[DFConversationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"conversationCell"];
    }
    
    cell.cellDelegate = self;
    
    DFConversation *conversation;
    if (self.searchController.active) {
        conversation = [_searchConversations objectAtIndex:indexPath.row];
    }else{
        conversation = [_conversations objectAtIndex:indexPath.row];
    }
    [cell updateWithConversation:conversation];
    return cell;
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

#pragma mark - UITabelViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.searchController.active) {
        self.searchController.active = NO;
    }
    
    
    DFConversation *conversation = [_conversations objectAtIndex:indexPath.row];
    DFMessageViewController *messageViewController = [[DFMessageViewController alloc] initWithTargetId:conversation.targetId conversationType:conversation.type];
    messageViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:messageViewController animated:YES];
    
}




#pragma mark - Method

-(void) statusChange:(NSNotification*) notification
{
    NSInteger status = [[[notification userInfo] objectForKey:@"status"] integerValue];
    [_barStatusView changeStatus:status];
}

-(void) messageReceive:(NSNotification*) notification
{
    [self refresh];
}

-(void) refresh
{
    [_conversations removeAllObjects];
    
    
    NSMutableArray *array = [[MongoIM sharedInstance].messageHandler getConversations];
    [_conversations addObjectsFromArray:array];
    
    [self.tableView reloadData];
    
    _totalUnreadCount = 0;
    for (DFConversation *con in _conversations) {
        _totalUnreadCount += con.unreadCount;
    }
    
    [self updateStatusLabel];
    
}

-(void) updateStatusLabel
{
    _barStatusView.unreadCount = _totalUnreadCount;
}

#pragma mark - UISearchResultsUpdating

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchString = [self.searchController.searchBar text];
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"title CONTAINS[c] %@ OR subTitle CONTAINS[c] %@", searchString, searchString];
    if (_searchConversations!= nil) {
        [_searchConversations removeAllObjects];
    }
    _searchConversations = [NSMutableArray arrayWithArray:[_conversations filteredArrayUsingPredicate:preicate]];
    [self.tableView reloadData];
}
#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    NSLog(@"开始编辑");
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    NSLog(@"结束编辑");
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - DFConversationCellDelegate

-(void)onDeleteConversation:(DFConversation *)conversation
{
    DFBaseMessageHandler *hander = [MongoIM sharedInstance].messageHandler;
    [hander deleteConversation:conversation.type targetId:conversation.targetId];
    [_conversations removeObject:conversation];
    [_searchConversations removeObject:conversation];
    [self.tableView reloadData];
}

@end
