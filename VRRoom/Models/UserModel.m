//
//  UserModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "UserModel.h"
#import "LoginRequest.h"
#import "ChangePasswordRequest.h"

@implementation UserModel
+ (void)userLogin:(NSString *)username password:(NSString *)password hanlder:(RequestResultHandler)handler {
    [[LoginRequest new] request:^BOOL(LoginRequest *request) {
        request.username = username;
        request.password = password;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            UserModel *tempModel = [UserModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)changePassword:(NSString *)oldPassword password:(NSString *)password hanlder:(RequestResultHandler)hanlder {
    [[ChangePasswordRequest new] request:^BOOL(ChangePasswordRequest *request) {
        request.password = password;
        request.oldPassword = oldPassword;
        return YES;
    } result:hanlder];
}

@end
