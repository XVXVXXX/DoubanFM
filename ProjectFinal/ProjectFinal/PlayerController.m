//
//  PlayerController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "PlayerController.h"
@interface PlayerController(){
    AppDelegate* appDelegate;
    NetworkManager *networkManager;
}
@end
@implementation PlayerController
-(instancetype)init{
    if (self = [super init]) {
        appDelegate = [[UIApplication sharedApplication]delegate];
        networkManager = [[NetworkManager alloc]init];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(startPlay)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:appDelegate.player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initSongInfomation)
                                                 name: MPMoviePlayerLoadStateDidChangeNotification
                                               object:appDelegate.player];

    
    return self;
}

-(void)initSongInfomation{
    [self.songInfoDelegate initSongInfomation];
}

-(void)startPlay{
    @try {
        if (appDelegate.currentSongIndex >= ((int)[appDelegate.playList count]-1)) {
            [networkManager loadPlaylistwithType:@"p"];
        }
        else{
            ++appDelegate.currentSongIndex;
            appDelegate.currentSong = [appDelegate.playList objectAtIndex:appDelegate.currentSongIndex];
            [appDelegate.player setContentURL:[NSURL URLWithString:[appDelegate.currentSong valueForKey:@"url"]]];
            [appDelegate.player play];
        }
    }
    @catch (NSException *exception) {
    }
}


#pragma mark - PlayerButtonTask
//点击下一曲事件，按照豆瓣算法，需要重新载入播放列表
-(void)pauseSong{
    [appDelegate.player pause];
}
-(void)restartSong{
    [appDelegate.player play];
}
-(void)likeSong{
    [networkManager loadPlaylistwithType:@"r"];
}
-(void)dislikesong{
    [networkManager loadPlaylistwithType:@"u"];
}
-(void)deleteSong{
    [networkManager loadPlaylistwithType:@"b"];
}
-(void)skipSong{
    [networkManager loadPlaylistwithType:@"s"];
}


@end
