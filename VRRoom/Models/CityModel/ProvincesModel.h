//
//  ProvincesModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface ProvincesModel : XLModel
@property (copy, nonatomic) NSString *code;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *fullName;
@property (copy, nonatomic) NSArray *array;

+ (void)fetchAreas:(RequestResultHandler)handler;

@end
