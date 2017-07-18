//
//  DFMPlayerViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit+AFNetworking.h>
#import <UIImageView+WebCache.h>
#import <Masonry/Masonry.h>

#import <AFNetworking/AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>

#import "DFMPlayerViewController.h"
#import "DFMPlayerController.h"
#import "DFMChannelInfoEntity.h"

#import "DFMNetworkManager.h"
#import "DFMChannelsController.h"
#import "DFMLoginViewController.h"
#import "AppDelegate.h"
#import "DFMSongInfo.h"
#import "DFMPlayerController.h"
#import "DFMProtocolClass.h"
#import "YYKitMacro.h"
#import "UIImage+YYAdd.h"
#import "DFMChannelDataCenter.h"

#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGB(r,g,b) RGBA(r,g,b,1)

#define kGoldColor RGB(219, 196, 175)

#define kBGColor RGB(239, 239, 244)

@interface DFMPlayerViewController ()<DoubanDelegate>

@property (assign, nonatomic) BOOL isPlaying;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSMutableString *totalTimeString;

@property (strong, nonatomic) UILabel *channelTitleLabel;

@property (strong, nonatomic) UIImageView *albumCoverImage;
@property (strong, nonatomic) UIImageView *albumCoverMaskImage;

@property (strong, nonatomic) UIProgressView *timerProgressBar;
@property (strong, nonatomic) UILabel *timeLabel;

@property (strong, nonatomic) UILabel *songTitleLabel;
@property (strong, nonatomic) UILabel *songArtistLabel;

@property (strong, nonatomic) UIButton *pauseButton;
@property (strong, nonatomic) UIButton *likeButton;
@property (strong, nonatomic) UIButton *deleteButton;
@property (strong, nonatomic) UIButton *skipButton;

@end

@implementation DFMPlayerViewController

