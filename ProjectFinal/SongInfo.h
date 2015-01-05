//
//  SongInfo.h
//  ProjectFinal
//
//  Created by xvxvxxx on 12/22/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SongInfo : NSObject
@property int index;
@property NSString *title;
@property NSString *artist;
@property NSString *picture;
@property NSString *length;
@property NSString *like;
@property NSString *url;
@property NSString *sid;

- (instancetype) initWithDictionary:(NSDictionary *)dictionary;
@end
