//
//  XJPlanModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface XJPlanModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *contents;

+ (void)myPlans:(RequestResultHandler)handler;
+ (void)addPlan:(NSString *)name contentId:(NSString *)contentIds handler:(RequestResultHandler)handler;
+ (void)editPlan:(NSString *)planId name:(NSString *)name contentId:(NSString *)contentIds handler:(RequestResultHandler)handler;
+ (void)deletePlan:(NSString *)planId handler:(RequestResultHandler)handler;

@end
