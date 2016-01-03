//
//  NetworkManager.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/18/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProtocolClass.h"

@interface NetworkManager : NSObject

@property (weak, nonatomic)id<DoubanDelegate>delegate;
@property (nonatomic) NSMutableString *captchaID;

+ (instancetype)sharedInstancd;

-(instancetype)init;

-(void)setChannel:(NSUInteger)channelIndex withURLWithString:(NSString *)urlWithString;

-(void)LoginwithUsername:(NSString *)username
                Password:(NSString *)password
                 Captcha:(NSString *)captcha
         RememberOnorOff:(NSString *)rememberOnorOff;

-(void)logout;

-(void)loadCaptchaImage;

-(void)loadPlaylistwithType:(NSString *)type;
@end
