
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

@end
