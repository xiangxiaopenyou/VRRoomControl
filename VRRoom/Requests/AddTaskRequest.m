//
//  AddTaskRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/17.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "AddTaskRequest.h"

@implementation AddTaskRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.userId forKey:@"userId"];
    [self.params setObject:self.type forKey:@"type"];
    [self.params setObject:self.prescriptionContentId forKey:@"prescriptionContentId"];
    [self.params setObject:self.content forKey:@"content"];
    [[RequestManager sharedInstance] POST:@"appControlVrRoom/task/add" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}

@end
