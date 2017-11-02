//
//  XJSendPlanRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/2.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"
@class XJPlanModel;

@interface XJSendPlanRequest : BaseRequest
@property (strong, nonatomic) XJPlanModel *planModel;
@property (copy, nonatomic) NSString *patientId;
@end
