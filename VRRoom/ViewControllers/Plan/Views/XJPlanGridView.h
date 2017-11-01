//
//  XJPlanGridView.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJPlanGridView : UIView

- (void)setupContents:(NSInteger)times scenes:(NSInteger)scenesNumber contents:(NSArray *)contentsArray canEdit:(BOOL)canEdit;

@end
