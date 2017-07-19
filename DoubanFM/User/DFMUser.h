//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMUserInfoEntity.h"

@interface DFMUser : NSObject
@property (nonatomic, strong, readonly) DFMUserInfoEntity *userInfo;

+ (instancetype)currentUser;
- (void)loadArchiverData;
@end