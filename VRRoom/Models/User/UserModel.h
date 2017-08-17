//
//  UserModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"
@class PrescriptionModel;

@interface UserModel : XLModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *token;
@property (copy, nonatomic) NSString *hospital;
//@property (copy, nonatomic) NSString *vrRoomName;
+ (void)userLogin:(NSString *)username password:(NSString *)password hanlder:(RequestResultHandler)handler;
+ (void)changePassword:(NSString *)oldPassword password:(NSString *)password hanlder:(RequestResultHandler)hanlder;
+ (void)addPatient:(NSDictionary *)informations handler:(RequestResultHandler)handler;
+ (void)sendPrescription:(PrescriptionModel *)model handler:(RequestResultHandler)handler;
+ (void)myPatients:(RequestResultHandler)hanlder;
+ (void)versionInformations:(RequestResultHandler)handler;
+ (void)fetchCode:(NSString *)phoneNumber type:(NSNumber *)type handler:(RequestResultHandler)handler;
+ (void)userRegister:(NSString *)username password:(NSString *)password code:(NSString *)verificationCode handler:(RequestResultHandler)handler;
@end
