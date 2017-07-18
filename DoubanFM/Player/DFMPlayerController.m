//
//  DFMPlayerController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMPlayerController.h"
#import "DFMSongInfo.h"
#import "DFMPlayerDataService.h"
#import "BlocksKit+UIKit.h"
#import "NSArray+YYAdd.h"

@interface DFMPlayerController ()
@property(nonatomic, strong) NSArray<DFMSongInfo *> *songList;
@property(nonatomic, strong) DFMSongInfo *currentSong;
@end

@implementation DFMPlayerController
- (instancetype)init {
	if (self = [super init]) {
		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(start)
		                                             name:MPMoviePlayerPlaybackDidFinishNotification
		                                           object:nil];

		[[NSNotificationCenter defaultCenter] addObserver:self
		                                         selector:@selector(initSongInformation)
		                                             name:MPMoviePlayerLoadStateDidChangeNotification
		                                           object:nil];
	}
	return self;
}

+ (instancetype)sharedController {
	static DFMPlayerController *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[self alloc] init];
	});
	return sharedInstance;
}

- (void)initSongInformation {
	[self.songInfoDelegate initSongInformation];
}

- (void)start {
	NSInteger currentIndex = [self.songList indexOfObject:self.currentSong];
	self.currentSong = [self.songList objectOrNilAtIndex:++currentIndex];
	if (self.currentSong) {
		[self setContentURL:[NSURL URLWithString:[[self currentSong] valueForKey:@"url"]]];
		[self play];
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
	[DFMPlayerDataService loadPlayListWithType:DFMPlayerListRequestTypeLike
	                                   success:^(NSArray<DFMSongInfo *> *songList) {
		                                   if (songList.count) {
			                                   NSMutableArray *mList = [NSMutableArray arrayWithArray:songList];
			                                   [mList insertObject:self.currentSong atIndex:0];
			                                   self.songList = mList.copy;
		                                   }
	                                   }
	                                   failure:^(NSError *error) {
		                                   [UIAlertView bk_alertViewWithTitle:error.localizedDescription];
	                                   }];
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
	if (type == DFMPlayerListRequestTypeLike) {
		NSLog(@"此处不接受Like操作 %s %d", __FILE__, __LINE__);
		return;
	}

	[DFMPlayerDataService loadPlayListWithType:type
	                                   success:^(NSArray<DFMSongInfo *> *songList) {
		                                   [self reloadPlayList:songList];
	                                   }
	                                   failure:^(NSError *error) {
		                                   [UIAlertView bk_alertViewWithTitle:error.localizedDescription];
	                                   }];
}

- (void)reloadPlayList:(NSArray<DFMSongInfo *> *)songList {
	if (songList.count <= 0) {
		[UIAlertView bk_alertViewWithTitle:@"获取播放列表失败，请稍后重试"];
		return;
	}

	self.songList = songList;

	//其他都是直接去播放下一曲
	DFMSongInfo *song = songList.firstObject;
	[DFMPlayerController sharedController].currentSong = song;
	[[DFMPlayerController sharedController] setContentURL:[NSURL URLWithString:song.url]];
	[[DFMPlayerController sharedController] play];
}

@end
