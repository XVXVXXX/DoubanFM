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
#import "DFMUserManager.h"
#import "DFMPlayerDataService.h"

@protocol DFMPlayerControllerDelegate <NSObject>
/**
 *  初始化歌曲delegate
 */
-(void)initSongInformation;
@end

@interface DFMPlayerController : MPMoviePlayerController

@property id<DFMPlayerControllerDelegate> songInfoDelegate;

@property (nonatomic, strong, readonly) DFMSongInfo *currentSong;

+ (instancetype)sharedController;

- (void)setupAVSessions;

- (void)requestPlayListWithType:(DFMPlayerListRequestType)type;

/**
 * 重新刷新播放器的播放列表
 * @param songList
 */
- (void)reloadPlayList:(NSArray<DFMSongInfo *> *)songList shouldPlayNextSong:(BOOL)shouldPlay;


//播放操作

-(void)start;
-(void)restart;
-(void)like;
-(void)dislike;
-(void)deleteSong;
-(void)skip;
@end
