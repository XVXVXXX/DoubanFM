//
//  NetworkManager.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "AppDelegate.h"
#import "SongInfo.h"
@protocol NetworManagerDelegate <NSObject>
@optional
-(void)setCaptchaImageWithURLInString:(NSString *)url;
-(void)reloadTableviewData;
-(void)loginSuccess;
-(void)logoutSuccess;
@end

@interface NetworkManager : NSObject
@property id<NetworManagerDelegate>delegate;
@property NSMutableString *captchaID;

-(instancetype)init;
-(void)setChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString;
-(void)LoginwithUsername:(NSString *)username Password:(NSString *)password  Captcha:(NSString *)captcha RememberOnorOff:(NSString *)rememberOnorOff;
-(void)logout;
-(void)loadCaptchaImage;
-(void)loadPlaylistwithType:(NSString *)type;
@end
