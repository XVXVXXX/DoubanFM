//
//  ProtocolClass.h
//  ProjectFinal
//
//  Created by xvxvxxx on 3/11/15.
//  Copyright (c) 2015 谢伟军. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol DoubanDelegate <NSObject>
@optional
/**
 *  登陆界面delegate
 *
 *  @param url 
 */
-(void)setCaptchaImageWithURLInString:(NSString *)url;

-(void)loginSuccess;
-(void)logoutSuccess;

/**
 *  播放列表delegate
 */
-(void)reloadTableviewData;

/**
 *  初始化歌曲delegate
 */
-(void)initSongInfomation;

/**
 *  初始化用户信息delegate
 */
-(void)setUserInfo;

-(void)menuButtonClicked:(int)index;
@end

@interface ProtocolClass : NSObject

@end
