//
//  PrescriptionCell.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "PrescriptionCell.h"

@implementation PrescriptionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.endButton.layer.masksToBounds = YES;
    self.endButton.layer.cornerRadius = 12.5f;
    self.endButton.layer.borderWidth = 1.f;
    self.endButton.layer.borderColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)endAction:(id)sender {
    if (self.block) {
        self.block();
    }
}

@end
