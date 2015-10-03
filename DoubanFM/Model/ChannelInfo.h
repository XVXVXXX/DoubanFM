//
//  ChannelsInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, DFMChannelType) {
    DFMChannelTypeReccommend = 1,
    DFMChannelTypeUpTrending,
    DFMChannelTypeHot,
};

@interface ChannelInfo : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary;

+ (NSMutableArray *)channels;

+ (instancetype)currentChannel;
+ (void)updateCurrentCannel:(ChannelInfo *)channel;

+ (NSArray *)channelsTitleArray;
+ (void)updateChannelsTitleArray:(NSArray *)array;
@end
