//
//  DFMPlayerController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMPlayerController.h"
#import "DFMSongInfo.h"
#import "BlocksKit+UIKit.h"
#import "NSArray+YYAdd.h"
#import "DFMChannelDataCenter.h"

@interface DFMPlayerController ()
@property(nonatomic, strong) NSArray<DFMSongInfo *> *songList;
@property(nonatomic, strong) DFMSongInfo *currentSong;
@end

@implementation DFMPlayerController

+ (instancetype)sharedController {
	static DFMPlayerController *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:sharedInstance
		                                         selector:@selector(start)
		                                             name:MPMoviePlayerPlaybackDidFinishNotification
		                                           object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:sharedInstance
		                                         selector:@selector(initSongInformation)
		                                             name:MPMoviePlayerLoadStateDidChangeNotification
		                                           object:nil];
	});
	return sharedInstance;
}

- (void)initSongInformation {
	[self.songInfoDelegate initSongInformation];
}

- (void)start {
	NSInteger currentIndex = [self.songList indexOfObject:self.currentSong];
	DFMSongInfo *nextSong = [self.songList objectOrNilAtIndex:++currentIndex];
	if (nextSong) {
		self.contentURL = [NSURL URLWithString:self.currentSong.url];
		[self play];
		self.currentSong = nextSong;
	} else {
		//播放完了整个列表
		[self requestPlayListWithType:DFMPlayerListRequestTypeAllPlayer];
	}
}

#pragma mark - PlayerButtonTask

//点击下一曲事件，按照豆瓣算法，需要重新载入播放列表
- (void)restart {
	[self play];
}

- (void)like {
	[self requestPlayListWithType:DFMPlayerListRequestTypeLike];
}

- (void)dislike {
	[self requestPlayListWithType:DFMPlayerListRequestTypeUnlike];
}

- (void)deleteSong {
	[self requestPlayListWithType:DFMPlayerListRequestTypeTrash];
}

- (void)skip {
	[self requestPlayListWithType:DFMPlayerListRequestTypeSkip];
}

- (void)requestPlayListWithType:(DFMPlayerListRequestType)type {
	BOOL shouldNotPlayNext = (type == DFMPlayerListRequestTypeLike || type == DFMPlayerListRequestTypeUnlike);

	[DFMPlayerDataService loadPlayListWithType:type
	                                   success:^(NSArray<DFMSongInfo *> *songList) {
		                                   [self reloadPlayList:songList shouldPlayNextSong:!shouldNotPlayNext];
	                                   }
	                                   failure:^(NSError *error) {
		                                   [UIAlertView bk_alertViewWithTitle:error.localizedDescription];
	                                   }];
}

- (void)reloadPlayList:(NSArray<DFMSongInfo *> *)songList shouldPlayNextSong:(BOOL)shouldPlay{
	if (songList.count <= 0) {
		//红心频道
		if ([[DFMChannelDataCenter sharedCenter].currentChannel.id isEqualToString:@"-3"]) {
		    [UIAlertView bk_alertViewWithTitle:@"我的红心中还没有歌曲哦，赶快去加心吧"];
			[[DFMChannelDataCenter sharedCenter] resetChannel];
		}
		else {
			[UIAlertView bk_alertViewWithTitle:@"获取播放列表失败，请稍后重试"];
		}
		return;
	}

	//其他都是直接去播放下一曲
	if (shouldPlay) {
		self.songList = songList;
		DFMSongInfo *song = songList.firstObject;
		self.contentURL = [NSURL URLWithString:song.url];
		[self play];
		self.currentSong = song;
	}
	else {
		NSMutableArray *mList = [NSMutableArray arrayWithArray:songList];
		[mList insertObject:self.currentSong atIndex:0];
		self.songList = mList.copy;
	}
}

@end
