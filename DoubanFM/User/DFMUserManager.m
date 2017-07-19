//
//  DFMUserManager.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMUserManager.h"
#import "AppDelegate.h"

#import "BlocksKit+UIKit.h"

#import <MJExtension.h>
#import <AFNetworking/AFNetworking.h>

#define LOGINURLSTRING @"http://douban.fm/j/login"
#define LOGOUTURLSTRING @"http://douban.fm/partner/logout"
#define CAPTCHAIDURLSTRING @"http://douban.fm/j/new_captcha"
#define CAPTCHAIMGURLFORMATSTRING @"http://douban.fm/misc/captcha?size=m&id=%@"

static NSString *captchaID;

@interface DFMUserManager ()
@property(nonatomic, strong) AppDelegate *appDelegate;
@property(nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end

@implementation DFMUserManager
- (instancetype)init {
	if (self = [super init]) {
		_appDelegate = [[UIApplication sharedApplication] delegate];

		_manager = [AFHTTPRequestOperationManager manager];
	}
	return self;
}

+ (instancetype)sharedInstance {
	static DFMUserManager *sharedManager = nil;
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
- (void)loginWithUserName:(NSString *)username password:(NSString *)password captcha:(NSString *)captcha rememberOnorOff:(NSString *)rememberOnorOff {

	UIAlertView *alertView1 = [UIAlertView bk_alertViewWithTitle:@"我抱歉的通知您，本应用在使用的登录接口已经被干掉了，目前无法登录"];
	[alertView1 show];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[alertView1 dismissWithClickedButtonIndex:-1 animated:YES];
	});
	return;

//	NSDictionary *loginParameters = @{@"remember": rememberOnorOff,
//		@"source": @"radio",
//		@"captcha_solution": captcha,
//		@"alias": username,
//		@"form_password": password,
//		@"captcha_id": captchaID};
//
//	[[AFHTTPRequestOperationManager manager] POST:LOGINURLSTRING
//	                                   parameters:loginParameters
//	                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		                                      NSDictionary *tempLoginInfoDictionary = [responseObject jsonValueDecoded];;
//		                                      //r=0 登陆成功
//        if ([(NSNumber *)[tempLoginInfoDictionary valueForKey:@"r"] intValue] == 0) {
//            DFMUserInfoEntity *userInfo = [[DFMUserInfoEntity alloc]initWithDictionary:tempLoginInfoDictionary];
//            _appDelegate.userInfo = userInfo;
//            [_appDelegate.userInfo archiverUserInfo];
//            NSLog(@"COOKIES:%@",_appDelegate.userInfo.cookies);
//            [self.delegate loginSuccess];
//        }
//        else{
//            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登陆失败" message:[tempLoginInfoDictionary valueForKey:@"err_msg"] delegate:self cancelButtonTitle:@"GET" otherButtonTitles: nil];
//            [alertView show];
//            [self loadCaptchaImage];
//        }
//	                                      }
//	                                      failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		                                      NSLog(@"LOGIN_ERROR:%@", error);
//	                                      }];
}


//source
//value radio
//ck
//the key ck in your cookie
//no_login
//value y #### Response none #### Example none
- (void)logout {
//	NSDictionary *logoutParameters = @{@"source": @"radio",
//		@"ck": _appDelegate.userInfo.cookies,
//		@"no_login": @"y"};
//
//	_manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//	[_manager GET:LOGOUTURLSTRING parameters:logoutParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
//		NSLog(@"LOGOUT_SUCCESSFUL");
//		_appDelegate.userInfo = [[DFMUserInfoEntity alloc] init];
//		[_appDelegate.userInfo archiverUserInfo];
//		[self.delegate logoutSuccess];
//	}     failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//		NSLog(@"LOGOUT_ERROR:%@", error);
//	}];
}

//验证码图片
- (void)getCaptchaImageInfoSuccess:(void (^)(NSString *captchaImage, NSString *captchaID))success failure:(void (^)(NSError *error))failure {
	[_manager GET:CAPTCHAIDURLSTRING
	   parameters:nil
	      success:^(AFHTTPRequestOperation *operation, id responseObject) {
		      NSMutableString *tempCaptchaID = [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
		      [tempCaptchaID replaceOccurrencesOfString:@"\"" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempCaptchaID length])];
		      captchaID = tempCaptchaID;
		      NSString *captchaImgURL = [NSString stringWithFormat:CAPTCHAIMGURLFORMATSTRING, tempCaptchaID];
		      //加载验证码图片

		      !success ?: success(captchaImgURL, captchaID);

	      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			!failure ?: failure(error);
		}];
}

@end
