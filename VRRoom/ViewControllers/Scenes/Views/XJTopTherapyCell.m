//
//  XJTopTherapyCell.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/16.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJTopTherapyCell.h"

#import <UIImage-Helpers.h>

@implementation XJTopTherapyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentButton];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    if (selected) {
        [_contentButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        _contentButton.layer.borderColor = NAVIGATIONBAR_COLOR.CGColor;
    } else {
        [_contentButton setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[UIImage imageWithColor:MAIN_BACKGROUND_COLOR] forState:UIControlStateNormal];
        _contentButton.layer.borderColor = XJHexRGBColorWithAlpha(0x999999, 1).CGColor;
    }
}

#pragma mark - Getter
- (UIButton *)contentButton {
    if (!_contentButton) {
        _contentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _contentButton.titleLabel.font = XJSystemFont(13);
        [_contentButton setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        [_contentButton setBackgroundImage:[UIImage imageWithColor:MAIN_BACKGROUND_COLOR] forState:UIControlStateNormal];
        _contentButton.layer.masksToBounds = YES;
        _contentButton.layer.cornerRadius = 5.0;
        _contentButton.layer.borderWidth = 0.5;
        _contentButton.layer.borderColor = XJHexRGBColorWithAlpha(0x999999, 1).CGColor;
        _contentButton.enabled = NO;
    }
    return _contentButton;
}

@end
