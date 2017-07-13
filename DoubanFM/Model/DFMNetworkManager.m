//
//  DFMNetworkManager.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMNetworkManager.h"
#import "AppDelegate.h"
#import "DFMSongInfo.h"
#import "DFMChannelInfo.h"

#import "DFMPlayerController.h"

#import "DFMUpChannelsEntity.h"
#import "DFMHotChannelsEntity.h"
#import "DFMRecChannelsEntity.h"
#import "NSObject+YYModel.h"

#import <UIKit/UIKit.h>

#import <MJExtension.h>
#import <AFNetworking/AFNetworking.h>

#define PLAYLISTURLFORMATSTRING @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define LOGINURLSTRING @"http://douban.fm/j/login"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"

static NSMutableString *captchaID;

@interface DFMNetworkManager()
@property (nonatomic, strong) AppDelegate *appDelegate;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation DFMNetworkManager
-(instancetype)init{
    if (self = [super init]) {
        _appDelegate = [[UIApplication sharedApplication] delegate];

        _manager = [AFHTTPRequestOperationManager manager];
	    _manager.requestSerializer = [AFJSONRequestSerializer serializer];
	    _manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

+ (instancetype)sharedInstancd
{
    static DFMNetworkManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

//设置播放列表
//登陆数据格式
//POST Params:
//remember:on/off
//source:radio
//captcha_solution:cheese 验证码
//alias:xxxx%40gmail.com
//form_password:password
//captcha_id:jOtEZsPFiDVRR9ldW3ELsy57%3en
-(void)LoginwithUsername:(NSString *)username Password:(NSString *)password  Captcha:(NSString *)captcha RememberOnorOff:(NSString *)rememberOnorOff{
    NSDictionary *loginParameters = @{@"remember": rememberOnorOff,
                                      @"source": @"radio",
                                      @"captcha_solution": captcha,
                                      @"alias": username,
                                      @"form_password":password,
                                      @"captcha_id":captchaID};
    [_manager POST:LOGINURLSTRING parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempLoginInfoDictionary = responseObject;
        //r=0 登陆成功
        if ([(NSNumber *)[tempLoginInfoDictionary valueForKey:@"r"] intValue] == 0) {
            DFMUserInfo *userInfo = [[DFMUserInfo alloc]initWithDictionary:tempLoginInfoDictionary];
            _appDelegate.userInfo = userInfo;
            [_appDelegate.userInfo archiverUserInfo];
            NSLog(@"COOKIES:%@",_appDelegate.userInfo.cookies);
            [self.delegate loginSuccess];
        }
        else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:[tempLoginInfoDictionary valueForKey:@"err_msg"] delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
            [alertView show];
            [self loadCaptchaImage];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"LOGIN_ERROR:%@",error);
    }];
}


//source
//value radio
//ck
//the key ck in your cookie
//no_login
//value y #### Response none #### Example none
-(void)logout{
    NSDictionary *logoutParameters = @{@"source": @"radio",
                                      @"ck": _appDelegate.userInfo.cookies,
                                      @"no_login": @"y"};

    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_manager GET:LOGOUTURLSTRING parameters:logoutParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"LOGOUT_SUCCESSFUL");
        _appDelegate.userInfo = [[DFMUserInfo alloc]init];
        [_appDelegate.userInfo archiverUserInfo];
        [self.delegate logoutSuccess];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"LOGOUT_ERROR:%@",error);
    }];
}

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
-(void)loadPlayListWithType:(NSString *)type{

	NSMutableString *mString = @"http://douban.fm/j/mine/playlist?from=mainsite".mutableCopy;
	[mString appendFormat:@"&type=%@",type];
	[mString appendFormat:@"&sid=%@",[DFMPlayerController sharedController].currentSong.sid];
	[mString appendFormat:@"&pt=%f", [DFMPlayerController sharedController].currentPlaybackTime];
	[mString appendFormat:@"&channel=%@",[DFMChannelInfo currentChannel].id];

    [_manager GET:mString parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *responseObject) {

	    DFMPlayListEntity *playList = [DFMPlayListEntity modelWithJSON:responseObject];
	    //喜欢一首歌，要先把这首歌听完，然后才能去播放下个列表的音乐
        if ([type isEqualToString:@"r"]) {
	        [DFMPlayerController sharedController].currentSongIndex = -1;
        }
        else{
            if ([playList.song count] != 0) {
	            [DFMPlayerController sharedController].currentSongIndex = 0;
	            [DFMPlayerController sharedController].currentSong = playList.song.firstObject;
                [[DFMPlayerController sharedController] setContentURL:[NSURL URLWithString:[DFMPlayerController sharedController].currentSong.url]];
                [[DFMPlayerController sharedController] play];
            }
            //如果是未登录用户第一次使用红心列表，会导致列表中无歌曲
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"红心列表中没有歌曲，请您先登陆，或者添加红心歌曲" delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
                [alertView show];
                DFMChannelInfo *myPrivateChannel = [[DFMChannelInfo alloc]init];
                myPrivateChannel.name = @"我的私人";
                myPrivateChannel.id = @"0";
                [DFMChannelInfo updateCurrentCannel:myPrivateChannel];
            }
        }
        [self.delegate reloadTableviewData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //FIXME: 或许信息失败有点bug，先这样把 = =
        //        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"登陆失败啦" delegate:self cancelButtonTitle:@"哦,酱紫" otherButtonTitles: nil];
//        [alertView show];
//        NSLog(@"LOADPLAYLIST_ERROR:%@",error);
    }];
}

//验证码图片
-(void)loadCaptchaImage{
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [_manager GET:CAPTCHAIDURLSTRING parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *tempCaptchaID = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempCaptchaID length])];
        captchaID = tempCaptchaID;
        NSString *captchaImgURL = [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING,tempCaptchaID];
        //加载验证码图片
        [self.delegate setCaptchaImageWithURLInString:captchaImgURL];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

@end
