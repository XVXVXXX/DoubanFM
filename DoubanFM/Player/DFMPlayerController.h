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
#import "DFMPlayerDataService.h"

@interface DFMPlayerController : MPMoviePlayerController
@property id<DoubanDelegate> songInfoDelegate;

@property (nonatomic, strong, readonly) NSArray<DFMSongInfo *> *songList;
@property (nonatomic, strong, readonly) DFMSongInfo *currentSong;

+ (instancetype)sharedController;
- (void)requestPlayListWithType:(DFMPlayerListRequestType)type;

-(void)start;

//播放操作

-(void)restart;
-(void)like;
-(void)dislike;
-(void)deleteSong;
-(void)skip;
@end
