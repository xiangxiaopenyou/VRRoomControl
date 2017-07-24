//
//  SceneContentsViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/14.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneContentsViewController : UIViewController
@property (assign, nonatomic) NSInteger viewType;       //1预览场景 2开处方
@property (copy, nonatomic) NSArray *selectedArray;

@property (copy, nonatomic) void (^pickBlock)(NSArray *array);

@end
