//
//  NetworkManager.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SongInfo.h"
#import "ChannelInfo.h"
#define PLAYLISTURLFORMATSTRING @"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite"
#define LOGINURLSTRING @"http://douban.fm/partner/logout"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"

static NSMutableString *captchaID;

@interface NetworkManager(){
    AppDelegate *appDelegate;
    AFHTTPRequestOperationManager *manager;
}
@end

@implementation NetworkManager
-(instancetype)init{
    if (self = [super init]) {
        appDelegate = [[UIApplication sharedApplication]delegate];
        manager = [AFHTTPRequestOperationManager manager];
    }
    return self;
}

//设置播放列表
-(void)setChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString{
    [manager GET:urlWithString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[[ChannelInfo channels] objectAtIndex:channelIndex]removeAllObjects];
        NSDictionary *channelsDictionary = responseObject;
        NSDictionary *tempChannel = [channelsDictionary objectForKey:@"data"];
        if (channelIndex != 1) {
            for (NSDictionary *channels in [tempChannel objectForKey:@"channels"]) {
                ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDictionary:channels];
                [[[ChannelInfo channels] objectAtIndex:channelIndex] addObject:channelInfo];
            }
        }
        else{
            NSDictionary *channels = [tempChannel objectForKey:@"res"];
            if ([[channels allKeys]containsObject:@"rec_chls"]) {
                for (NSDictionary *tempRecCannels in [channels objectForKey:@"rec_chls"]) {
                    ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDictionary:tempRecCannels];
                    [[[ChannelInfo channels] objectAtIndex:channelIndex] addObject:channelInfo];
                }
            }
            else{
                NSDictionary *channels = [tempChannel objectForKey:@"res"];
                ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDictionary:channels];
                [[[ChannelInfo channels] objectAtIndex:channelIndex] addObject:channelInfo];
            }
        }
        [self.delegate reloadTableviewData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];
}


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
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:LOGINURLSTRING parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempLoginInfoDictionary = responseObject;
        //r=0 登陆成功
        if ([(NSNumber *)[tempLoginInfoDictionary valueForKey:@"r"] intValue] == 0) {
            UserInfo *userInfo = [[UserInfo alloc]initWithDictionary:tempLoginInfoDictionary];
            appDelegate.userInfo = userInfo;
            [appDelegate.userInfo archiverUserInfo];
            NSLog(@"COOKIES:%@",appDelegate.userInfo.cookies);
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
                                      @"ck": appDelegate.userInfo.cookies,
                                      @"no_login": @"y"};
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:LOGOUTURLSTRING parameters:logoutParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"LOGOUT_SUCCESSFUL");
        appDelegate.userInfo = [[UserInfo alloc]init];
        [appDelegate.userInfo archiverUserInfo];
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
-(void)loadPlaylistwithType:(NSString *)type{
    NSString *playlistURLString = [NSString stringWithFormat:PLAYLISTURLFORMATSTRING, type, [SongInfo currentSong].sid, appDelegate.player.currentPlaybackTime, [ChannelInfo currentChannel].ID];
    [appDelegate.playList removeAllObjects];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:playlistURLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *songDictionary = responseObject;
        for (NSDictionary *song in [songDictionary objectForKey:@"song"]) {
            //subtype=T为广告标识位，如果是T，则不加入播放列表(去广告)
            if ([[song objectForKey:@"subtype"] isEqualToString:@"T"]) {
                continue;
            }
            SongInfo *tempSong = [[SongInfo alloc] initWithDictionary:song];
            [appDelegate.playList addObject:tempSong];
        }
        if ([type isEqualToString:@"r"]) {
            [SongInfo setCurrentSongIndex:-1];
        }
        else{
            if ([appDelegate.playList count] != 0) {
                [SongInfo setCurrentSongIndex:0];
                [SongInfo setCurrentSong:[appDelegate.playList objectAtIndex:[SongInfo currentSongIndex]]];
                [appDelegate.player setContentURL:[NSURL URLWithString:[SongInfo currentSong].url]];
                [appDelegate.player play];
            }
            //如果是未登录用户第一次使用红心列表，会导致列表中无歌曲
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"红心列表中没有歌曲，请您先登陆，或者添加红心歌曲" delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
                [alertView show];
                ChannelInfo *myPrivateChannel = [[ChannelInfo alloc]init];
                myPrivateChannel.name = @"我的私人";
                myPrivateChannel.ID = @"0";
                [ChannelInfo updateCurrentCannel:myPrivateChannel];
            }
        }
        [self.delegate reloadTableviewData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"登陆失败啦" delegate:self cancelButtonTitle:@"哦,酱紫" otherButtonTitles: nil];
        [alertView show];
        NSLog(@"LOADPLAYLIST_ERROR:%@",error);
    }];
}



//验证码图片
-(void)loadCaptchaImage{
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:CAPTCHAIDURLSTRING parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
