//
//  PatientModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "PatientModel.h"
#import "SearchPatientsRequest.h"
#import "XJPatientInformationsRequest.h"
#import "XJModifyInformationsRequest.h"

@implementation PatientModel
+ (void)searchPatient:(NSString *)keyword handler:(RequestResultHandler)handler {
    [[SearchPatientsRequest new] request:^BOOL(SearchPatientsRequest *request) {
        request.keyword = keyword;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            PatientModel *tempModel = [PatientModel yy_modelWithDictionary:(NSDictionary *)object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)patientInformations:(NSString *)patientId handler:(RequestResultHandler)handler {
    [[XJPatientInformationsRequest new] request:^BOOL(XJPatientInformationsRequest *request) {
        request.patientId = patientId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            PatientModel *tempModel = [PatientModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)modifyInformations:(PatientModel *)model patientId:(NSString *)patientId handler:(RequestResultHandler)handler {
    [[XJModifyInformationsRequest new] request:^BOOL(XJModifyInformationsRequest *request) {
        request.model = model;
        request.patientId = patientId;
        return YES;
    } result:handler];
}

@end
