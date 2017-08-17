//
//  TitlesModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@interface TitlesModel : XLModel
@property (copy, nonatomic) NSString *titleId;
@property (copy, nonatomic) NSString *name;        //职称名

//+ (void)professionalTitles:(RequestResultHandler)handler;

@end
