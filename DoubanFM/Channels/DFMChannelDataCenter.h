//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMChannelInfoEntity.h"

typedef NS_ENUM(NSUInteger, DFMChannelType) {
	DFMChannelTypeMy = 0,
	DFMChannelTypeRecommend = 1,
	DFMChannelTypeUpTrending = 2,
	DFMChannelTypeHot = 3,
	DFMChannelTypeCount, //用来标记Type的数量
};

@interface DFMChannelDataCenter : NSObject

@property(nonatomic, strong, readonly) NSMutableArray<NSArray<DFMChannelInfoEntity *> *> *allChannelList;
@property(nonatomic, strong, readonly) NSArray<NSString *> *channelTitleList;

@property(nonatomic, strong, readonly) NSArray<DFMChannelInfoEntity *> *myChannels;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfoEntity *> *recommendChannels;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfoEntity *> *upTrendingChannels;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfoEntity *> *hotChannels;

@property(nonatomic, strong) DFMChannelInfoEntity *currentChannel;

+ (instancetype)sharedCenter;

/**
 * 获取所有频道数据
 */
- (void)fetchAllChannels;

/**
 * 根据Type去拉取不同的频道信息
 * @param type DFMChannelType
 */
- (void)fetchChanelDataWithType:(DFMChannelType)type;

- (void)updateChannels:(NSArray<DFMChannelInfoEntity *> *)array type:(DFMChannelType)type;

/**
 * 重置频道，目前会重置到私人频道
 */
- (void)resetChannel;
@end