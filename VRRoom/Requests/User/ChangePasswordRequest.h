//
//  ChangePasswordRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/12.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface ChangePasswordRequest : BaseRequest
@property (copy, nonatomic) NSString *oldPassword;
@property (copy, nonatomic) NSString *password;

@end
