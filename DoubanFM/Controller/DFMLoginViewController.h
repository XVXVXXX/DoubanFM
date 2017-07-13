//
//  DFMLoginViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/27/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "DFMNetworkManager.h"
#import "AppDelegate.h"
#import "DFMProtocolClass.h"

@interface DFMLoginViewController : UIViewController <DoubanDelegate>

@property (weak, nonatomic)id<DoubanDelegate>delegate;

@end
