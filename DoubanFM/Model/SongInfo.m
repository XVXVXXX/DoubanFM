//
//  SongInfo.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "SongInfo.h"

static SongInfo *currentSong;
static int currentSongIndex;

@implementation SongInfo

+ (instancetype)currentSong{
    if (!currentSong) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            currentSong = [[SongInfo alloc] init];
        });
    }
    return currentSong;
}

+ (void)setCurrentSong:(SongInfo *)songInfo
{
    currentSong = songInfo;
}

+ (NSInteger)currentSongIndex{
    return currentSongIndex;
}

+ (void)setCurrentSongIndex:(int)songIndex{
    currentSongIndex = songIndex;
}
@end
