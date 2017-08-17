//
//  SelectCityView.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/28.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CitiesModel;

@interface SelectCityView : UIView
@property (copy, nonatomic) void (^selectBlock)(CitiesModel *selectedCity);
- (void)resetContents:(NSArray *)array selectedCity:(CitiesModel *)selectedCity;

@end
