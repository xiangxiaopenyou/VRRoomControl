//
//  SelectSexCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/31.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SelectSexCell.h"

@interface SelectSexCell ()

@end

@implementation SelectSexCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)maleAction:(id)sender {
    if (self.editable) {
        if (!self.maleButton.selected) {
            self.maleButton.selected = YES;
            self.femaleButton.selected = NO;
            if (self.block) {
                self.block(XJUserSexMale);
            }
        }
    }
    
}
- (IBAction)femaleAction:(id)sender {
    if (self.editable) {
        if (!self.femaleButton.selected) {
            self.femaleButton.selected = YES;
            self.maleButton.selected = NO;
            if (self.block) {
                self.block(XJUserSexFemale);
            }
        }
    }
}

@end
