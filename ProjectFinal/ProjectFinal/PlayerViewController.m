//
//  PlayerViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//
#import "PlayerViewController.h"
#import <UIKit+AFNetworking.h>
@interface PlayerViewController (){
    AppDelegate *appDelegate;
    AFHTTPRequestOperationManager *manager;
    NetworkManager *networkManager;
    PlayerController *playerController;
    
    BOOL isPlaying;
    NSTimer *timer;
    int currentTimeMinutes;
    int currentTimeSeconds;
    NSMutableString *currentTimeString;
    int TotalTimeMinutes;
    int TotalTimeSeconds;
    NSMutableString *totalTimeString;
    NSMutableString *timerLabelString;
}
@end

@implementation PlayerViewController
#pragma mark - System
- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [AFHTTPRequestOperationManager manager];
    appDelegate = [[UIApplication sharedApplication]delegate];
    
    networkManager = [[NetworkManager alloc]init];
    isPlaying = YES;
    [self loadPlaylist];
    self.picture.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseButton:)];
    [singleTap setNumberOfTapsRequired:1];
    [self.picture addGestureRecognizer:singleTap];
    playerController = [[PlayerController alloc]init];
    playerController.songInfoDelegate = self;
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress) userInfo:nil repeats:YES];
}

-(void)viewDidAppear:(BOOL)animated{
}

-(void)viewWillAppear:(BOOL)animated{
    [self initSongInfomation];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Buttons
- (IBAction)pauseButton:(UIButton *)sender {
    if (isPlaying) {
        isPlaying = NO;
        self.picture.alpha = 0.2f;
        self.pictureBlock.image = [UIImage imageNamed:@"albumBlock2"];
        [playerController pauseSong];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    }
    else{
        isPlaying = YES;
        self.picture.alpha = 1.0f;
        self.pictureBlock.image = [UIImage imageNamed:@"albumBlock"];
        [playerController restartSong];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (IBAction)skipButton:(UIButton *)sender{
    if(isPlaying == NO){
        isPlaying = YES;
        self.picture.alpha = 1.0f;
        self.pictureBlock.image = [UIImage imageNamed:@"albumBlock"];
        [playerController restartSong];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    [playerController skipSong];
}

- (IBAction)likeButton:(UIButton *)sender {
    if (![appDelegate.currentSong.like intValue]) {
        appDelegate.currentSong.like = @"1";
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
        [playerController likeSong];
    }
    else{
        appDelegate.currentSong.like = @"0";
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
}

- (IBAction)deleteButton:(UIButton *)sender {
    if(isPlaying == NO){
        isPlaying = YES;
        self.picture.alpha = 1.0f;
        self.pictureBlock.image = [UIImage imageNamed:@"albumBlock"];
        [playerController restartSong];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    [playerController deleteSong];
}
#pragma mark - SongInfomation
-(void)loadPlaylist{
    [networkManager loadPlaylistwithType:@"n"];
}

-(void)initSongInfomation{
    if (![self isFirstResponder]) {
        //远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }
    [self.picture setImageWithURL:[NSURL URLWithString:appDelegate.currentSong.picture]];
    self.songArtist.text = appDelegate.currentSong.artist;
    self.songTitle.text = appDelegate.currentSong.title;
    self.ChannelTitle.text = [NSString stringWithFormat:@"♪%@♪",appDelegate.currentChannel.name];
    
    //初始化timeLabel的总时间
    TotalTimeSeconds = [appDelegate.currentSong.length intValue]%60;
    TotalTimeMinutes = [appDelegate.currentSong.length intValue]/60;
    if (TotalTimeSeconds < 10) {
        totalTimeString = [NSMutableString stringWithFormat:@"%d:0%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    else{
        totalTimeString = [NSMutableString stringWithFormat:@"%d:%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    
    //初始化likeButon的图像
    if (![appDelegate.currentSong.like intValue]) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    
    [self configPlayingInfo];
}
- (void)configPlayingInfo
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        if (appDelegate.currentSong.title != nil) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:appDelegate.currentSong.title
                     forKey:MPMediaItemPropertyTitle];
            [dict setObject:appDelegate.currentSong.artist
                     forKey:MPMediaItemPropertyArtist];
            UIImage *tempImage = _picture.image;
            if (tempImage != nil) {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:tempImage] forKey:MPMediaItemPropertyArtwork];
            }
            [dict
             setObject:[NSNumber numberWithFloat:[appDelegate.currentSong.length floatValue]]
                forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}

#pragma mark - RemoteControl
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:
                [self pauseButton:nil]; // 切换播放、暂停按钮
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self skipButton:nil]; // 播放下一曲按钮
                break;
            default:
                break;
        }
    }
}

-(void)updateProgress{
    currentTimeMinutes = (unsigned)appDelegate.player.currentPlaybackTime/60;
    currentTimeSeconds = (unsigned)appDelegate.player.currentPlaybackTime%60;
    if (currentTimeSeconds < 10) {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",currentTimeMinutes,currentTimeSeconds];
    }
    else{
        currentTimeString = [NSMutableString stringWithFormat:@"%d:%d",currentTimeMinutes,currentTimeSeconds];
    }
    timerLabelString = [NSMutableString stringWithFormat:@"%@/%@",currentTimeString,totalTimeString];
    self.timerLabel.text = timerLabelString;
    self.timerProgressBar.progress = appDelegate.player.currentPlaybackTime/[appDelegate.currentSong.length intValue];
}


@end

