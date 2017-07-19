//
//  DFMUserManager.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DFMUserManager : NSObject

@property (nonatomic) NSMutableString *captchaID;

+ (instancetype)sharedInstance;

-(instancetype)init;

-(void)loginWithUserName:(NSString *)username
                password:(NSString *)password
                 captcha:(NSString *)captcha
         rememberOnorOff:(NSString *)rememberOnorOff;

-(void)logout;

- (void)getCaptchaImageInfoSuccess:(void (^)(NSString *captchaImage, NSString *captchaID))success failure:(void (^)(NSError *error))failure;

@end
