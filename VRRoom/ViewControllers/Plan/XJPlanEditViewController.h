//
//  XJPlanEditViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/1.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJPlanModel;

@interface XJPlanEditViewController : UIViewController
@property (strong, nonatomic) XJPlanModel *planModel;
@property (copy, nonatomic) NSString *patientId;

@end
