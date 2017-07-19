//
//  DFMLoginViewController.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/27/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworking.h>
#import "DFMUserManager.h"
#import "AppDelegate.h"

@protocol DFMUserInfoViewControllerProtocol;

@interface DFMLoginViewController : UIViewController

@property (weak, nonatomic)id<DFMUserInfoViewControllerProtocol>delegate;

@end
