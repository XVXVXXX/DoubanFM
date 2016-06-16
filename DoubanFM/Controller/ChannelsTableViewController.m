//
//  ChannelsTableViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/21/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "ChannelsTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "YYKit.h"
@interface ChannelsTableViewController (){
    AppDelegate *appDelegate;
    NetworkManager *networkManager;
}

@property (nonatomic) NSMutableArray<NSMutableArray *> *channelsList;
@property (nonatomic) NSArray *channelsTitle;
@property (nonatomic) NSArray *myChannels;
@property (nonatomic) NSMutableArray *recommendChannels;
@property (nonatomic) NSMutableArray *upTrendingChannels;
@property (nonatomic) NSMutableArray *hotChannels;

@end

@implementation ChannelsTableViewController

#pragma mark - Life Cycle
- (instancetype)init {
    if (self = [super init]) {
        
        //我的兆赫
        ChannelInfo *myPrivateChannel = [[ChannelInfo alloc]init];
        myPrivateChannel.name = @"我的私人";
        myPrivateChannel.id = @"0";
        ChannelInfo *myRedheartChannel = [[ChannelInfo alloc]init];
        myRedheartChannel.name = @"我的红心";
        myRedheartChannel.id = @"-3";
        _myChannels = @[myPrivateChannel, myRedheartChannel];
        
        _recommendChannels = [NSMutableArray array];
        _upTrendingChannels = [NSMutableArray array];
        _hotChannels = [NSMutableArray array];
        
        _channelsList = [NSMutableArray arrayWithObjects:_myChannels, _recommendChannels, _upTrendingChannels, _hotChannels, nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _configTableView];

    //初始化工具类
    appDelegate = [[UIApplication sharedApplication]delegate];
    networkManager = [[NetworkManager alloc]init];
    networkManager.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 马上进入刷新状态
    [self.tableView.header beginRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Private
- (void)_configTableView {
    self.tableView.sectionHeaderHeight = 80;
    self.tableView.rowHeight = 60;
    
    //用MJRefresh做下来刷新
    [self.tableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(_loadData)];
    [self.tableView.header setTitle:@"往下拉可刷新哦" forState:MJRefreshHeaderStateIdle];
    [self.tableView.header setTitle:@"松开来就刷新啦" forState:MJRefreshHeaderStatePulling];
    [self.tableView.header setTitle:@"~~刷~~新~~中~~" forState:MJRefreshHeaderStateRefreshing];
    
    self.tableView.header.font = [UIFont systemFontOfSize:15];
    self.tableView.header.textColor = [UIColor grayColor];
    
    UINib *cell = [UINib nibWithNibName:@"ChannelsTableViewCell" bundle:nil];
    [self.tableView registerNib:cell forCellReuseIdentifier:@"theReuseIdentifier"];
}

-(void)_loadData{
    //recommend channel
    if (appDelegate.userInfo.cookies == nil) {
        [[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/get_recommend_chl"
                                          parameters:nil
                                             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                                 ChannelInfo *channel = [ChannelInfo modelWithJSON:[responseObject valueForKeyPath:@"data.res"]];
                                                 if (channel) {
                                                     [_recommendChannels removeAllObjects];
                                                     [_recommendChannels addObject:channel];
                                                 }
                                                 [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
                                                 [self.tableView.header endRefreshing];
                                             } failure:nil];
    }
    else{
        [[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/get_login_chls"
                                          parameters:@{@"uk":appDelegate.userInfo.userID}
                                             success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                                 NSArray *channels = [NSArray modelArrayWithClass:[ChannelInfo class] json:[responseObject valueForKeyPath:@"data.res.rec_chls"]];
                                                 if (channels.count) {
                                                     [_recommendChannels removeAllObjects];
                                                     [_recommendChannels addObject:channels];
                                                 }
                                                 [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationFade];
                                                 [self.tableView.header endRefreshing];
                                             } failure:nil];
        
    }
    
    //up
    [[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/up_trending_channels"
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                             NSArray *channels = [NSArray modelArrayWithClass:[ChannelInfo class] json:[responseObject valueForKeyPath:@"data.channels"]];
                                             if (channels.count) {
                                                 [_upTrendingChannels removeAllObjects];
                                                 [_upTrendingChannels addObjectsFromArray:channels];
                                             }
                                             [self.tableView reloadSection:2 withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView.header endRefreshing];
                                         } failure:nil];
    
    //hot
    [[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/hot_channels"
                                      parameters:nil
                                         success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                             NSArray *channels = [NSArray modelArrayWithClass:[ChannelInfo class] json:[responseObject valueForKeyPath:@"data.channels"]];
                                             if (channels.count) {
                                                 [_hotChannels removeAllObjects];
                                                 [_hotChannels addObjectsFromArray:channels];
                                             }
                                             [self.tableView reloadSection:3 withRowAnimation:UITableViewRowAnimationFade];
                                             [self.tableView.header endRefreshing];
                                         } failure:nil];
}

#pragma mark - <UITableViewDataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.channelsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.channelsList objectAtIndex:section]count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [@[@"我的兆赫",@"推荐频道",@"上升最快兆赫",@"热门兆赫"] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"theReuseIdentifier";
    ChannelsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = [[[self.channelsList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [ChannelInfo updateCurrentCannel:[[self.channelsList objectAtIndex:indexPath.section]objectAtIndex:indexPath.row]];
    [networkManager loadPlaylistwithType:@"n"];
    [self.delegate menuButtonClicked:0];
}

- (void)reloadTableviewData{
    [self.tableView reloadData];
}
@end
