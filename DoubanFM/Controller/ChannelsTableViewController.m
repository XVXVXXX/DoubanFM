//
//  ChannelsTableViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/21/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "ChannelsTableViewController.h"
#import <MJRefresh/MJRefresh.h>
@interface ChannelsTableViewController (){
    AFHTTPRequestOperationManager *manager;
    AppDelegate *appDelegate;
    NetworkManager *networkManager;
    PlayerController *playerController;
}

@end

@implementation ChannelsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.sectionHeaderHeight = 80;
    self.tableView.rowHeight = 60;
    //初始化工具类
    appDelegate = [[UIApplication sharedApplication]delegate];
    networkManager = [[NetworkManager alloc]init];
    networkManager.delegate = self;
    playerController = [[PlayerController alloc]init];
    //初始化tableviewCell
    UINib *cell = [UINib nibWithNibName:@"ChannelsTableViewCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"theReuseIdentifier"];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    //用MJRefresh做下来刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(initChannelInfo)];
    
    // 设置文字
    [self.tableView.header setTitle:@"往下拉可刷新哦" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开来就刷新啦" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"~~刷~~新~~中~~" forState:MJRefreshHeaderStateRefreshing];
    
    // 设置字体
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    
    // 设置颜色
    self.tableView.header.textColor = [UIColor grayColor];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
    
    // 此时self.tableView.header == self.tableView.legendHeader
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)initChannelInfo{
    if (appDelegate.userInfo.cookies == nil) {
        [networkManager setChannel:1 withURLWithString:@"http://douban.fm/j/explore/get_recommend_chl"];
    }
    else{
        [networkManager setChannel:1 withURLWithString:[NSString stringWithFormat:@"http://douban.fm/j/explore/get_login_chls?uk=%@",appDelegate.userInfo.userID]];
    }
    [networkManager setChannel:2 withURLWithString:@"http://douban.fm/j/explore/up_trending_channels"];
    [networkManager setChannel:3 withURLWithString:@"http://douban.fm/j/explore/hot_channels"];
    //MJRefresh停止刷新
    [self.tableView.header endRefreshing];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [[ChannelInfo channelsTitleArray] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[ChannelInfo channels] objectAtIndex:section]count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[ChannelInfo channelsTitleArray] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"theReuseIdentifier";
    ChannelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[[[ChannelInfo channels] objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ChannelInfo updateCurrentCannel:[[[ChannelInfo channels] objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    [networkManager loadPlaylistwithType:@"n"];
    [self.delegate menuButtonClicked:0];
}

- (void)reloadTableviewData{
    [self.tableView reloadData];
}
@end
