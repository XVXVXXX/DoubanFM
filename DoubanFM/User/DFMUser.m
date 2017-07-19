//
// Created by fufeng on 2017/7/17.
// Copyright (c) 2017 XVX. All rights reserved.
//

#import "DFMUser.h"
#import "DFMChannelDataCenter.h"

@interface DFMUser()
@property (nonatomic, strong) DFMUserInfoEntity *userInfo;
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

- (void)loadArchiverData{
	NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
	NSString *appdelegatePath = [homePath stringByAppendingPathComponent:@"appdelegate.archiver"];
	//添加储存的文件名
	NSData *data = [[NSData alloc]initWithContentsOfFile:appdelegatePath];
	NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
	[DFMUser currentUser].userInfo = [unarchiver decodeObjectForKey:@"userInfo"];
	[unarchiver finishDecoding];

	if ([DFMChannelDataCenter sharedCenter].currentChannel.id == nil) {
		DFMChannelInfoEntity *currentChannel = [[DFMChannelInfoEntity alloc]init];
		currentChannel.name = @"我的私人";
		currentChannel.id = @"0";
		[DFMChannelDataCenter sharedCenter].currentChannel = currentChannel;
	}
	if (_userInfo == nil) {
		_userInfo = [[DFMUserInfoEntity alloc]init];
	}
}
@end