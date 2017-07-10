//
//  XJMainItemsCell.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/10.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJMainItemsCell.h"
#import "CommonsDefines.h"

@implementation XJMainItemsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addButton.layer.borderWidth = 1;
    self.addButton.layer.borderColor = BREAK_LINE_COLOR.CGColor;
    self.searchButton.layer.borderWidth = 1;
    self.searchButton.layer.borderColor = BREAK_LINE_COLOR.CGColor;
    self.vrContentsButton.layer.borderWidth = 1;
    self.vrContentsButton.layer.borderColor = BREAK_LINE_COLOR.CGColor;
    self.helpButton.layer.borderWidth = 1;
    self.helpButton.layer.borderColor = BREAK_LINE_COLOR.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
