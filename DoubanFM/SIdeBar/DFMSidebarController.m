//
//  DFMSidebarController.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/27/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "DFMSidebarController.h"
#import "DFMPlayerViewController.h"
#import "DFMChannelsController.h"
#import "BlocksKit.h"

@interface DFMSidebarController ()
@property(nonatomic, strong) CDSideBarController *sideBar;
@property(nonatomic, strong) DFMPlayerViewController *playerVC;
@property(nonatomic, strong) DFMChannelsController *channelsVC;
@property(nonatomic, strong) DFMUserInfoViewController *userInfoVC;
@end

@implementation DFMSidebarController

- (void)viewDidLoad {
    [super viewDidLoad];
	//隐藏掉系统的TabBar，否侧下面会有一块Bar出现
	self.tabBar.hidden = YES;

	NSArray<UIImage *> *imageList = [@[@"menuPlayer", @"menuChannel", @"menuLogin", @"menuClose"] bk_map:^id(NSString *obj) {
		return [UIImage imageNamed:obj];
	}];

    _sideBar = [CDSideBarController sharedInstanceWithImages:imageList];
    _sideBar.delegate = self;

    _playerVC = [[DFMPlayerViewController alloc] init];
    
    _channelsVC = [[DFMChannelsController alloc]init];

	UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    _userInfoVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"userInfoVC"];

    self.viewControllers = @[_playerVC, _channelsVC, _userInfoVC];
	[_sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.view.frame.size.width - 50, 30)];
}

-(BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - CDSidebar Delegate
-(void)menuButtonClicked:(int)index{
    self.selectedIndex = (NSUInteger)index;
    switch (index) {
        case 0:
        case 1:
        case 2:
            self.selectedIndex = (NSUInteger)index;
            break;
        case 3:
        default:
		    break;
    }
}

@end
