//
//  PrescriptionContentsCell.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/20.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PrescriptionContentsCell.h"
#import "ContentsItemCell.h"
#import "AdjustCycleView.h"
#import "ContentModel.h"

#import "UtilDefine.h"

#import <GJCFUitils.h>
#import <UIImageView+AFNetworking.h>

@interface PrescriptionContentsCell ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) NSMutableArray *selectedContents;
@property (strong, nonatomic) AdjustCycleView *cycleView;
@end

@implementation PrescriptionContentsCell

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
- (IBAction)addContentAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickAddContent)]) {
        [self.delegate didClickAddContent];
    }
}
- (void)resetCycleAction:(UIButton *)button {
    [self.cycleView show];
    __block ContentModel *tempModel = self.selectedContents[button.tag - 1000];
    [self.cycleView reloadContents:tempModel];
    GJCFWeakSelf weakSelf = self;
    self.cycleView.submitBlock = ^(ContentModel *model) {
        tempModel = model;
        [weakSelf.selectedContents replaceObjectAtIndex:button.tag - 1000 withObject:tempModel];
        GJCFAsyncMainQueue(^{
            [weakSelf.contentTableView reloadData];
            if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(didSetContentCycle:)]) {
                [weakSelf.delegate didSetContentCycle:weakSelf.selectedContents];
            }
        });
    };
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedContents.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContentsItemCell";
    ContentsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ContentModel *tempModel = self.selectedContents[indexPath.row];
    [cell.contentImageView setImageWithURL:[NSURL URLWithString:tempModel.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
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
    cell.resetCycleButton.tag = 1000 + indexPath.row;
    [cell.resetCycleButton addTarget:self action:@selector(resetCycleAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.selectedContents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDeleteContent:)]) {
            [self.delegate didDeleteContent:self.selectedContents];
        }
    }
}

#pragma mark - Getters
- (NSMutableArray *)selectedContents {
    if (!_selectedContents) {
        _selectedContents = [[NSMutableArray alloc] init];
    }
    return _selectedContents;
}
- (AdjustCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[AdjustCycleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _cycleView;
}

@end
