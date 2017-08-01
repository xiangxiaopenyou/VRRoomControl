//
//  PrescriptionDetailContentCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/15.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PrescriptionDetailContentCell.h"
#import "DetailContentItemCell.h"
#import "ContentModel.h"
#import <UIImageView+WebCache.h>

@interface PrescriptionDetailContentCell ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *selectedContents;
@end

@implementation PrescriptionDetailContentCell
- (void)resetContents:(NSArray *)contents {
    self.selectedContents = [contents mutableCopy];
    [self.contentTableView reloadData];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedContents.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"DetailContentItemCell";
    DetailContentItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ContentModel *tempModel = self.selectedContents[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.contentNameLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    cell.contentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [tempModel.price floatValue]];
    if (tempModel.frequency.integerValue > 0) {
        cell.contentCycleLabel.hidden = NO;
        NSString *unit = @"日";
        switch ([tempModel.periodUnit integerValue]) {
            case 1:
                unit = @"日";
                break;
            case 2:
                unit = @"周";
                break;
            case 3:
                unit = @"月";
                break;
            default:
                break;
        }
        NSInteger count = tempModel.frequency.integerValue * tempModel.period.integerValue;
        cell.contentCycleLabel.text = [NSString stringWithFormat:@"%@次/%@-共%@%@-共%@次", tempModel.frequency, unit, tempModel.period, unit, @(count)];
    } else {
        cell.contentCycleLabel.hidden = YES;
    }
    if ([tempModel.useTimes integerValue] > 0) {
        cell.usedTimesLabel.text = [NSString stringWithFormat:@"已使用%@次", tempModel.useTimes];
    } else {
        cell.usedTimesLabel.text = @"未使用";
    }
    return cell;
}

#pragma mark - Getters
- (NSMutableArray *)selectedContents {
    if (!_selectedContents) {
        _selectedContents = [[NSMutableArray alloc] init];
    }
    return _selectedContents;
}

@end
