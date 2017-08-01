//
//  XJModifyInformationsRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJModifyInformationsRequest.h"
#import "PatientModel.h"

@implementation XJModifyInformationsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.patientId forKey:@"patientId"];
    [self.params setObject:self.model.clinichistoryNo forKey:@"clinichistoryNo"];
    [self.params setObject:self.model.name forKey:@"name"];
    [self.params setObject:self.model.birthday forKey:@"birthday"];
    [self.params setObject:self.model.sex forKey:@"sex"];
    [self.params setObject:self.model.diseaseId forKey:@"diseaseId"];
    [self.params setObject:self.model.maritalStatus forKey:@"maritalStatus"];
    [self.params setObject:self.model.educationDegree forKey:@"educationDegree"];
    [self.params setObject:self.model.ts forKey:@"ts"];
    if (self.model.phone) {
        [self.params setObject:self.model.phone forKey:@"phone"];
    }
    if (self.model.remark) {
        [self.params setObject:self.model.remark forKey:@"remark"];
    }
    if (self.model.medicalInsuranceCardNo) {
        [self.params setObject:self.model.medicalInsuranceCardNo forKey:@"medicalInsuranceCardNo"];
    }
    [[RequestManager sharedInstance] POST:@"modifyPatientInformations" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
