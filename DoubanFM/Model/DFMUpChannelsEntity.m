//
//  DFMUpChannelsEntity.m
//  DoubanFM
//
//  Created by xvxvxxx on 10/3/15.
//  Copyright © 2015 XVX. All rights reserved.
//

#import "DFMUpChannelsEntity.h"
#import "ChannelInfo.h"

@implementation DFMUpChannelsEntity

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"channels" : NSStringFromClass([ChannelInfo class]),
             };
}

@end
