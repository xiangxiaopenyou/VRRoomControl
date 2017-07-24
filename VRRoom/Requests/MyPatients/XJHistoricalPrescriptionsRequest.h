//
//  XJHistoricalPrescriptionsRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/19.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface XJHistoricalPrescriptionsRequest : BaseRequest
@property (copy, nonatomic) NSString *patientId;
@property (strong, nonatomic) NSNumber *paging;

@end
