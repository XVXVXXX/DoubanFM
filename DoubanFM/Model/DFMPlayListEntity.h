//
//  DFMPlayListEntity.h
//  DoubanFM
//
//  Created by xvxvxxx on 10/3/15.
//  Copyright © 2015 XVX. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DFMSongInfo;

@interface DFMPlayListEntity : NSObject

@property (nonatomic, strong) NSMutableArray<DFMSongInfo *> *song;

@end
