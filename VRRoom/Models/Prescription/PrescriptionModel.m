//
//  PrescriptionModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "PrescriptionModel.h"
#import "FetchPrescriptionsRequest.h"
#import "XJHistoricalPrescriptionsRequest.h"
#import "PrescriptionDetailRequest.h"
#import "XJPlanModel.h"
#import "ContentModel.h"

@implementation PrescriptionModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{ @"prescriptionContentList" : @"contents" };
}
+ (void)fetchPrescriptionsList:(NSString *)patientId handler:(RequestResultHandler)handler {
    [[FetchPrescriptionsRequest new] request:^BOOL(FetchPrescriptionsRequest *request) {
        request.patientId = patientId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [PrescriptionModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)historicalPrescriptions:(NSString *)patientId paging:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[XJHistoricalPrescriptionsRequest new] request:^BOOL(XJHistoricalPrescriptionsRequest *request) {
        request.patientId = patientId;
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [XJPlanModel setupWithArray:(NSArray *)object];
            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XJPlanModel *tempModel = obj;
                tempModel.contents = [ContentModel setupWithArray:tempModel.contents];
            }];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)prescriptionDetail:(NSString *)prescriptionId handler:(RequestResultHandler)handler {
    [[PrescriptionDetailRequest new] request:^BOOL(PrescriptionDetailRequest *request) {
        request.prescriptionId = prescriptionId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            PrescriptionModel *tempModel = [PrescriptionModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}

@end
