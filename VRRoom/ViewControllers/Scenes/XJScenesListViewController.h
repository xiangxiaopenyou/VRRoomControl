//
//  XJScenesListViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/16.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;

@interface XJScenesListViewController : UIViewController
@property (assign, nonatomic) NSInteger viewType;
@property (copy, nonatomic) void (^chooseSceneBlock)(ContentModel *model);

@end
