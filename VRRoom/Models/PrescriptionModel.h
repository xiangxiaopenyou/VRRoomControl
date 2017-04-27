//
//  PrescriptionModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface PrescriptionModel : XLModel
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *creator;
@property (copy, nonatomic) NSString *createdAt;
@property (strong, nonatomic) NSNumber *status;
@property (strong, nonatomic) NSNumber *total;
@property (copy, nonatomic) NSString *suggestion;
@property (copy, nonatomic) NSString *patientId;
@property (copy, nonatomic) NSString *doctorName;
@property (strong, nonatomic) NSNumber *source;
@property (copy, nonatomic) NSString *disease;

+ (void)fetchPrescriptionsList:(NSString *)patientId handler:(RequestResultHandler)handler;
@end
