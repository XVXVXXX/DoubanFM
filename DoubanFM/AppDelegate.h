//
//  AppDelegate.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <MediaPlayer/MediaPlayer.h>

#import "UserInfo.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) MPMoviePlayerController *player;
@property (nonatomic) NSMutableArray *playList;
@property (nonatomic) UserInfo *userInfo;


@end

