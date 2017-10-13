//
//  DetailContentCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DetailContentCell.h"

@implementation DetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.linkButton.lineColor = NAVIGATIONBAR_COLOR;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)collectionClick:(id)sender {
    if (self.collectBlock) {
        self.collectBlock();
    }
}

@end
