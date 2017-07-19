//
//  DFMUserInfoViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "UIKit+AFNetworking.h"
#import "DFMLoginViewController.h"
#import "DFMUserManager.h"
#import "AppDelegate.h"

@protocol DFMUserInfoViewControllerProtocol <NSObject>
/**
 *  初始化用户信息delegate
 */
-(void)setUserInfo;
@end

@interface DFMUserInfoViewController : UIViewController <UIAlertViewDelegate>
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
