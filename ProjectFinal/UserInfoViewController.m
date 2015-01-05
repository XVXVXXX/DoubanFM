//
//  UserInfoViewController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "UserInfoViewController.h"

@interface UserInfoViewController (){
    NetworkManager *networkManager;
    UIStoryboard *mainStoryboard;
    AppDelegate *appDelegate;
}

@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    appDelegate = [[UIApplication sharedApplication]delegate];
    //给登陆图片添加手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(loginImageTapped)];
    [singleTap setNumberOfTapsRequired:1];
    self.loginImage.userInteractionEnabled = YES;
    [self.loginImage addGestureRecognizer:singleTap];
    
    networkManager = [[NetworkManager alloc]init];
    networkManager.delegate = (id)self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self setUserInfo];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loginImageTapped{
    LoginViewController *loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
    loginVC.delegate = (id)self;
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
    if (appDelegate.userInfo.cookies != nil) {
        [_loginImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img3.douban.com/icon/ul%@-1.jpg",appDelegate.userInfo.userID]]];
        _loginImage.userInteractionEnabled = NO;
        _usernameLabel.text = appDelegate.userInfo.name;
        _playedLabel.text = appDelegate.userInfo.played;
        _likedLabel.text = appDelegate.userInfo.liked;
        _bannedLabel.text = appDelegate.userInfo.banned;
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
