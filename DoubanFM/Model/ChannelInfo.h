//
//  ChannelsInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelInfo : NSObject

@property (nonatomic, copy) NSString *id;
@property (nonatomic, copy) NSString *name;

+ (instancetype)currentChannel;
+ (void)updateCurrentCannel:(ChannelInfo *)channel;

@end
