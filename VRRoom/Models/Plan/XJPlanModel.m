
//
//  XJPlanModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanModel.h"
#import "ContentModel.h"
#import "XJPlansListRequest.h"
#import "XJFetchCollectPlansRequest.h"
#import "XJCollectOparetionRequest.h"
#import "XJSendPlanRequest.h"

@implementation XJPlanModel
+ (void)plansList:(NSString *)diseaseId paging:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[XJPlansListRequest new] request:^BOOL(XJPlansListRequest *request) {
        request.diseaseId = diseaseId;
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler (nil, msg);
        } else {
            NSMutableArray *tempArray = [[XJPlanModel setupWithArray:(NSArray *)object] mutableCopy];
            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XJPlanModel *tempModel = obj;
                tempModel.contents = [ContentModel setupWithArray:tempModel.contents];
            }];
            !handler ?: handler (tempArray, nil);
        }
    }];
}
+ (void)collectedPlansList:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[XJFetchCollectPlansRequest new] request:^BOOL(XJFetchCollectPlansRequest *request) {
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler (nil, msg);
        } else {
            NSMutableArray *tempArray = [[XJPlanModel setupWithArray:(NSArray *)object] mutableCopy];
            [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                XJPlanModel *tempModel = obj;
                tempModel.contents = [ContentModel setupWithArray:tempModel.contents];
            }];
            !handler ?: handler (tempArray, nil);
        }
    }];
}
+ (void)collectPlan:(NSString *)planId handler:(RequestResultHandler)handler {
    [[XJCollectOparetionRequest new] request:^BOOL(XJCollectOparetionRequest *request) {
        request.isCancel = NO;
        request.planId = planId;
        return YES;
    } result:handler];
}
+ (void)cancelCollectPlan:(NSString *)planId handler:(RequestResultHandler)handler {
    [[XJCollectOparetionRequest new] request:^BOOL(XJCollectOparetionRequest *request) {
        request.isCancel = YES;
        request.planId = planId;
        return YES;
    } result:handler];
}
+ (void)sendPlan:(XJPlanModel *)model patientId:(NSString *)patientId handler:(RequestResultHandler)handler {
    [[XJSendPlanRequest new] request:^BOOL(XJSendPlanRequest *request) {
        request.patientId = patientId;
        request.planModel = model;
        return YES;
    } result:handler];
}

@end
