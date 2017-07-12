//
//  XLCommonPickerView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/31.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^finishedBlock)(NSInteger index);

@interface XLCommonPickerView : UIView
@property (copy, nonatomic) finishedBlock block;

- (void)resetContents:(NSArray *)titlesArray selected:(NSInteger)index;
- (void)show;

@end
