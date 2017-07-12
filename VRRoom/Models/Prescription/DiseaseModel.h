//
//  DiseaseModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface DiseaseModel : XLModel
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *diseaseName;
@property (copy, nonatomic) NSArray *therapiesArray;

+ (void)fetchDiseasesList:(RequestResultHandler)handler;
+ (void)fetchDiseasesAndTherapies:(RequestResultHandler)handler;

@end
