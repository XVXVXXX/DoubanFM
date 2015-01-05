//
//  ChannelsInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelInfo : NSObject
@property NSString *ID;
@property NSString *name;
-(instancetype)initWithDictionary:(NSDictionary *)dictionary;
@end
