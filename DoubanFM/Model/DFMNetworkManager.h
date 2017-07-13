//
//  DFMNetworkManager.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DFMProtocolClass.h"

@interface DFMNetworkManager : NSObject

@property (weak, nonatomic)id<DoubanDelegate>delegate;
@property (nonatomic) NSMutableString *captchaID;

+ (instancetype)sharedInstancd;

-(instancetype)init;

-(void)LoginwithUsername:(NSString *)username
                Password:(NSString *)password
                 Captcha:(NSString *)captcha
         RememberOnorOff:(NSString *)rememberOnorOff;

-(void)logout;

-(void)loadCaptchaImage;

-(void)loadPlayListWithType:(NSString *)type;
@end
