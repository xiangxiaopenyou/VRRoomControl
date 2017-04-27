//
//  ManagerModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/17.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface ManagerModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *user_username;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *user_realname;
@property (copy, nonatomic) NSString *vrRoomId;
@property (copy, nonatomic) NSDictionary *user;
@property (copy, nonatomic) NSDictionary *vrRoom;

+ (void)fetchManagers:(NSString *)roomId handler:(RequestResultHandler)handler;
+ (void)addTask:(NSString *)contentId prescriptionContent:(NSString *)prescriptionContentId type:(NSNumber *)type userId:(NSString *)userId handler:(RequestResultHandler)handler;

@end
