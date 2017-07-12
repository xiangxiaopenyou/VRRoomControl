//
//  XJDiseasePickerView.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DiseaseModel;

@interface XJDiseasePickerView : UIView
@property (copy, nonatomic) void (^selectBlock)(DiseaseModel *model);

- (void)addData:(NSArray *)dataArray;
- (void)show;

@end
