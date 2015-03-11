//
//  UserInfo.m
//  ProjectFinal
//
//  Created by xvxvxxx on 12/29/14.
//  Copyright (c) 2014 谢伟军. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (self = [super init]) {
        self.isNotLogin = [dictionary valueForKey:@"r"];
        NSDictionary *tempUserInfoDic = [dictionary valueForKey:@"user_info"];
        self.cookies = [tempUserInfoDic valueForKey:@"ck"];
        self.userID = [tempUserInfoDic valueForKey:@"id"];
        self.name = [tempUserInfoDic valueForKey:@"name"];
        NSDictionary *tempPlayRecordDic = [tempUserInfoDic valueForKey:@"play_record"];
        self.banned = [NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"banned"]];
        self.liked = [NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"liked"]];        self.played = [NSString stringWithFormat:@"%@",[tempPlayRecordDic valueForKey:@"played"]];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.isNotLogin = [aDecoder decodeObjectForKey:@"isNotLogin"];
        self.cookies = [aDecoder decodeObjectForKey:@"cookies"];
        self.userID = [aDecoder decodeObjectForKey:@"userID"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.banned = [aDecoder decodeObjectForKey:@"banned"];
        self.liked = [aDecoder decodeObjectForKey:@"liked"];
        self.played = [aDecoder decodeObjectForKey:@"played"];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_isNotLogin forKey:@"isNotLogin"];
    [aCoder encodeObject:_cookies forKey:@"cookies"];
    [aCoder encodeObject:_userID forKey:@"userID"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_banned forKey:@"banned"];
    [aCoder encodeObject:_liked forKey:@"liked"];
    [aCoder encodeObject:_played forKey:@"played"];
}

- (void)archiverUserInfo{
    NSMutableData *data = [[NSMutableData alloc]init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self forKey:@"userInfo"];
    [archiver finishEncoding];
    NSString *homePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *appdelegatePath = [homePath stringByAppendingPathComponent:@"appdelegate.archiver"];//添加储存的文件名
    if ([data writeToFile:appdelegatePath atomically:YES]) {
        NSLog(@"UesrInfo存储成功");
    }
}
@end


