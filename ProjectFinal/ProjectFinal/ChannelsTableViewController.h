//
//  ChannelsTableViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/21/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "ChannelsTableViewCell.h"
#import "ChannelInfo.h"
#import "AppDelegate.h"
#import "NetworkManager.h"
#import "PlayerController.h"
@protocol ChannelsTableViewController <NSObject>

- (void)menuButtonClicked:(int)index;

@end
@interface ChannelsTableViewController : UITableViewController <NetworManagerDelegate>

@property (nonatomic, retain) id<ChannelsTableViewController> delegate;


@property NSMutableArray *channels;
@property NSArray *channelsTitle;
@property NSArray *myChannels;
@property NSMutableArray *recommendChannels;
@property NSMutableArray *upTrendingChannels;
@property NSMutableArray *hotChannels;

@end
