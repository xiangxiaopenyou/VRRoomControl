//
//  XJPlanInformationsViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CollectBlock)(BOOL isCollected);

@class XJPlanModel;
@interface XJPlanInformationsViewController : UIViewController
@property (assign, nonatomic) BOOL isView;
@property (assign, nonatomic) BOOL isPatientsPlan;
@property (strong, nonatomic) XJPlanModel *planModel;
@property (copy, nonatomic) NSString *patientId;
@property (copy, nonatomic) CollectBlock block;

@end
