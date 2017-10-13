//
//  XJDatePickerView.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJDatePickerView.h"
@interface XJDatePickerView ()
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIButton *cancelButton;
@end

@implementation XJDatePickerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        
        [self addSubview:self.contentView];
        [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.mas_bottom).with.mas_offset(250);
            make.height.mas_offset(250);
        }];
        
        UIButton *backgroundButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [backgroundButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        [backgroundButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.trailing.equalTo(self);
            make.bottom.equalTo(self.contentView.mas_top);
        }];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = NAVIGATIONBAR_COLOR;
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.trailing.equalTo(self.contentView);
            make.height.mas_offset(0.5);
        }];
        
        [self.contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.trailing.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(60, 35));
        }];
        [self.contentView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(60, 35));
        }];
        
        [self.contentView addSubview:self.datePicker];
        [self.datePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.mas_offset(216);
        }];
        self.hidden = YES;
    }
    return self;
}

#pragma mark - Action
- (void)submitAction {
    NSDate *selectedDate = self.datePicker.date;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:selectedDate];
    if (self.selectBlock) {
        self.selectBlock(dateString);
    }
    [self dismiss];
}
- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
        }];
        [self layoutIfNeeded];
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.2 animations:^{
        [self.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.mas_offset(285);
        }];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)selectDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [self.datePicker setDate:[dateFormatter dateFromString:dateString]];
}

#pragma mark - Getters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
    }
    return _contentView;
}
- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        _datePicker.minimumDate = [dateFormatter dateFromString:@"1900-01-01"];
        NSDate *nowDate = [NSDate date];
        _datePicker.maximumDate = nowDate;
        [_datePicker setDate:[dateFormatter dateFromString:@"1990-01-01"]];
    }
    return _datePicker;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        _submitButton.titleLabel.font = XJSystemFont(14);
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:MAIN_TEXT_COLOR forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = XJSystemFont(14);
        [_cancelButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
