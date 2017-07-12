//
//  AdjustCycleView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/2.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ContentModel;

@interface AdjustCycleView : UIView

@property (copy, nonatomic) void (^submitBlock)(ContentModel *model);

- (void)show;
- (void)reloadContents:(ContentModel *)model;

@end
