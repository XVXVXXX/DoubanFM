//
//  UserInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>
@property NSString *isNotLogin;
@property NSString *cookies;
@property NSString *userID;
@property NSString *name;
@property NSString *banned;
@property NSString *liked;
@property NSString *played;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)archiverUserInfo;

@end

