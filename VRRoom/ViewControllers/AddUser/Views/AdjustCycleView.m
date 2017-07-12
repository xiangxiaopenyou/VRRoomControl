//
//  AdjustCycleView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/2.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AdjustCycleView.h"
#import "ContentModel.h"

#import <UIImage-Helpers.h>

@interface AdjustCycleView ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UIView *contentView;
@property (strong, nonatomic) UITableView *unitTableView;
@property (strong, nonatomic) UITextField *timesTextField;
@property (strong, nonatomic) UITextField *periodTextField;
@property (strong, nonatomic) UILabel *unitLabel;
@property (strong, nonatomic) UILabel *countTimesLabel;
@property (strong, nonatomic) UIButton *closeButton;
@property (strong, nonatomic) UIButton *submitButton;
@property (strong, nonatomic) UIImageView *selectArrow;
@property (assign, nonatomic) BOOL isOpen;
@property (assign, nonatomic) NSInteger selectedUnit;
@property (copy, nonatomic) NSArray *unitArray;

@property (strong, nonatomic) ContentModel *model;

@end

@implementation AdjustCycleView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        //[self addSubview:self.contentView];
        
        [self.contentView addSubview:self.closeButton];
        [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(50, 50));
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.font = XJSystemFont(18);
        titleLabel.textColor = XJHexRGBColorWithAlpha(0x0865b3, 1);
        titleLabel.text = @"填写治疗周期";
        [self.contentView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.contentView.mas_top).with.mas_offset(16);
        }];
        
        UILabel *perTimes = [[UILabel alloc] init];
        perTimes.font = XJSystemFont(16);
        perTimes.textColor = MAIN_TEXT_COLOR;
        perTimes.text = @"次/";
        [self.contentView addSubview:perTimes];
        [perTimes mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(titleLabel.mas_bottom).with.mas_offset(26);
        }];
        
        [self.contentView addSubview:self.timesTextField];
        [self.timesTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(perTimes.mas_leading).with.mas_offset(- 25);
            make.top.equalTo(titleLabel.mas_bottom).with.mas_offset(20);
            make.size.mas_offset(CGSizeMake(75, 35));
        }];
        
        [self.contentView addSubview:self.unitTableView];
        [self.unitTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(perTimes.mas_trailing).with.mas_offset(25);
            make.top.equalTo(titleLabel.mas_bottom).with.mas_offset(20);
            make.size.mas_offset(CGSizeMake(75, 35));
        }];
        
        [self.contentView addSubview:self.submitButton];
        [self.submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.trailing.bottom.equalTo(self.contentView);
            make.height.mas_offset(45);
        }];
        
        UILabel *line = [[UILabel alloc] init];
        line.backgroundColor = BREAK_LINE_COLOR;
        [self.contentView addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.submitButton.mas_top);
            make.leading.trailing.equalTo(self.contentView);
            make.height.mas_offset(0.5);
        }];
        
        [self.contentView addSubview:self.countTimesLabel];
        [self.countTimesLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(line.mas_top).with.mas_offset(- 35);
            make.centerX.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(75, 28));
        }];
        
        UILabel *label1 = [[UILabel alloc] init];
        label1.textColor = MAIN_TEXT_COLOR;
        label1.font = XJSystemFont(16);
        label1.text = @"共";
        [self.contentView addSubview:label1];
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self.countTimesLabel.mas_leading).with.mas_offset(- 20);
            make.bottom.equalTo(line.mas_top).with.mas_offset(- 37);
        }];
        
        UILabel *label2 = [[UILabel alloc] init];
        label2.textColor = MAIN_TEXT_COLOR;
        label2.font = XJSystemFont(16);
        label2.text = @"次";
        [self.contentView addSubview:label2];
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(line.mas_top).with.mas_offset(- 37);
            make.leading.equalTo(self.countTimesLabel.mas_trailing).with.mas_offset(20);
        }];
        
        [self.contentView addSubview:self.periodTextField];
        [self.periodTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.countTimesLabel.mas_top).with.mas_offset(- 25);
            make.centerX.equalTo(self.contentView);
            make.size.mas_offset(CGSizeMake(75, 35));
        }];
        
        UILabel *label3 = [[UILabel alloc] init];
        label3.textColor = MAIN_TEXT_COLOR;
        label3.font = XJSystemFont(16);
        label3.text = @"共";
        [self.contentView addSubview:label3];
        [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.countTimesLabel.mas_top).with.mas_offset(- 31);
            make.trailing.equalTo(self.periodTextField.mas_leading).with.mas_offset(- 20);
        }];
        
        [self.contentView addSubview:self.unitLabel];
        [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.countTimesLabel.mas_top).with.mas_offset(- 31);
            make.leading.equalTo(self.periodTextField.mas_trailing).with.mas_offset(20);
        }];
    }
    return self;
}

