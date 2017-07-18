//
// Created by fufeng on 2017/7/18.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFMSongInfo;

//获取播放列表信息
//type
//n : None. Used for get a song list only.
//e : Ended a song normally.
//u : Unlike a hearted song.
//r : Like a song.
//s : Skip a song.
//b : Trash a song.
//p : Use to get a song list when the song in playlist was all played.
//sid : the song's id
typedef NS_ENUM(NSUInteger, DFMPlayerListRequestType) {
	DFMPlayerListRequestTypeNormal = 'n',
	DFMPlayerListRequestTypeEnd = 'e',
	DFMPlayerListRequestTypeUnlike = 'u',
	DFMPlayerListRequestTypeLike = 'r',
	DFMPlayerListRequestTypeSkip = 's',
	DFMPlayerListRequestTypeTrash = 'b',
	DFMPlayerListRequestTypeAllPlayer = 'p'
};

@interface DFMPlayerDataService : NSObject

+ (void)loadPlayListWithType:(DFMPlayerListRequestType)type success:(void (^)(NSArray<DFMSongInfo *> *songList))success failure:(void (^)(NSError *error))failure;
@end