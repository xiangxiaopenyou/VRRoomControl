//
//  AuthenticationPicturesViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InformationModel;

@interface AuthenticationPicturesViewController : UIViewController
@property (strong, nonatomic) InformationModel *informationModel;

@property (nonatomic) BOOL editable;

@end