- (void)reloadContents:(ContentModel *)model {
    self.model = model;
    self.timesTextField.text = [model.frequency integerValue] > 0 ? [NSString stringWithFormat:@"%@", model.frequency] : nil;
    self.selectedUnit = 1;
    if ([model.periodUnit integerValue] > 0) {
        switch ([model.periodUnit integerValue]) {
            case 1:
                self.selectedUnit = 1;
                break;
            case 2:
                self.selectedUnit = 2;
                break;
            case 3:
                self.selectedUnit = 3;
                break;
            default:
                break;
        }
    }
    self.periodTextField.text = [model.period integerValue] > 0 ? [NSString stringWithFormat:@"%@", model.period] : nil;
    if ([model.frequency integerValue] > 0 && [model.period integerValue] > 0) {
        NSInteger countTimes = [model.frequency integerValue] * [model.period integerValue];
        self.countTimesLabel.text = [NSString stringWithFormat:@"%@", @(countTimes)];
    } else {
        self.countTimesLabel.text = nil;
    }
    [self refreshUnit];
    [self refreshCountTimes];
    [self textDidChanged:nil];
    [self.unitTableView reloadData];
}
- (void)refreshUnit {
    NSString *unitString = @"日";
    switch (_selectedUnit) {
        case 1:
            unitString = @"日";
            break;
        case 2:
            unitString = @"周";
            break;
        case 3:
            unitString = @"月";
        default:
            break;
    }
    self.unitLabel.text = unitString;
}
- (void)refreshCountTimes {
    if ([self.timesTextField.text integerValue] > 0 && [self.periodTextField.text integerValue] > 0) {
        NSInteger count = [self.timesTextField.text integerValue] * [self.periodTextField.text integerValue];
        self.countTimesLabel.text = [NSString stringWithFormat:@"%@", @(count)];
    } else {
        self.countTimesLabel.text = nil;
    }
}

