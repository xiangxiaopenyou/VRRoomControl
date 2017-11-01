//
//  XJTopDiseasesCell.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/16.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJTopDiseasesCell.h"

@implementation XJTopDiseasesCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    if (selected) {
        self.contentLabel.textColor = NAVIGATIONBAR_COLOR;
    } else {
        self.contentLabel.textColor = [UIColor blackColor];
    }
    // Configure the view for the selected state
}

#pragma mark - Getters
- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = XJSystemFont(14);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _contentLabel;
}

@end
