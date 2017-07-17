//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import "DFMUser.h"

@interface DFMUser()
@property (nonatomic, strong) DFMUserInfo *userInfo;
@end

@implementation DFMUser
+ (instancetype)currentUser {
	static DFMUser *user;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		user = [[DFMUser alloc] init];
	});
	return user;
}

@end