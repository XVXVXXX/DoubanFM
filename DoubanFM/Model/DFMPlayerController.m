//
//  DFMPlayerController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMPlayerController.h"
#import "DFMSongInfo.h"
@interface DFMPlayerController(){
    AppDelegate* appDelegate;
    DFMNetworkManager *networkManager;
}
@end
@implementation DFMPlayerController
-(instancetype)init{
    if (self = [super init]) {
        appDelegate = [[UIApplication sharedApplication]delegate];
        networkManager = [[DFMNetworkManager alloc]init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(start)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSongInfomation)
                                                 name: MPMoviePlayerLoadStateDidChangeNotification
                                               object:nil];
    return self;
}

+ (instancetype)sharedController
{
    static DFMPlayerController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)initSongInfomation{
	[self.songInfoDelegate initSongInformation];
}

-(void)start{
    @try {
        if ([self currentSongIndex] >= ((int)[[DFMPlayerController sharedController].playList.song count]-1)) {
	        [networkManager loadPlayListWithType:@"p"];
        }
        else{
	        self.currentSongIndex++;
	        self.currentSong = [[DFMPlayerController sharedController].playList.song objectAtIndex:[self currentSongIndex]];

            [self setContentURL:[NSURL URLWithString:[[self currentSong] valueForKey:@"url"]]];
            [self play];
        }
    }
    @catch (NSException *exception) {
    }
}


#pragma mark - PlayerButtonTask
//点击下一曲事件，按照豆瓣算法，需要重新载入播放列表
-(void)pauseSong{
    [self pause];
}
-(void)restart{
    [self play];
}
-(void)like{
	[networkManager loadPlayListWithType:@"r"];
}
-(void)dislike{
	[networkManager loadPlayListWithType:@"u"];
}
-(void)deleteSong{
	[networkManager loadPlayListWithType:@"b"];
}
-(void)skip{
	[networkManager loadPlayListWithType:@"s"];
}


@end
