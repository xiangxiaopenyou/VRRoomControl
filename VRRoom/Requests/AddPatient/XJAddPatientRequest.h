//
//  XJAddPatientRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface XJAddPatientRequest : BaseRequest
@property (copy, nonatomic) NSString *roomId;
@property (copy, nonatomic) NSDictionary *informations;

@end
