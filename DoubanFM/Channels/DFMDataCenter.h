//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMChannelInfo.h"

typedef NS_ENUM(NSUInteger, DFMChannelType) {
	DFMChannelTypeMy = 0,
	DFMChannelTypeRecommend = 1,
	DFMChannelTypeUpTrending = 2,
	DFMChannelTypeHot = 3,
	DFMChannelTypeCount = 4, //用来标记Type的数量
};

@interface DFMDataCenter : NSObject

@property(nonatomic, strong, readonly) NSMutableArray<NSArray<DFMChannelInfo *> *> *allChannelList;
@property(nonatomic, strong, readonly) NSArray<NSString *> *channelTitleList;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfo *> *myChannels;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfo *> *recommendChannels;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfo *> *upTrendingChannels;
@property(nonatomic, strong, readonly) NSArray<DFMChannelInfo *> *hotChannels;


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

- (void)updateChannels:(NSArray<DFMChannelInfo *> *)array type:(enum DFMChannelType)type;
@end