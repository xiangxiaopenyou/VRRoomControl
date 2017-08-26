//
//  SceneContentsListViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiseaseModel;
@class TherapyModel;

@interface SceneContentsListViewController : UIViewController

@property (strong, nonatomic) DiseaseModel *diseaseModel;
@property (strong, nonatomic) TherapyModel *therapyModel;
@property (copy, nonatomic) NSString *keyword;
@property (assign, nonatomic) NSInteger viewType;
@property (strong, nonatomic) NSMutableArray *selectedContents;

@property (assign, nonatomic) BOOL isCollectionView;
@property (assign, nonatomic) BOOL isAddPlan;

@property (copy, nonatomic) void (^selectedBlock)(NSArray *array);

@end
