//
//  DFMPlaylist.m
//  DoubanFM
//
//  Created by xvxvxxx on 10/3/15.
//  Copyright © 2015 XVX. All rights reserved.
//

#import "DFMPlaylist.h"
#import "SongInfo.h"

@implementation DFMPlaylist

+ (NSDictionary *)objectClassInArray
{
    return @{
             @"song" : NSStringFromClass([SongInfo class]),
             };
}

@end
