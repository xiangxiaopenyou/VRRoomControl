//
//  FetchVerificationCodeRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface FetchVerificationCodeRequest : BaseRequest
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSNumber *type;

@end
