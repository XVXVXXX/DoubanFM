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
@property (nonatomic) MPMoviePlayerController *player;
@property (nonatomic) NSMutableArray *playList;
@property (nonatomic) ChannelInfo *currentChannel;
@property (nonatomic) UserInfo *userInfo;

@property (nonatomic) NSArray *channelsTitle;
@property (nonatomic) NSMutableArray *channels;

@end

