//
//  UserInfoViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/UIKit+AFNetworking.h>
#import "LoginViewController.h"
#import "NetworkManager.h"
#import "AppDelegate.h"
@interface UserInfoViewController : UIViewController <LoginViewControllerDelegate,NetworManagerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *loginImage;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *playedLabel;
@property (strong, nonatomic) IBOutlet UILabel *likedLabel;
@property (strong, nonatomic) IBOutlet UILabel *bannedLabel;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

- (IBAction)logoutButtonTapped:(UIButton *)sender;
-(void)setUserInfo;
-(void)logoutSuccess;
@end
