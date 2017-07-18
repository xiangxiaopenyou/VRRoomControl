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
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *remark;
@property (copy, nonatomic) NSString *realnameFirstSpell;
@property (copy, nonatomic) NSString *clinichistoryNo;
@property (copy, nonatomic) NSString *birthday;
@property (strong, nonatomic) NSNumber *sex;
@property (copy, nonatomic) NSString *phone;
@property (strong, nonatomic) NSNumber *maritalStatus;
@property (strong, nonatomic) NSNumber *educationDegree;
@property (copy, nonatomic) NSString *medicalInsuranceCardNo;
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *disease;
@property (strong, nonatomic) NSNumber *canModify;
+ (void)searchPatient:(NSString *)keyword handler:(RequestResultHandler)handler;
+ (void)patientInformations:(NSString *)patientId handler:(RequestResultHandler)handler;

@end
