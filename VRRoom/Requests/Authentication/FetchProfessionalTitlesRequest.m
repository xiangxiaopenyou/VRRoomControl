//
//  FetchProfessionalTitlesRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "FetchProfessionalTitlesRequest.h"

@implementation FetchProfessionalTitlesRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [[RequestManager sharedInstance] POST:@"professionalTitles" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
