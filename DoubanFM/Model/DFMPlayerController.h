//
//  DFMPlayerController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "DFMNetworkManager.h"
#import "DFMProtocolClass.h"

@interface DFMPlayerController : MPMoviePlayerController
@property id<DoubanDelegate> songInfoDelegate;

@property (nonatomic) DFMPlayListEntity *playList;
@property (nonatomic, strong)DFMSongInfo *currentSong;
@property (nonatomic, assign) NSInteger currentSongIndex;

+ (instancetype)sharedController;

-(instancetype)init;
-(void)start;

//播放操作
-(void)pauseSong;
-(void)restart;
-(void)like;
-(void)dislike;
-(void)deleteSong;
-(void)skip;
@end
