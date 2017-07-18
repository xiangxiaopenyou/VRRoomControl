//
//  XJAddPatientRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJAddPatientRequest.h"

@implementation XJAddPatientRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.informations[@"clinichistoryNo"] forKey:@"clinichistoryNo"];
    [self.params setObject:self.informations[@"name"] forKey:@"name"];
    [self.params setObject:self.informations[@"birthday"] forKey:@"birthday"];
    [self.params setObject:self.informations[@"sex"] forKey:@"sex"];
    [self.params setObject:self.informations[@"diseaseId"] forKey:@"diseaseId"];
    if (self.informations[@"phone"]) {
        [self.params setObject:self.informations[@"phone"] forKey:@"phone"];
    }
    if (self.informations[@"remark"]) {
        [self.params setObject:self.informations[@"remark"] forKey:@"remark"];
    }
    if (self.informations[@"maritalStatus"]) {
        [self.params setObject:self.informations[@"maritalStatus"] forKey:@"maritalStatus"];
    }
    if (self.informations[@"educationDegree"]) {
        [self.params setObject:self.informations[@"educationDegree"] forKey:@"educationDegree"];
    }
    if (self.informations[@"medicalInsuranceCardNo"]) {
        [self.params setObject:self.informations[@"medicalInsuranceCardNo"] forKey:@"medicalInsuranceCardNo"];
    }
    [[RequestManager sharedInstance] POST:@"addPatient" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
