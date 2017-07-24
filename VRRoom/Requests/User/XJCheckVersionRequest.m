//
//  XJCheckVersionRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/21.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJCheckVersionRequest.h"

@implementation XJCheckVersionRequest
-(void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:@1 forKey:@"systemVersion"];
    [[RequestManager sharedInstance] POST:@"getVersion" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
        !resultHandler ?: resultHandler(nil, @"网络错误");
    }];
}

@end
