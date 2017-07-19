//
//  XJModifyInformationsViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientModel;

@interface XJModifyInformationsViewController : UIViewController
@property (strong, nonatomic) PatientModel *model;
@property (nonatomic) XJPatientInformationTypes type;

@property (copy, nonatomic) void (^modifyBlock)(PatientModel *model);


@end
