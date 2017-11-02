//
//  XJPlanGridView.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanGridView.h"
#import "ContentModel.h"

@interface XJPlanGridView ()<UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) NSInteger times;
@property (assign, nonatomic) NSInteger scenesNumber;
@property (copy, nonatomic) NSArray *contentsArray;
@property (assign, nonatomic) BOOL canEdit;
@end

@implementation XJPlanGridView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setupContents:(NSInteger)times scenes:(NSInteger)scenesNumber contents:(NSArray *)contentsArray canEdit:(BOOL)canEdit {
    _times = times;
    _scenesNumber = scenesNumber;
    _contentsArray = [contentsArray copy];
    _canEdit = canEdit;
    [self setupViews];
}
- (void)setupViews {
    if (self.subviews.count > 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (NSInteger i = 0; i <= _scenesNumber; i ++) {
        CGFloat offsetX = 0;
        if (i > 0) {
            offsetX = 50.f + ((SCREEN_WIDTH - 50.f) / _scenesNumber) * (i - 1);
        }
        CGFloat width = (SCREEN_WIDTH - 50.f) / _scenesNumber;
        if (i == 0) {
            width = 50.f;
        }
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(offsetX, 0, width, 60.f * (_times + 1)) style:UITableViewStylePlain];
        tableView.layer.borderWidth = 0.5;
        tableView.layer.borderColor = BREAK_LINE_COLOR.CGColor;
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.separatorColor = BREAK_LINE_COLOR;
        tableView.scrollEnabled = NO;
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
    }
    self.frame = CGRectMake(0, 60, SCREEN_WIDTH, 60 * _times);
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _times;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"GridTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    if (tableView.tag == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    } else {
        cell.selectionStyle = self.canEdit ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
    }
    UILabel *label = [[UILabel alloc] init];
    label.font = XJSystemFont(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    if (tableView.tag == 0) {
        label.text = [NSString stringWithFormat:@"%@", @(indexPath.row + 1)];
    } else {
        NSInteger index =  indexPath.row * _scenesNumber + tableView.tag - 1;
//        NSDictionary *tempDictionary = _contentsArray[index];
        ContentModel *tempModel = _contentsArray[index];
        NSString *textString = [NSString stringWithFormat:@"%@", tempModel.name];
        label.text = textString;
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_canEdit) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        NSInteger index =  indexPath.row * _scenesNumber + tableView.tag - 1;
        if (self.delegate && [self.delegate respondsToSelector:@selector(gridViewDidClickCell:)]) {
            [self.delegate gridViewDidClickCell:index];
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
