//
//  PrescriptionDetailRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/15.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface PrescriptionDetailRequest : BaseRequest
@property (copy, nonatomic) NSString *prescriptionId;

@end
