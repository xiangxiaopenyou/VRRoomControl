//
//  DepartmentSelectCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "DepartmentSelectCell.h"
#import "CommonsDefines.h"

@implementation DepartmentSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
    self.selectedBackgroundView.backgroundColor = MAIN_BACKGROUND_COLOR;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.departmentNameLabel.textColor = selected ? NAVIGATIONBAR_COLOR : MAIN_TEXT_COLOR;
    // Configure the view for the selected state
}

@end