- (void)show {
    self.alpha = 1.0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self addSubview:self.contentView];
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:popAnimation forKey:nil];
}
- (void)dismiss {
    [_timesTextField resignFirstResponder];
    [_periodTextField resignFirstResponder];
    [UIView animateWithDuration:0.4 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    CAKeyframeAnimation *hideAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    hideAnimation.duration = 0.4;
    hideAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0f, 1.0f, 1.0f)],
                             [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.00f, 0.00f, 0.00f)]];
    hideAnimation.keyTimes = @[@0.2f, @0.5f, @0.75f];
    hideAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                      [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.contentView.layer addAnimation:hideAnimation forKey:nil];
}
- (void)submitAction {
    self.model.frequency = @([self.timesTextField.text integerValue]);
    self.model.periodUnit = @(self.selectedUnit);
    self.model.period = @([self.periodTextField.text integerValue]);
    if (self.submitBlock) {
        self.submitBlock(self.model);
    }
    [self dismiss];
}
- (void)textDidChanged:(UITextField *)textField {
    if ([self.timesTextField.text integerValue] > 0 && [self.periodTextField.text integerValue] > 0) {
        self.submitButton.enabled = YES;
        [self.submitButton setTitleColor:XJHexRGBColorWithAlpha(0x0865b3, 1) forState:UIControlStateNormal];
    } else {
        self.submitButton.enabled = NO;
        [self.submitButton setTitleColor:BREAK_LINE_COLOR forState:UIControlStateNormal];
    }
    [self refreshCountTimes];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(25, SCREEN_HEIGHT / 2.0 - 200 - SCREEN_HEIGHT * 0.1, SCREEN_WIDTH - 50, 360);
    }];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [UIView animateWithDuration:0.2 animations:^{
        self.contentView.frame = CGRectMake(25, SCREEN_HEIGHT / 2.0 - 200, SCREEN_WIDTH - 50, 360);
    }];
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _isOpen ? 4 : 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 35.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.separatorInset = UIEdgeInsetsZero;
    UILabel *selectUnitLabel = [[UILabel alloc] init];
    selectUnitLabel.font = XJSystemFont(16);
    selectUnitLabel.textColor = MAIN_TEXT_COLOR;
    [cell.contentView addSubview:selectUnitLabel];
    [selectUnitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.contentView);
        make.centerX.equalTo(cell.contentView).with.mas_offset(- 10);
    }];
    if (indexPath.row == 0) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.selectArrow];
        [self.selectArrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(selectUnitLabel.mas_trailing).with.mas_offset(5);
            make.centerY.equalTo(cell.contentView);
            make.size.mas_offset(CGSizeMake(17, 17));
        }];
        self.selectArrow.image = _isOpen ? [UIImage imageNamed:@"drop_up"] : [UIImage imageNamed:@"drop_down"];
        NSString *unitString = @"日";
        switch (_selectedUnit) {
            case 1:
                unitString = @"日";
                break;
            case 2:
                unitString = @"周";
                break;
            case 3:
                unitString = @"月";
            default:
                break;
        }
        selectUnitLabel.text = unitString;
    } else {
        selectUnitLabel.text = self.unitArray[indexPath.row - 1];
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        if (_isOpen) {
            _isOpen = NO;
            [self.unitTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(75, 35));
            }];
        } else {
            _isOpen = YES;
            [self.unitTableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_offset(CGSizeMake(75, 140));
            }];
        }
    } else {
        self.selectedUnit = indexPath.row;
        _isOpen = NO;
        [self.unitTableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(75, 35));
        }];
        [self refreshUnit];
    }
    [tableView reloadData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Getters
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(25, SCREEN_HEIGHT / 2.0 - 200, SCREEN_WIDTH - 50, 360)];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.clipsToBounds = YES;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 5.0;
    }
    return _contentView;
}
- (UITableView *)unitTableView {
    if (!_unitTableView) {
        _unitTableView = [[UITableView alloc] init];
        _unitTableView.delegate = self;
        _unitTableView.dataSource = self;
        _unitTableView.separatorColor = BREAK_LINE_COLOR;
        _unitTableView.layer.masksToBounds = YES;
        _unitTableView.layer.cornerRadius = 5.0;
        _unitTableView.layer.borderWidth = 0.5;
        _unitTableView.layer.borderColor = BREAK_LINE_COLOR.CGColor;
        _unitTableView.bounces = NO;
    }
    return _unitTableView;
}
- (UITextField *)timesTextField {
    if (!_timesTextField) {
        _timesTextField = [[UITextField alloc] init];
        _timesTextField.delegate = self;
        _timesTextField.font = XJSystemFont(16);
        _timesTextField.textColor = MAIN_TEXT_COLOR;
        _timesTextField.textAlignment = NSTextAlignmentCenter;
        _timesTextField.keyboardType = UIKeyboardTypeNumberPad;
        _timesTextField.layer.masksToBounds = YES;
        _timesTextField.layer.cornerRadius = 5.0;
        _timesTextField.layer.borderWidth = 0.5;
        _timesTextField.layer.borderColor = BREAK_LINE_COLOR.CGColor;
        [_timesTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _timesTextField;
}
- (UITextField *)periodTextField {
    if (!_periodTextField) {
        _periodTextField = [[UITextField alloc] init];
        _periodTextField.delegate = self;
        _periodTextField.font = XJSystemFont(16);
        _periodTextField.textColor = MAIN_TEXT_COLOR;
        _periodTextField.textAlignment = NSTextAlignmentCenter;
        _periodTextField.keyboardType = UIKeyboardTypeNumberPad;
        _periodTextField.layer.masksToBounds = YES;
        _periodTextField.layer.cornerRadius = 5.0;
        _periodTextField.layer.borderWidth = 0.5;
        _periodTextField.layer.borderColor = BREAK_LINE_COLOR.CGColor;
        [_periodTextField addTarget:self action:@selector(textDidChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _periodTextField;
}
- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [[UILabel alloc] init];
        _unitLabel.font = XJSystemFont(16);
        _unitLabel.textColor = MAIN_TEXT_COLOR;
        _unitLabel.text = @"日";
    }
    return _unitLabel;
}
- (UILabel *)countTimesLabel {
    if (!_countTimesLabel) {
        _countTimesLabel = [[UILabel alloc] init];
        _countTimesLabel.font = XJSystemFont(16);
        _countTimesLabel.textColor = MAIN_TEXT_COLOR;
        _countTimesLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _countTimesLabel;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"close_cycle"] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_submitButton setTitleColor:BREAK_LINE_COLOR forState:UIControlStateNormal];
        [_submitButton setTitle:@"确认" forState:UIControlStateNormal];
        _submitButton.titleLabel.font = XJSystemFont(16);
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
        [_submitButton setBackgroundImage:[UIImage imageWithColor:BREAK_LINE_COLOR] forState:UIControlStateHighlighted];
        _submitButton.enabled = NO;
    }
    return _submitButton;
}
- (UIImageView *)selectArrow {
    if (!_selectArrow) {
        _selectArrow = [[UIImageView alloc] init];
        _selectArrow.image = [UIImage imageNamed:@"drop_down"];
    }
    return _selectArrow;
}
- (NSArray *)unitArray {
    if (!_unitArray) {
        _unitArray = [NSArray arrayWithObjects:@"日", @"周", @"月", nil];
    }
    return _unitArray;
}
@end
