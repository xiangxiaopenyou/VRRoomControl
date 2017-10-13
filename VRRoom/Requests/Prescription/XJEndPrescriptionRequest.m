//
//  XJEndPrescriptionRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/9/20.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJEndPrescriptionRequest.h"

@implementation XJEndPrescriptionRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.prescriptionId forKey:@"prescriptionId"];
    [[RequestManager sharedInstance] POST:@"endPrescription" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
