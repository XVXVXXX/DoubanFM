//
//  DFMUserInfoViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMUserInfoViewController.h"
#import "CDSideBarController.h"
#import "BlocksKit+UIKit.h"
#import "DFMUser.h"

@interface DFMUserInfoViewController (){
    DFMUserManager *networkManager;
    UIStoryboard *mainStoryboard;
}

@end

@implementation DFMUserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //给登陆图片添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginImageTapped)];
    [singleTap setNumberOfTapsRequired:1];
    self.loginImage.userInteractionEnabled = YES;
    [self.loginImage addGestureRecognizer:singleTap];
    
    networkManager = [DFMUserManager sharedInstance];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
	UIAlertView *alertView1 = [UIAlertView bk_alertViewWithTitle:@"我抱歉的通知您，本应用在使用的登录接口已经被干掉了，目前无法登录"];
	[alertView1 show];
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		[alertView1 dismissWithClickedButtonIndex:-1 animated:YES];
	});
    [self setUserInfo];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews{
    [super viewWillLayoutSubviews];
    _loginImage.layer.cornerRadius = (CGFloat)(_loginImage.frame.size.width/2.0);
    if (!_loginImage.clipsToBounds) {
        _loginImage.clipsToBounds = YES;
    }
}
- (void)loginImageTapped{
    DFMLoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.delegate = (id)self;
    [[CDSideBarController sharedInstance] dismissMenu];
    [self presentViewController:loginVC animated:YES completion:nil];
}

- (IBAction)logoutButtonTapped:(UIButton *)sender {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"登出" message:@"您确定要登出么" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
            [networkManager logout];
            break;
        default:
            break;
    }
}

-(void)setUserInfo{
	DFMUserInfoEntity *userInfo = [DFMUser currentUser].userInfo;
    if (userInfo.cookies) {
        [_loginImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img3.douban.com/icon/ul%@-1.jpg",userInfo.userID]]];
        _loginImage.userInteractionEnabled = NO;

        _usernameLabel.text = userInfo.name;
        _playedLabel.text = userInfo.played;
        _likedLabel.text = userInfo.liked;
        _bannedLabel.text = userInfo.banned;
        _logoutButton.hidden = NO;
    }
    else{
        [_loginImage setImage:[UIImage imageNamed:@"login"]];
        _loginImage.userInteractionEnabled = YES;
        _usernameLabel.text = @"";
        _playedLabel.text = @"0";
        _likedLabel.text = @"0";
        _bannedLabel.text = @"0";
        _logoutButton.hidden = YES;
    }
}

-(void)logoutSuccess{
    [self setUserInfo];
}
@end
