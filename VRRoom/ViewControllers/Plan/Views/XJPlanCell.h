//
//  XJPlanCell.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XJPlanModel;

@interface XJPlanCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (copy, nonatomic) void (^selectBlock)(BOOL isSelected);

- (void)setupContents:(XJPlanModel *)model isView:(NSInteger)isView;

@end
