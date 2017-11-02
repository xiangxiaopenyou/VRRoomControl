//
//  XJSendPlanRequest.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/2.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJSendPlanRequest.h"
#import "XJPlanModel.h"
#import "ContentModel.h"

@implementation XJSendPlanRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.patientId forKey:@"patientId"];
    [self.params setObject:self.planModel.name forKey:@"name"];
    if (!XLIsNullObject(self.planModel.instruction)) {
        [self.params setObject:self.planModel.instruction forKey:@"instruction"];
    }
    [self.params setObject:self.planModel.times forKey:@"times"];
    [self.params setObject:self.planModel.scenes forKey:@"scenes"];
    [self.params setObject:self.planModel.diseaseId forKey:@"diseaseId"];
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    [self.planModel.contents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContentModel *contentModel = obj;
        [tempArray addObject:contentModel.id];
    }];
    NSString *contentsIdsString = [tempArray componentsJoinedByString:@","];
    [self.params setObject:contentsIdsString forKey:@"contents"];
    [[RequestManager sharedInstance] POST:@"sendPlan" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
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
