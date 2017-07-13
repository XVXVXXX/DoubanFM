//
//  DFMHotChannelsEntity.h
//  DoubanFM
//
//  Created by xvxvxxx on 10/3/15.
//  Copyright © 2015 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DFMChannelInfo;

@interface DFMHotChannelsEntity : NSObject

@property (nonatomic, strong) NSMutableArray<DFMChannelInfo *> *channels;

@end
