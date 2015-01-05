//
//  AppDelegate.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "ChannelInfo.h"
#import "SongInfo.h"
#import "UserInfo.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property MPMoviePlayerController *player;
@property NSMutableArray *playList;
@property SongInfo *currentSong;
@property int currentSongIndex;
@property ChannelInfo *currentChannel;
@property UserInfo *userInfo;

@property NSArray *channelsTitle;
@property NSMutableArray *channels;

@end

