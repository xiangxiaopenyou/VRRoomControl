//
//  FetchContentDetailRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/13.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FetchContentDetailRequest.h"

@implementation FetchContentDetailRequest
-(void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    if (self.contentId) {
        [self.params setObject:self.contentId forKey:@"contentId"];
    }
    [[RequestManager sharedInstance] POST:@"content/info" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
