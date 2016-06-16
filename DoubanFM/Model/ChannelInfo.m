//
//  ChannelsInfo.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "ChannelInfo.h"
static ChannelInfo *currentChannel;
static NSArray *channelsTitleArray;

@implementation ChannelInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}

+ (NSMutableArray *)channels{
    static NSMutableArray *channels;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        channels = [NSMutableArray array];
    });
    return channels;
}

+ (instancetype)currentChannel{
    if (!currentChannel) {
        currentChannel = [[self alloc] init];
    }
    return currentChannel;
}

+ (void)updateCurrentCannel:(ChannelInfo *)channel{
    currentChannel = channel;
}


+ (NSDictionary *)replacedKeyFromPropertyName
{
    return @{@"ID" : @"id",
             };
}

@end
