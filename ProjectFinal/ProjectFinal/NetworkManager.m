//
//  NetworkManager.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "NetworkManager.h"
#import <AFNetworking/AFNetworking.h>
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
        [[appDelegate.channels objectAtIndex:channelIndex]removeAllObjects];
        NSDictionary *channelsDictionary = responseObject;
        NSDictionary *tempChannel = [channelsDictionary objectForKey:@"data"];
        if (channelIndex != 1) {
            for (NSDictionary *channels in [tempChannel objectForKey:@"channels"]) {
                ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDictionary:channels];
                [[appDelegate.channels objectAtIndex:channelIndex] addObject:channelInfo];
            }
        }
        else{
            NSDictionary *channels = [tempChannel objectForKey:@"res"];
            if ([[channels allKeys]containsObject:@"rec_chls"]) {
                for (NSDictionary *tempRecCannels in [channels objectForKey:@"rec_chls"]) {
                    ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDictionary:tempRecCannels];
                    [[appDelegate.channels objectAtIndex:channelIndex] addObject:channelInfo];
                }
            }
            else{
                NSDictionary *channels = [tempChannel objectForKey:@"res"];
                ChannelInfo *channelInfo = [[ChannelInfo alloc]initWithDictionary:channels];
                [[appDelegate.channels objectAtIndex:channelIndex] addObject:channelInfo];
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
    NSString *loginURL = @"http://douban.fm/j/login";
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager POST:loginURL parameters:loginParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *tempLoginInfoDictionary = responseObject;
        //r=0 登陆成功
        if ([(NSNumber *)[tempLoginInfoDictionary valueForKey:@"r"] intValue] == 0) {
            UserInfo *userInfo = [[UserInfo alloc]initWithDictionary:tempLoginInfoDictionary];
            appDelegate.userInfo = userInfo;
            [appDelegate.userInfo archiverUserInfo];
            NSLog(@"COOKIES:%@",appDelegate.userInfo.cookies);
            [self.delegate loginSuccess];
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
    NSString *logoutURL = @"http://douban.fm/partner/logout";
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:logoutURL parameters:logoutParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    NSString *playlistURL = [NSString stringWithFormat:@"http://douban.fm/j/mine/playlist?type=%@&sid=%@&pt=%f&channel=%@&from=mainsite",type,appDelegate.currentSong.sid,appDelegate.player.currentPlaybackTime,appDelegate.currentChannel.ID];
    [appDelegate.playList removeAllObjects];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:playlistURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
            appDelegate.currentSongIndex = -1;
        }
        else{
            if ([appDelegate.playList count] != 0) {
                appDelegate.currentSongIndex = 0;
                appDelegate.currentSong = [appDelegate.playList objectAtIndex:appDelegate.currentSongIndex];
                [appDelegate.player setContentURL:[NSURL URLWithString:appDelegate.currentSong.url]];
                [appDelegate.player play];
            }
            //如果是未登录用户第一次使用红心列表，会导致列表中无歌曲
            else{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"红心列表中没有歌曲，请您先登陆，或者添加红心歌曲" delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
                [alertView show];
                ChannelInfo *myPrivateChannel = [[ChannelInfo alloc]init];
                myPrivateChannel.name = @"我的私人";
                myPrivateChannel.ID = @"0";
                appDelegate.currentChannel = myPrivateChannel;
            }
        }
        [self.delegate reloadTableviewData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"HeyMan" message:@"登陆失败啦" delegate:self cancelButtonTitle:@"哦" otherButtonTitles: nil];
        [alertView show];
        NSLog(@"LOADPLAYLIST_ERROR:%@",error);
    }];
}



//验证码图片
-(void)loadCaptchaImage{
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *captchaIDURL = @"http://douban.fm/j/new_captcha";
    [manager GET:captchaIDURL parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableString *tempCaptchaID = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempCaptchaID length])];
        captchaID = tempCaptchaID;
        NSLog(@"CAPTCHAID:%@",captchaID);
        NSString *chatchaURL = [NSString stringWithFormat:@"http://douban.fm/misc/captcha?size=m&id=%@",tempCaptchaID];
        //加载验证码图片
        [self.delegate setCaptchaImageWithURLInString:chatchaURL];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}



@end
