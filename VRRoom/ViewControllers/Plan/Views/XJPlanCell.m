//
//  XJPlanCell.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanCell.h"
#import "XJPlanModel.h"
@interface XJPlanCell ()
@property (assign, nonatomic) BOOL isView;
@end

@implementation XJPlanCell
- (IBAction)selectAction:(id)sender {
    if (_isView) {
        self.selectButton.selected = !self.selectButton.selected;
    }
    if (self.selectBlock) {
        self.selectBlock(self.selectButton.selected);
    }
}
- (void)setupContents:(XJPlanModel *)model isView:(BOOL)isView {
    _isView = isView;
    if (isView) {
        [self.selectButton setImage:[UIImage imageNamed:@"content_collect"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"content_collected"] forState:UIControlStateSelected];
        if ([model.isCollected integerValue] == 0) {
            self.selectButton.selected = NO;
        } else {
            self.selectButton.selected = YES;
        }
    } else {
        [self.selectButton setImage:[UIImage imageNamed:@"content_select"] forState:UIControlStateNormal];
        [self.selectButton setImage:[UIImage imageNamed:@"content_isselect"] forState:UIControlStateSelected];
        self.selectButton.selected = NO;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
