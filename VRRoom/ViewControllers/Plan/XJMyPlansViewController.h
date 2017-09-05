//
//  XJMyPlansViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^PlanSelectBlock)(NSArray *array);

@interface XJMyPlansViewController : UIViewController
@property (assign, nonatomic) NSInteger viewType;
@property (strong, nonatomic) NSMutableArray *selectedContentsArray;

@property (copy, nonatomic) PlanSelectBlock block;

@end
