//
//  FetchVerificationCodeRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchVerificationCodeRequest.h"

@implementation FetchVerificationCodeRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSDictionary *param = @{@"mobile" : self.phoneNumber,
                            @"type" : self.type};
    [[RequestManager sharedInstance] POST:@"sendCode" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
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
