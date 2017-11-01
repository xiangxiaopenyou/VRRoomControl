//
//  XJCollectOparetionRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/31.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJCollectOparetionRequest.h"

@implementation XJCollectOparetionRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.planId forKey:@"planId"];
    NSString *urlString = nil;
    if (self.isCancel) {
        urlString = @"cancelCollectPlan";
    } else {
        urlString = @"collectPlan";
    }
    [[RequestManager sharedInstance] POST:urlString parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
