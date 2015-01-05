//
//  ChannelsInfo.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "ChannelInfo.h"

@implementation ChannelInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.ID = [dictionary objectForKey:@"id"];
        self.name = [dictionary objectForKey:@"name"];
    }
    return self;
}
@end
