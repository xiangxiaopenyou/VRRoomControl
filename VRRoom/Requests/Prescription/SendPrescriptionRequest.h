//
//  SendPrescriptionRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/11/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"
@class PrescriptionModel;

@interface SendPrescriptionRequest : BaseRequest
@property (strong, nonatomic) PrescriptionModel *model;

@end
