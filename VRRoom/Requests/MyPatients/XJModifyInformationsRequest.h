//
//  XJModifyInformationsRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"
@class PatientModel;

@interface XJModifyInformationsRequest : BaseRequest
@property (strong, nonatomic) PatientModel *model;
@property (copy, nonatomic) NSString *patientId;

@end
