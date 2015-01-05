//
//  SidebarController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/27/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "SidebarController.h"

@interface SidebarController (){
    CDSideBarController *sideBar;
    PlayerViewController *playerVC;
    ChannelsTableViewController *channelsVC;
    UserInfoViewController *userInfoVC;
    LoginViewController *loginVC;
    AppDelegate *appDelegate;
}

@end

@implementation SidebarController

- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate = [[UIApplication sharedApplication]delegate];
    // Do any additional setup after loading the view from its nib.
    NSArray *imageList = @[[UIImage imageNamed:@"menuPlayer"], [UIImage imageNamed:@"menuChannel"], [UIImage imageNamed:@"menuLogin"], [UIImage imageNamed:@"menuClose.png"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList];
    sideBar.delegate = self;
    
    UIStoryboard* mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    playerVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"playerVC"];
    channelsVC = [[ChannelsTableViewController alloc]init];
    channelsVC.delegate = (id)self;
    userInfoVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"userInfoVC"];
    loginVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"loginVC"];
    self.viewControllers = @[playerVC, channelsVC, userInfoVC];
}





-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBar.hidden = YES;
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.view.frame.size.width - 50, 40)];
}

#pragma mark - SDSidebar Delegate
-(void)menuButtonClicked:(int)index{
    self.selectedIndex = index;
    switch (index) {
        case 0:
        case 1:
        case 2:
            self.selectedIndex = index;
            break;
        case 3:
            break;
    }
}

@end
