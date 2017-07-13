//
//  DFMPlayListEntity.m
//  DoubanFM
//
//  Created by xvxvxxx on 10/3/15.
//  Copyright © 2015 XVX. All rights reserved.
//

#import "DFMPlayListEntity.h"
#import "DFMSongInfo.h"

@implementation DFMPlayListEntity
+ (NSDictionary *)modelContainerPropertyGenericClass {
	// value should be Class or Class name.
	return @{@"song" : [DFMSongInfo class]};
}

@end
