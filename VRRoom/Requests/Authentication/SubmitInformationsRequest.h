//
//  SubmitInformationsRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"
@class InformationModel;

@interface SubmitInformationsRequest : BaseRequest
@property (strong, nonatomic) InformationModel *model;

@end
