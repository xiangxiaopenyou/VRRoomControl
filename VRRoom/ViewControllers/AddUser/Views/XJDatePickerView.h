//
//  XJDatePickerView.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJDatePickerView : UIView
@property (copy, nonatomic) void (^selectBlock)(NSString *dateString);
- (void)show;
- (void)selectDate:(NSString *)dateString;
@end
