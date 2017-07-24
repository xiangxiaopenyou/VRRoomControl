//
//  SearchContentsRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SearchContentsRequest.h"

@implementation SearchContentsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.paging forKey:@"paging"];
    if (!XLIsNullObject(self.therapyId)) {
        [self.params setObject:self.therapyId forKey:@"therapyId"];
    }
    if (!XLIsNullObject(self.diseaseId)) {
        [self.params setObject:self.diseaseId forKey:@"diseaseId"];
    }
    if (!XLIsNullObject(self.keyword)) {
        [self.params setObject:self.keyword forKey:@"keyword"];
    }
    if (!XLIsNullObject(self.sortName)) {
        [self.params setObject:self.sortName forKey:@"sortName"];
    }
    if (!XLIsNullObject(self.sortOrder)) {
        [self.params setObject:self.sortOrder forKey:@"sortOrder"];
    }
    [[RequestManager sharedInstance] POST:@"content/search" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
