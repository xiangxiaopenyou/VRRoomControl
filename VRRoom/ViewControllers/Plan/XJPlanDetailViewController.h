//
//  XJPlanDetailViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/26.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJPlanModel;

@interface XJPlanDetailViewController : UIViewController
@property (strong, nonatomic) XJPlanModel *planModel;
@property (nonatomic) NSInteger viewType;

@end
