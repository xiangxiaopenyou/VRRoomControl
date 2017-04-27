//
//  PatientModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface PatientModel : XLModel
@property (copy, nonatomic) NSString *userId;
@property (copy, nonatomic) NSString *realname;
@property (copy, nonatomic) NSString *mobile;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) NSNumber *gender;
+ (void)searchPatient:(NSString *)keyword handler:(RequestResultHandler)handler;

@end
