//
//  XJPlanGridView.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanGridView.h"
@interface XJPlanGridView ()<UITableViewDataSource, UITableViewDelegate>
@property (assign, nonatomic) NSInteger times;
@property (assign, nonatomic) NSInteger scenesNumber;
@property (copy, nonatomic) NSArray *contentsArray;
@end

@implementation XJPlanGridView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setupContents:(NSInteger)times scenes:(NSInteger)scenesNumber contents:(NSArray *)contentsArray {
    _times = times;
    _scenesNumber = scenesNumber;
    _contentsArray = [contentsArray copy];
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
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(offsetX, 0, width, 50.f * (_times + 1)) style:UITableViewStylePlain];
        tableView.layer.borderWidth = 0.5;
        tableView.layer.borderColor = [[UIColor groupTableViewBackgroundColor] CGColor];
        tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        tableView.scrollEnabled = NO;
        tableView.tag = i;
        tableView.delegate = self;
        tableView.dataSource = self;
        [self addSubview:tableView];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _times + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"GridTableViewCell";
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
    UILabel *label = [[UILabel alloc] init];
    label.font = XJSystemFont(12);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByCharWrapping;
    label.textColor = [UIColor blackColor];
    [cell.contentView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_offset(UIEdgeInsetsMake(5, 5, 5, 5));
    }];
    if (tableView.tag == 0) {
        if (indexPath.row == 0) {
            label.text = @"次数";
        } else {
            label.text = [NSString stringWithFormat:@"%@", @(indexPath.row)];
        }
    } else {
        if (indexPath.row == 0) {
            label.text = nil;
        } else {
            NSInteger index = (indexPath.row - 1) * _scenesNumber + tableView.tag - 1;
            NSString *textString = [NSString stringWithFormat:@"%@", _contentsArray[index]];
            label.text = textString;
        }
    }
    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
