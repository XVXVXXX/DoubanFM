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
#import "DFMChannelDataCenter.h"
#import "KVOController.h"

@interface DFMChannelsController ()

@end

@implementation DFMChannelsController

static NSString *kReuseIdentifier = @"theReuseIdentifier";

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

	[self.tableView.header beginRefreshing];
}

- (void)setupKVO {
	@weakify(self);

	[self.KVOController observe:[DFMChannelDataCenter sharedCenter]
	                    keyPath:@"channelTitleList"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
		                      @strongify(self);
		                      [self.tableView reloadData];
	                      }];

	[self.KVOController observe:[DFMChannelDataCenter sharedCenter]
	                    keyPath:@"myChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeMy
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];

	[self.KVOController observe:[DFMChannelDataCenter sharedCenter]
	                    keyPath:@"recommendChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeRecommend
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];

	[self.KVOController observe:[DFMChannelDataCenter sharedCenter]
	                    keyPath:@"upTrendingChannels"
	                    options:NSKeyValueObservingOptionNew
	                      block:^(id observer, id object, NSDictionary<NSString *, id> *change) {
		                      @strongify(self);
		                      [self.tableView.header endRefreshing];
		                      [self.tableView reloadSection:DFMChannelTypeUpTrending
		                                   withRowAnimation:UITableViewRowAnimationFade];
	                      }];

	[self.KVOController observe:[DFMChannelDataCenter sharedCenter]
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
	[self.tableView registerNib:cell forCellReuseIdentifier:kReuseIdentifier];
}

/**
 * 获取数据
 */
- (void)fetchData {
	[[DFMChannelDataCenter sharedCenter] fetchAllChannels];
}

#pragma mark - <UITableViewDataSource> <UITableViewDelegate>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [DFMChannelDataCenter sharedCenter].allChannelList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[DFMChannelDataCenter sharedCenter].allChannelList objectOrNilAtIndex:(NSUInteger) section] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[DFMChannelDataCenter sharedCenter].channelTitleList objectOrNilAtIndex:(NSUInteger) section] ?: @"";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	ChannelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kReuseIdentifier forIndexPath:indexPath];
	NSString *title = [[[[DFMChannelDataCenter sharedCenter].allChannelList objectOrNilAtIndex:(NSUInteger) indexPath.section] objectOrNilAtIndex:(NSUInteger) indexPath.row] name];
	cell.textLabel.text = title;
	return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[DFMChannelDataCenter sharedCenter].currentChannel = [[[DFMChannelDataCenter sharedCenter].allChannelList objectOrNilAtIndex:(NSUInteger) indexPath.section] objectOrNilAtIndex:(NSUInteger) indexPath.row];

	[[DFMPlayerController sharedController] requestPlayListWithType:DFMPlayerListRequestTypeNormal];

	//切换Tab到播放器页面
	AppDelegate *app = (AppDelegate *) [[UIApplication sharedApplication] delegate];
	((UITabBarController *) (app.window.rootViewController)).selectedIndex = 0;
}

@end
