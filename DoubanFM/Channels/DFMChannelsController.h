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
#import "DFMChannelInfo.h"
#import "AppDelegate.h"
#import "DFMNetworkManager.h"
#import "DFMPlayerController.h"
#import "DFMProtocolClass.h"

@interface DFMChannelsController : UITableViewController <DoubanDelegate>

@property(nonatomic, weak) id <DoubanDelegate> delegate;

@end
