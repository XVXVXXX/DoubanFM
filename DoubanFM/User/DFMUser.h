//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMUserInfo.h"

@interface DFMUser : NSObject
+ (instancetype)currentUser;
@property (nonatomic, strong, readonly) DFMUserInfo *userInfo;
@end