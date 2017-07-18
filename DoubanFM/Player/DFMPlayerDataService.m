//
// Created by fufeng on 2017/7/18.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperation.h>
#import "DFMPlayerDataService.h"
#import "DFMPlayerController.h"
#import "DFMSongInfo.h"
#import "DFMChannelDataCenter.h"
#import "NSObject+YYModel.h"
#import "AFHTTPRequestOperationManager.h"
#import "BlocksKit+UIKit.h"
#import "DFMUser.h"

@interface DFMPlayerDataService ()
@property (nonatomic, strong) NSArray<DFMSongInfo *> *songList;
@end

@implementation DFMPlayerDataService

+ (void)loadPlayListWithType:(DFMPlayerListRequestType)type success:(void (^)(NSArray<DFMSongInfo *> *songList))success failure:(void (^)(NSError *error))failure {
	NSMutableString *mString = @"http://douban.fm/j/mine/playlist?from=mainsite".mutableCopy;
	[mString appendFormat:@"&type=%c", type];
	[mString appendFormat:@"&sid=%@", [DFMPlayerController sharedController].currentSong.sid];
	[mString appendFormat:@"&pt=%f", [DFMPlayerController sharedController].currentPlaybackTime];
	[mString appendFormat:@"&channel=%@", [DFMChannelDataCenter sharedCenter].currentChannel.id];

	[[AFHTTPRequestOperationManager manager] GET:mString
	                                  parameters:nil
	                                     success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {
		                                     NSArray<DFMSongInfo *> *songList = [NSArray modelArrayWithClass:[DFMSongInfo class] json:[responseObject valueForKey:@"song"]];
		                                     !success ?: success(songList);
	                                     }
	                                     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		                                     !failure ?: failure(error);
	                                     }];
}
@end