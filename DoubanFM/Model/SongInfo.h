//
//  SongInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *artist;

@property (nonatomic, copy) NSString *picture;

@property (nonatomic, copy) NSString *length;

@property (nonatomic, copy) NSString *like;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *sid;

+ (instancetype) currentSong;

+ (void)setCurrentSong:(SongInfo *)songInfo;

+ (NSInteger) currentSongIndex;

+ (void)setCurrentSongIndex:(int)songIndex;

@end
