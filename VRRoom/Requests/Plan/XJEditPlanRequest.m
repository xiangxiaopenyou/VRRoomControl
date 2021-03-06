//
//  XJEditPlanRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/26.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJEditPlanRequest.h"

@implementation XJEditPlanRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.planId forKey:@"planId"];
    [self.params setObject:self.name forKey:@"name"];
    [self.params setObject:self.contentIdsString forKey:@"contentIds"];
    [[RequestManager sharedInstance] POST:@"upPlan" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
