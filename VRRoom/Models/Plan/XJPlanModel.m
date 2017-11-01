
//
//  XJPlanModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanModel.h"
#import "ContentModel.h"
#import "XJFetchMyPlansRequest.h"
#import "XJAddPlanRequest.h"
#import "XJEditPlanRequest.h"
#import "XJDeletePlanRequest.h"
#import "XJPlansListRequest.h"
#import "XJFetchCollectPlansRequest.h"
#import "XJCollectOparetionRequest.h"

@implementation XJPlanModel
+ (void)myPlans:(RequestResultHandler)handler {
    [[XJFetchMyPlansRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *resultArray = [XJPlanModel setupWithArray:(NSArray *)object];
            for (XJPlanModel *tempModel in resultArray) {
                tempModel.contents = [ContentModel setupWithArray:tempModel.contents];
            }
            !handler ?: handler(resultArray, nil);
        }
    }];
}
+ (void)addPlan:(NSString *)name contentId:(NSString *)contentIds handler:(RequestResultHandler)handler {
    [[XJAddPlanRequest new] request:^BOOL(XJAddPlanRequest *request) {
        request.name = name;
        request.contentIdsString = contentIds;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            !handler ?: handler(object, nil);
        }
    }];
}
+ (void)editPlan:(NSString *)planId
            name:(NSString *)name
       contentId:(NSString *)contentIds
         handler:(RequestResultHandler)handler {
    [[XJEditPlanRequest new] request:^BOOL(XJEditPlanRequest *request) {
        request.planId = planId;
        request.name = name;
        request.contentIdsString = contentIds;
        return YES;
    } result:handler];
}
+ (void)deletePlan:(NSString *)planId handler:(RequestResultHandler)handler {
    [[XJDeletePlanRequest new] request:^BOOL(XJDeletePlanRequest *request) {
        request.planId = planId;
        return YES;
    } result:handler];
}
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

@end
