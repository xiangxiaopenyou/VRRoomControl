//
//  SearchPatientsRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "SearchPatientsRequest.h"

@implementation SearchPatientsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.keyword forKey:@"keyword"];
    [[RequestManager sharedInstance] POST:@"appControlVrRoom/patient/getByKeyword" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            if ([responseObject[@"code"] integerValue] >= 95 && [responseObject[@"code"] integerValue] < 100) {
                !resultHandler ?: resultHandler(nil, responseObject[@"code"]);
            } else {
                !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
