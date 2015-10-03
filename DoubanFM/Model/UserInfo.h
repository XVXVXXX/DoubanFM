//
//  UserInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>
@property (nonatomic, copy) NSString *isNotLogin;

@property (nonatomic, copy) NSString *cookies;

@property (nonatomic, copy) NSString *userID;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *banned;

@property (nonatomic, copy) NSString *liked;

@property (nonatomic, copy) NSString *played;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (void)archiverUserInfo;

@end

