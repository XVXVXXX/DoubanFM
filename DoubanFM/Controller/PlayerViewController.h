//
//  PlayerViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import <MediaPlayer/MediaPlayer.h>
#import "NetworkManager.h"
#import "ChannelsTableViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SongInfo.h"
#import "PlayerController.h"
#import "ProtocolClass.h"
@interface PlayerViewController : UIViewController <DoubanDelegate>{
}

-(void)loadPlaylist;
@end

