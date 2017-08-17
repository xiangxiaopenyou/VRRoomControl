//
//  TitlesPickerView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TitlesModel;

typedef void (^finishedBlock)(TitlesModel *model);

@interface TitlesPickerView : UIView
@property (copy, nonatomic) finishedBlock block;

- (void)resetContents:(NSArray *)titlesArray selected:(TitlesModel *)model;
- (void)show;

@end
