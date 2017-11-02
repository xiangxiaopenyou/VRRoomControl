//
//  SceneContentCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SceneContentCell.h"
#import "ContentModel.h"

#import <UIImageView+WebCache.h>

@interface SceneContentCell ()
@property (nonatomic) NSInteger viewType;
@end

@implementation SceneContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setupContents:(ContentModel *)model viewType:(NSInteger)type {
    _viewType = type;
    if (type == 1) {
        [self.operationButton setImage:[UIImage imageNamed:@"content_collect"] forState:UIControlStateNormal];
        [self.operationButton setImage:[UIImage imageNamed:@"content_collected"] forState:UIControlStateSelected];
        if ([model.isCollected integerValue] == 0) {
            self.operationButton.selected = NO;
        } else {
            self.operationButton.selected = YES;
        }
    } else {
        [self.operationButton setImage:[UIImage imageNamed:@"content_select"] forState:UIControlStateNormal];
//        if ([model.isAdded integerValue] == 0) {
//            self.operationButton.selected = NO;
//        } else {
//            self.operationButton.selected = YES;
//        }
    }
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:model.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
    self.contentNameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    self.clickNumberLabel.text = [NSString stringWithFormat:@"点击量:%@", @(model.clicks.integerValue)];
    if ([model.type integerValue] == 1 || [model.type integerValue] == 2) {
        self.durationLabel.hidden = NO;
    } else {
        self.durationLabel.hidden = YES;
    }
    self.durationLabel.text = [NSString stringWithFormat:@"时长:%@分钟", model.duration];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%.2f", [model.price floatValue]];
}
- (IBAction)operationAction:(id)sender {
    if (_viewType == 1) {
        if (self.operationButton.selected) {
            self.operationButton.selected = NO;
            if (self.block) {
                self.block(NO);
            }
        } else {
            self.operationButton.selected = YES;
            if (self.block) {
                self.block(YES);
            }
        }
    } else {
        if (self.block) {
            self.block(YES);
        }
    }
    
}

@end
