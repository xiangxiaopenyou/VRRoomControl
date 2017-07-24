//
//  CancelCollectRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/25.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "CancelCollectRequest.h"

@implementation CancelCollectRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.contentId forKey:@"contentId"];
    [[RequestManager sharedInstance] POST:@"content/cancelCollect" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