#pragma mark - View LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];

	//UI
    self.view.backgroundColor = kBGColor;
	[self addSubViews];
	[self configConstrains];

	[self loadPlaylist];

	[DFMPlayerController sharedController].songInfoDelegate = self;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.02
                                             target:self
                                           selector:@selector(updateProgress)
                                           userInfo:nil
                                            repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.albumCoverImage.layer.cornerRadius = self.albumCoverImage.bounds.size.width/2;
    self.albumCoverImage.layer.masksToBounds = YES;

    [super viewDidAppear:animated];
	[self initSongInformation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Buttons
- (void)pauseButtonDidTapped:(UIButton *)sender {
    if (_isPlaying) {
        _isPlaying = NO;
        self.albumCoverImage.alpha = 0.2f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock2"];
	    [[DFMPlayerController sharedController] pause];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    else{
        _isPlaying = YES;
        self.albumCoverImage.alpha = 1.0f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock"];
	    [[DFMPlayerController sharedController] restart];
        [_timer setFireDate:[NSDate date]];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
}

- (void)skipButtonDidTapped:(UIButton *)sender{
    [_timer setFireDate:[NSDate distantFuture]];
	[[DFMPlayerController sharedController] pause];
    if(_isPlaying == NO){
        self.albumCoverImage.alpha = 1.0f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock"];
    }
	[[DFMPlayerController sharedController] skip];
}

- (void)likeButtonDidTapped:(UIButton *)sender {
    if (![[DFMPlayerController sharedController].currentSong.like intValue]) {
	    [DFMPlayerController sharedController].currentSong.like = @"1";
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
	    [[DFMPlayerController sharedController] like];
    }
    else{
	    [DFMPlayerController sharedController].currentSong.like = @"0";
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
	    [[DFMPlayerController sharedController] dislike];
    }
}

- (void)deleteButtonDidTapped:(UIButton *)sender {
    if (!_isPlaying) {
        _isPlaying = YES;
        self.albumCoverImage.alpha = 1.0f;
        self.albumCoverMaskImage.image = [UIImage imageNamed:@"albumBlock"];
	    [[DFMPlayerController sharedController] restart];
        [self.pauseButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    }
    [[DFMPlayerController sharedController] deleteSong];
}

#pragma mark - SongInfomation
-(void)loadPlaylist{
//	[[DFMNetworkManager sharedInstancd] loadPlayListWithType:@"n"];
	[[DFMPlayerController sharedController] requestPlayListWithType:DFMPlayerListRequestTypeNormal];
}

-(void)initSongInformation{
    _isPlaying = YES;
    if (![self isFirstResponder]) {
        //远程控制
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
        [self becomeFirstResponder];
    }

	@weakify(self)
	[self.albumCoverImage sd_setImageWithURL:[NSURL URLWithString:[DFMPlayerController sharedController].currentSong.picture]
	                        placeholderImage:nil
	                                 options:SDWebImageAvoidAutoSetImage
	                               completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
		                               @strongify(self)
		                               self.albumCoverImage.image = nil;
		                               self.albumCoverImage.image = image;
	                               }];

    self.songArtistLabel.text = [DFMPlayerController sharedController].currentSong.artist;
    self.songTitleLabel.text = [DFMPlayerController sharedController].currentSong.title;
    self.channelTitleLabel.text = [NSString stringWithFormat:@"♪%@♪",[DFMChannelDataCenter sharedCenter].currentChannel.name];
    
    //初始化timeLabel的总时间
    int TotalTimeSeconds = [[DFMPlayerController sharedController].currentSong.length intValue]%60;
    int TotalTimeMinutes = [[DFMPlayerController sharedController].currentSong.length intValue]/60;
    if (TotalTimeSeconds < 10) {
        _totalTimeString = [NSMutableString stringWithFormat:@"%d:0%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    else{
        _totalTimeString = [NSMutableString stringWithFormat:@"%d:%d",TotalTimeMinutes,TotalTimeSeconds];
    }
    
    //初始化likeButon的图像
    if (![[DFMPlayerController sharedController].currentSong.like intValue]) {
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
    }
    else{
        [self.likeButton setBackgroundImage:[UIImage imageNamed:@"heart2"] forState:UIControlStateNormal];
    }
    [_timer setFireDate:[NSDate date]];
    [self configPlayingInfo];
}

- (void)configPlayingInfo
{
    if (NSClassFromString(@"MPNowPlayingInfoCenter")) {
        if ([DFMPlayerController sharedController].currentSong.title != nil) {
            NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[DFMPlayerController sharedController].currentSong.title
                     forKey:MPMediaItemPropertyTitle];
            [dict setObject:[DFMPlayerController sharedController].currentSong.artist
                     forKey:MPMediaItemPropertyArtist];
            UIImage *tempImage = _albumCoverImage.image;
            if (tempImage != nil) {
                [dict setObject:[[MPMediaItemArtwork alloc]initWithImage:tempImage] forKey:MPMediaItemPropertyArtwork];
            }
            [dict
             setObject:[NSNumber numberWithFloat:[[DFMPlayerController sharedController].currentSong.length floatValue]]
             forKey:MPMediaItemPropertyPlaybackDuration];
            [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
        }
    }
}

- (void)addSubViews
{
    NSArray *subView = @[self.channelTitleLabel,
                         self.albumCoverImage,
                         self.albumCoverMaskImage,
                         self.timerProgressBar,
                         self.timeLabel,
                         self.songTitleLabel,
                         self.songArtistLabel,
                         self.pauseButton,
                         self.likeButton,
                         self.deleteButton,
                         self.skipButton];
    [subView enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [self.view addSubview:view];
    }];
}


- (void)configConstrains
{
    UIView *superView = self.view;
    [self.channelTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
	    make.centerX.equalTo(superView);
    }];
    
    UIView __block *lastView = nil;
    [@[self.channelTitleLabel,
       self.albumCoverImage,
       self.timerProgressBar,] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.top.equalTo(lastView ? lastView.mas_bottom : superView.mas_top).offset(30);
           }];
           lastView = view;
       }];
    
    lastView = nil;
    [@[self.pauseButton,
       self.likeButton,
       self.deleteButton,
       self.skipButton,] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
           [view mas_makeConstraints:^(MASConstraintMaker *make) {
               make.bottom.equalTo(superView.mas_bottom).offset(-15);
               make.height.equalTo(view.mas_width);
               make.left.equalTo(lastView ? lastView.mas_right : superView.mas_left).offset(30);
           }];
           lastView = view;
       }];
    
    [self.skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView.mas_right).offset(-30);
        make.size.equalTo(@[self.pauseButton, self.likeButton, self.deleteButton]);
    }];
    
    lastView = nil;
    [@[self.songArtistLabel,self.songTitleLabel, self.timeLabel, self.timerProgressBar] enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(superView).offset(15);
            make.right.equalTo(superView).offset(-15);
            make.bottom.equalTo(lastView ? lastView.mas_top : self.pauseButton.mas_top).offset(-15);
        }];
        lastView = view;
    }];
    
    [self.songArtistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@[self.songTitleLabel, self.timeLabel]);
    }];
    
    [self.albumCoverImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(superView);
        make.left.equalTo(superView).offset(20);
        make.right.equalTo(superView).offset(-20);
        make.width.equalTo(self.albumCoverImage.mas_height);
    }];
    
    [self.albumCoverMaskImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.left.top.equalTo(self.albumCoverImage);
    }];
}

