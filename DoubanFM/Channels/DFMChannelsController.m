//
//  ChannelsTableViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/21/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMChannelsController.h"
#import <MJRefresh/MJRefresh.h>
#import "YYKit.h"
#import "DFMUser.h"
#import "DFMDataCenter.h"
#import "BlocksKit.h"
#import "KVOController.h"

@interface DFMChannelsController (){
    DFMNetworkManager *networkManager;
}

@end

@implementation DFMChannelsController

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	[self setupTableView];
	[self setupKVO];

    //初始化工具类
    networkManager = [[DFMNetworkManager alloc]init];
    networkManager.delegate = self;

	[self.tableView.header beginRefreshing];
}

- (void)setupKVO {
	@weakify(self);

	[self.KVOController observe:[DFMDataCenter sharedCenter]
	                    keyPath:@"channelTitleList"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id>  *change) {
		                      @strongify(self);
		                      [self.tableView reloadData];
	                      }];

	[self.KVOController observe:[DFMDataCenter sharedCenter]
	                    keyPath:@"myChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id>  *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeMy
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];

	[self.KVOController observe:[DFMDataCenter sharedCenter]
	                    keyPath:@"recommendChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id>  *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeRecmmend
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];

	[self.KVOController observe:[DFMDataCenter sharedCenter]
	                    keyPath:@"upTrendingChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeUpTrending
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];

	[self.KVOController observe:[DFMDataCenter sharedCenter]
	                    keyPath:@"hotChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeHot
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];
}

#pragma mark - Private
- (void)setupTableView {
    self.tableView.sectionHeaderHeight = 80;
    self.tableView.rowHeight = 60;
    
    //用MJRefresh做下来刷新
	[self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(fetchData)];
    [self.tableView.header setTitle:@"往下拉可刷新" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开来就刷新" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"···刷新中···" forState:MJRefreshHeaderStateRefreshing];
    
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = [UIColor grayColor];
    
    UINib *cell = [UINib nibWithNibName:@"ChannelsTableViewCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"theReuseIdentifier"];
}

/**
 * 获取数据
 */
-(void)fetchData {
	[[DFMDataCenter sharedCenter] fetchAllChannels];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [DFMDataCenter sharedCenter].allChannelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[DFMDataCenter sharedCenter].allChannelList objectOrNilAtIndex:(NSUInteger)section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
	return [[DFMDataCenter sharedCenter].channelTitleList objectOrNilAtIndex:(NSUInteger)section]?:@"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"theReuseIdentifier";
    ChannelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
	NSString *title = [[[[DFMDataCenter sharedCenter].allChannelList objectOrNilAtIndex:(NSUInteger)indexPath.section] objectOrNilAtIndex:(NSUInteger)indexPath.row] name];
	cell.textLabel.text = title;
	return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [DFMChannelInfo updateCurrentCannel:[[[DFMDataCenter sharedCenter].allChannelList objectOrNilAtIndex:(NSUInteger)indexPath.section] objectOrNilAtIndex:(NSUInteger)indexPath.row]];
	[networkManager loadPlayListWithType:@"n"];

	AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
	((UITabBarController *)(app.window.rootViewController)).selectedIndex = 0;

//	[self.delegate menuButtonClicked:0];
}

@end
