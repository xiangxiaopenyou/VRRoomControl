//
//  UserModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface UserModel : XLModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *vrRoomId;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *vrRoomName;
+ (void)userLogin:(NSString *)username password:(NSString *)password hanlder:(RequestResultHandler)handler;
+ (void)changePassword:(NSString *)oldPassword password:(NSString *)password hanlder:(RequestResultHandler)hanlder;
@end
