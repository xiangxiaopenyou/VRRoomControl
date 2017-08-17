//
//  RegisterRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface RegisterRequest : BaseRequest
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (copy, nonatomic) NSString *captcha;

@end
