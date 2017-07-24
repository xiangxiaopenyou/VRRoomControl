//
//  XJHistoricalPrescriptionsViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/20.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PatientModel;

@interface XJHistoricalPrescriptionsViewController : UIViewController
@property (copy, nonatomic) NSString *patientId;
@property (strong, nonatomic)PatientModel *patientModel;

@end
