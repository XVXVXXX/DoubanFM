//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import "DFMChannelDataCenter.h"
#import "NSObject+YYModel.h"
#import "DFMUser.h"

@interface DFMChannelDataCenter ()
@property(nonatomic, strong) NSMutableArray<NSArray<DFMChannelInfoEntity *> *> *allChannelList;
@property(nonatomic, strong) NSArray<NSString *> *channelTitleList;

@property(nonatomic, strong) NSArray<DFMChannelInfoEntity *> *myChannels;
@property(nonatomic, strong) NSArray<DFMChannelInfoEntity *> *recommendChannels;
@property(nonatomic, strong) NSArray<DFMChannelInfoEntity *> *upTrendingChannels;
@property(nonatomic, strong) NSArray<DFMChannelInfoEntity *> *hotChannels;

@end

@implementation DFMChannelDataCenter
- (instancetype)init {
	if (self = [super init]) {
		_allChannelList = [NSMutableArray array];
		for (int i = DFMChannelTypeMy; i < DFMChannelTypeCount; ++i) {
			[_allChannelList addObject:@[]];
		}

		_channelTitleList = @[@"我的兆赫", @"推荐频道", @"上升最快兆赫", @"热门兆赫"];
	}
	return self;
}

+ (instancetype)sharedCenter {
	static DFMChannelDataCenter *dataCenter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dataCenter = [[DFMChannelDataCenter alloc] init];
	});
	return dataCenter;
}

- (void)updateChannels:(NSArray<DFMChannelInfoEntity *> *)array type:(enum DFMChannelType)type {
	if (type >= DFMChannelTypeCount) {
		NSLog(@"%s-%d, DFMChannelType Error", __FILE__, __LINE__);
		return;
	}
	self.allChannelList[type] = array;
	switch (type) {
		case DFMChannelTypeMy:
			self.myChannels = array;
			break;
		case DFMChannelTypeRecommend:
			self.recommendChannels = array;
		case DFMChannelTypeUpTrending:
			self.upTrendingChannels = array;
			break;
		case DFMChannelTypeHot:
			self.hotChannels = array;
			break;
		default:
			nil;
	}
}

- (void)fetchAllChannels {
//	[self fetchLoginChannels];
	for (int i = DFMChannelTypeMy; i < DFMChannelTypeCount; ++i) {
		[self fetchChanelDataWithType:(DFMChannelType) i];
	}
}

- (void)fetchChanelDataWithType:(DFMChannelType)type {
	switch (type) {
		case DFMChannelTypeMy:
			[self fetchMyChannels];
			break;
		case DFMChannelTypeRecommend:
			[self fetchRecommendChannels];
		case DFMChannelTypeUpTrending:
			[self fetchUpTrendingChannels];
			break;
		case DFMChannelTypeHot:
			[self fetchHotChannelChannels];
			break;
		default:
			nil;
	}
}

- (void)fetchMyChannels {
	//我的兆赫，不需要去远端拉取 = =
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		DFMChannelInfoEntity *myPrivateChannel = [[DFMChannelInfoEntity alloc] init];
		myPrivateChannel.name = @"我的私人";
		myPrivateChannel.id = @"0";
		DFMChannelInfoEntity *myRedheartChannel = [[DFMChannelInfoEntity alloc] init];
		myRedheartChannel.name = @"我的红心";
		myRedheartChannel.id = @"-3";
		[DFMChannelDataCenter sharedCenter].myChannels = @[myPrivateChannel, myRedheartChannel];

		[[DFMChannelDataCenter sharedCenter] updateChannels:@[myPrivateChannel, myRedheartChannel] type:DFMChannelTypeMy];
	});
}

/**
 * 获取推荐频道数据
 */
- (void)fetchRecommendChannels {
	[[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/get_recommend_chl"
	                                  parameters:nil
	                                     success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
		                                     DFMChannelInfoEntity *channel = [DFMChannelInfoEntity modelWithJSON:[responseObject valueForKeyPath:@"data.res"]];
		                                     if (channel) {
			                                     [DFMChannelDataCenter sharedCenter].recommendChannels = @[channel];
			                                     [[DFMChannelDataCenter sharedCenter] updateChannels:@[channel] type:DFMChannelTypeRecommend];
		                                     }
	                                     }
	                                     failure:nil];
}

/**
 * 获取登录频道数据
 */
- (void)fetchLoginChannels {
	[[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/get_login_chls"
	                                  parameters:@{@"uk": [DFMUser currentUser].userInfo.userID}
	                                     success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
		                                     NSArray *channels = [NSArray modelArrayWithClass:[DFMChannelInfoEntity class] json:[responseObject valueForKeyPath:@"data.res.rec_chls"]];
		                                     if (channels.count) {
			                                     [DFMChannelDataCenter sharedCenter].recommendChannels = channels;
//			                                     [[DFMChannelDataCenter sharedCenter] updateChannels:channels type:];
		                                     }
	                                     }
	                                     failure:nil];
}

/**
 * 获取上升频道数据
 */
- (void)fetchUpTrendingChannels {
	[[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/up_trending_channels"
	                                  parameters:nil
	                                     success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
		                                     NSArray *channels = [NSArray modelArrayWithClass:[DFMChannelInfoEntity class] json:[responseObject valueForKeyPath:@"data.channels"]];
		                                     if (channels.count) {
			                                     [DFMChannelDataCenter sharedCenter].upTrendingChannels = channels;
			                                     [[DFMChannelDataCenter sharedCenter] updateChannels:channels type:DFMChannelTypeUpTrending];
		                                     }
	                                     }
	                                     failure:nil];
}

/**
 * 获取热门频道数据
 */
- (void)fetchHotChannelChannels {
	[[AFHTTPRequestOperationManager manager] GET:@"http://douban.fm/j/explore/hot_channels"
	                                  parameters:nil
	                                     success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
		                                     NSArray *channels = [NSArray modelArrayWithClass:[DFMChannelInfoEntity class] json:[responseObject valueForKeyPath:@"data.channels"]];
		                                     if (channels.count) {
			                                     [DFMChannelDataCenter sharedCenter].hotChannels = channels;
			                                     [[DFMChannelDataCenter sharedCenter] updateChannels:channels type:DFMChannelTypeHot];
		                                     }
	                                     }
	                                     failure:nil];
}


@end