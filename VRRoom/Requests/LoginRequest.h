//
//  LoginRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginRequest : BaseRequest
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;

@end
