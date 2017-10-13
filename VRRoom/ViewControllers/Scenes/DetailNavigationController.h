//
//  DetailNavigationController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/24.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;

@interface DetailNavigationController : UINavigationController
@property (strong, nonatomic) ContentModel *contentModel;

@end
