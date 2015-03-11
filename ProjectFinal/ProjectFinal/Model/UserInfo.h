//
//  UserInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject <NSCoding>
@property (nonatomic) NSString *isNotLogin;
@property (nonatomic) NSString *cookies;
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *banned;
@property (nonatomic) NSString *liked;
@property (nonatomic) NSString *played;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (void)archiverUserInfo;

@end

