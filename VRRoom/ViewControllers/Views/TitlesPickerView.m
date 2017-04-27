//
//  TitlesPickerView.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "TitlesPickerView.h"
#import "ManagerModel.h"

#import "UtilDefine.h"

#import <Masonry.h>

@interface TitlesPickerView ()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (strong, nonatomic) UIView *bottomView;
@property (strong, nonatomic) UIPickerView *pickerView;
@property (strong, nonatomic) UIButton *cancelButton;
@property (strong, nonatomic) UIButton *finishButton;

@property (copy, nonatomic) NSArray *array;
@property (strong, nonatomic) ManagerModel *selectedModel;
@end

@implementation TitlesPickerView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bottomView];
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 250);
        [self.bottomView addSubview:self.pickerView];
        [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.leading.trailing.equalTo(self);
            make.top.equalTo(self.bottomView.mas_top).with.mas_offset(34);
        }];
        [self.bottomView addSubview:self.finishButton];
        [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.top.equalTo(self.bottomView);
            make.bottom.equalTo(self.pickerView.mas_top);
            make.width.mas_offset(60);
        }];
        
        [self.bottomView addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.top.equalTo(self.bottomView);
            make.bottom.equalTo(self.pickerView.mas_top);
            make.width.mas_offset(60);
        }];
        self.userInteractionEnabled = YES;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAction)]];
        self.hidden = YES;
    }
    return self;
}
- (void)resetContents:(NSArray *)titlesArray selected:(ManagerModel *)model {
    if (titlesArray) {
        _array = titlesArray;
    }
    if (model) {
        _selectedModel = model;
    }
    [self.pickerView reloadAllComponents];
    [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ManagerModel *tempModel = (ManagerModel *)obj;
        if ([tempModel.id isEqualToString:_selectedModel.id]) {
            [self.pickerView selectRow:idx inComponent:0 animated:NO];
        }
    }];
}
- (void)dismissAction {
    [UIView animateWithDuration:0.2 animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 64, SCREEN_WIDTH, 250);
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}
- (void)show {
    self.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.bottomView.frame = CGRectMake(0, SCREEN_HEIGHT - 314, SCREEN_WIDTH, 250);
    }];
}
- (void)finishAction {
    if (self.block) {
        self.block(_selectedModel);
    }
    [self dismissAction];
}

#pragma mark - UIPickerViewDelegate DataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _array.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    ManagerModel *tempModel = _array[row];
    return tempModel.user_username;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    _selectedModel = _array[row];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}
- (UIButton *)finishButton {
    if (!_finishButton) {
        _finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_finishButton setTitle:@"播放" forState:UIControlStateNormal];
        [_finishButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        _finishButton.titleLabel.font = kSystemFont(16);
        [_finishButton addTarget:self action:@selector(finishAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:kRGBColor(100, 100, 100, 1) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = kSystemFont(16);
        [_cancelButton addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
