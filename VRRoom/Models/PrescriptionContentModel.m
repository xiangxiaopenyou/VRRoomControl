//
//  PrescriptionContentModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "PrescriptionContentModel.h"
#import "FetchContentsRequest.h"

@implementation PrescriptionContentModel
+ (void)fetchContents:(NSString *)prescriptionId handler:(RequestResultHandler)handler {
    [[FetchContentsRequest new] request:^BOOL(FetchContentsRequest *request) {
        request.prescriptionId = prescriptionId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [PrescriptionContentModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
