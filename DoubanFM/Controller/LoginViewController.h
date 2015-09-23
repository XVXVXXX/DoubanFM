//
//  LoginViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/27/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "NetworkManager.h"
#import "AppDelegate.h"
#import "ProtocolClass.h"

@interface LoginViewController : UIViewController <DoubanDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *captchaImageview;
@property (strong, nonatomic) IBOutlet UITextField *username;
@property (strong, nonatomic) IBOutlet UITextField *password;
@property (strong, nonatomic) IBOutlet UITextField *captcha;
@property (weak, nonatomic)id<DoubanDelegate>delegate;
- (IBAction)submitButtonTapped:(UIButton *)sender;
- (IBAction)cancelButtonTapped:(UIButton *)sender;
- (IBAction)backgroundTap:(id)sender;

@end
