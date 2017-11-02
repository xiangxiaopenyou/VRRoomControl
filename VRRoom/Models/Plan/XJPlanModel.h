//
//  XJPlanModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"
@class XJPlanModel;

@interface XJPlanModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *contents;
@property (copy, nonatomic) NSString *instruction;
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *diseaseName;
@property (strong, nonatomic) NSNumber *times;
@property (strong, nonatomic) NSNumber *scenes;
@property (strong, nonatomic) NSNumber *isCollected;

+ (void)plansList:(NSString *)diseaseId paging:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)collectedPlansList:(NSNumber *)paging handler:(RequestResultHandler)handler;
+ (void)collectPlan:(NSString *)planId handler:(RequestResultHandler)handler;
+ (void)cancelCollectPlan:(NSString *)planId handler:(RequestResultHandler)handler;
+ (void)sendPlan:(XJPlanModel *)model patientId:(NSString *)patientId handler:(RequestResultHandler)handler;
@end
