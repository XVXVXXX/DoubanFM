//
//  PlayerController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "ProtocolClass.h"

@interface PlayerController : MPMoviePlayerController
@property id<DoubanDelegate> songInfoDelegate;

@property (nonatomic) DFMPlaylist *playList;

+ (instancetype)sharedInstance;

-(instancetype)init;
-(void)startPlay;

//播放操作
-(void)pauseSong;
-(void)restartSong;
-(void)likeSong;
-(void)dislikesong;
-(void)deleteSong;
-(void)skipSong;
@end
