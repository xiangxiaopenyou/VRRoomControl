//
//  PrescriptionModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "PrescriptionModel.h"
#import "FetchPrescriptionsRequest.h"

@implementation PrescriptionModel
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

@end
