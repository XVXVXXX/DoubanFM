//
//  DFMLoginViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/27/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMLoginViewController.h"
#import "BlocksKit+UIKit.h"
#import "DFMUserInfoViewController.h"
#import <UIImageView+AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface DFMLoginViewController ()

@property(strong, nonatomic) IBOutlet UIImageView *captchaImageview;
@property(strong, nonatomic) IBOutlet UITextField *username;
@property(strong, nonatomic) IBOutlet UITextField *password;
@property(strong, nonatomic) IBOutlet UITextField *captcha;

- (IBAction)submitButtonTapped:(UIButton *)sender;

- (IBAction)cancelButtonTapped:(UIButton *)sender;

- (IBAction)backgroundTap:(id)sender;

@end

@implementation DFMLoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	//初始化图片点击事件
	UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loadCaptchaImage)];
	[singleTap setNumberOfTapsRequired:1];
	self.captchaImageview.userInteractionEnabled = YES;
	[self.captchaImageview addGestureRecognizer:singleTap];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadCaptchaImage];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

- (void)setCaptchaImageWithURLInString:(NSString *)url {
	[self.captchaImageview setImageWithURL:[NSURL URLWithString:url]];

}

- (IBAction)submitButtonTapped:(UIButton *)sender {
	NSString *username = _username.text;
	NSString *password = _password.text;
	NSString *captcha = _captcha.text;
	[[DFMUserManager sharedInstance] loginWithUserName:username password:password captcha:captcha rememberOnorOff:@"off"];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
	[self dismissViewControllerAnimated:YES completion:nil];
}

//验证码图片点击刷新验证码事件
- (void)loadCaptchaImage {
	[[DFMUserManager sharedInstance] getCaptchaImageInfoSuccess:^(NSString *captchaImage, NSString *captchaID) {
			[self.captchaImageview sd_setImageWithURL:[NSURL URLWithString:captchaImage]];
		}
	                                                    failure:^(NSError *error) {
		                                                    UIAlertView *view1 = [UIAlertView bk_alertViewWithTitle:error.localizedDescription];
		                                                    [view1 show];
		                                                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		                                                    [view1 dismissWithClickedButtonIndex:-1 animated:YES];
	                                                        });
	                                                    }];
}

- (void)loginSuccess {
	[_delegate setUserInfo];
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)backgroundTap:(id)sender {
	[_username resignFirstResponder];
	[_password resignFirstResponder];
	[_captcha resignFirstResponder];
}

@end
