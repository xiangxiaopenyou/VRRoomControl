//
//  XJAddPlanRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface XJAddPlanRequest : BaseRequest
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *contentIdsString;

@end