#pragma mark - Getters
- (UILabel *)channelTitleLabel
{
    if (!_channelTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.font = [UIFont systemFontOfSize:27.f];
	    label.adjustsFontSizeToFitWidth = YES;
        label.textColor = kGoldColor;
	    label.backgroundColor = kBGColor;
	    label.clipsToBounds = YES;
        _channelTitleLabel = label;
    }
    return _channelTitleLabel;
}

- (UIImageView *)albumCoverImage
{
    if (!_albumCoverImage) {
        UIImageView *imageView = [[UIImageView alloc]init];
	    imageView.backgroundColor = kBGColor;
        _albumCoverImage = imageView;
    }
    return _albumCoverImage;
}

- (UIImageView *)albumCoverMaskImage
{
    if (!_albumCoverMaskImage) {
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.image = [UIImage imageNamed:@"albumBlock"];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pauseButtonDidTapped:)];
        [singleTap setNumberOfTapsRequired:1];
        [imageView addGestureRecognizer:singleTap];
        
        _albumCoverMaskImage = imageView;
    }
    return _albumCoverMaskImage;
}

- (UIProgressView *)timerProgressBar
{
    if (!_timerProgressBar) {
        _timerProgressBar = [UIProgressView new];
	    _timerProgressBar.backgroundColor = kBGColor;
        _timerProgressBar.progressTintColor = kGoldColor;
    }
    return _timerProgressBar;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
	    label.backgroundColor = kBGColor;
        _timeLabel = label;
    }
    return _timeLabel;
}

- (UILabel *)songTitleLabel
{
    if (!_songTitleLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:22.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
	    label.backgroundColor = kBGColor;
	    label.clipsToBounds = YES;
        _songTitleLabel = label;
    }
    return _songTitleLabel;
}

- (UILabel *)songArtistLabel
{
    if (!_songArtistLabel) {
        UILabel* label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:17.0f];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = kGoldColor;
	    label.backgroundColor = kBGColor;
	    label.clipsToBounds = YES;
        _songArtistLabel = label;
    }
    return _songArtistLabel;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(pauseButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
	        button.backgroundColor = kBGColor;
            button;
        });
    }
    return _pauseButton;
}

- (UIButton *)likeButton
{
    if (!_likeButton) {
        _likeButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(likeButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"heart1"] forState:UIControlStateNormal];
	        button.backgroundColor = kBGColor;
            button;
        });
    }
    return _likeButton;
}

- (UIButton *)deleteButton
{
    if (!_deleteButton) {
        _deleteButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(deleteButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
	        button.backgroundColor = kBGColor;
            button;
        });
    }
    return _deleteButton;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = ({
            UIButton *button = [[UIButton alloc]init];
            [button addTarget:self action:@selector(skipButtonDidTapped:) forControlEvents:UIControlEventTouchUpInside];
            [button setBackgroundImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
	        button.backgroundColor = kBGColor;
            button;
        });
    }
    return _skipButton;
}

#pragma mark - RemoteControl
- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlPlay:
                [self pauseButtonDidTapped:nil]; // 切换播放、暂停按钮
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self skipButtonDidTapped:nil]; // 播放下一曲按钮
                break;
            default:
                break;
        }
    }
}

-(void)updateProgress{
    int currentTimeMinutes = (unsigned) [DFMPlayerController sharedController].currentPlaybackTime/60;
    int currentTimeSeconds = (unsigned) [DFMPlayerController sharedController].currentPlaybackTime%60;
    NSMutableString *currentTimeString;
    //专辑图片旋转
    self.albumCoverImage.transform = CGAffineTransformRotate(self.albumCoverImage.transform, (CGFloat)(M_PI / 1440));
    if (currentTimeSeconds < 10) {
        currentTimeString = [NSMutableString stringWithFormat:@"%d:0%d",currentTimeMinutes,currentTimeSeconds];
    }
    else{
        currentTimeString = [NSMutableString stringWithFormat:@"%d:%d",currentTimeMinutes,currentTimeSeconds];
    }
    
    NSMutableString *timeLabelString = [NSMutableString stringWithFormat:@"%@/%@",currentTimeString,_totalTimeString];
    self.timeLabel.text = timeLabelString;
    self.timerProgressBar.progress = (float) [DFMPlayerController sharedController].currentPlaybackTime/[[DFMPlayerController sharedController].currentSong.length intValue];
}
@end

