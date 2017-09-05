//
//  AuthenticationInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationInformationViewController.h"
//#import "EditInformationViewController.h"
#import "AuthenticationPicturesViewController.h"

#import "AuthenticationContentCell.h"
#import "SelectSexCell.h"
#import "SelectCityView.h"
#import "TitlesPickerView.h"

#import "ProvincesModel.h"
#import "CitiesModel.h"
#import "TitlesModel.h"
#import "InformationModel.h"


@interface AuthenticationInformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet UIImageView *tipImageView;
@property (weak, nonatomic) IBOutlet UILabel *failureReasonLabel;
@property (strong, nonatomic) UIButton *hospitalButton;
@property (strong, nonatomic) UIButton *clinicButton;
@property (strong, nonatomic) SelectCityView *cityView;
@property (strong, nonatomic) TitlesPickerView *titlesPickerView;

@property (assign, nonatomic) BOOL isHospital;
@property (assign, nonatomic) XJUserSex sex;
@property (copy, nonatomic) NSArray *headTitleArray;
@property (copy, nonatomic) NSArray *areasArray;
@property (copy, nonatomic) NSArray *professionalTitlesArray;   //职称数组
@property (strong, nonatomic) InformationModel *model;

@property (nonatomic) BOOL editable;

@end

@implementation AuthenticationInformationViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = self.footerView;
    self.footerView.hidden = YES;
    _sex = XJUserSexMale;
    _isHospital = YES;
    [self checkTitleArray:_isHospital];
    [self fetchInformations];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[UIApplication sharedApplication].keyWindow addSubview:self.cityView];
    GJCFWeakSelf weakSelf = self;
    self.cityView.selectBlock = ^(CitiesModel *selectedCity) {
        GJCFStrongSelf strongSelf = weakSelf;
        [UIView animateWithDuration:0.3 animations:^{
            strongSelf.cityView.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        }];
        if (selectedCity) {
            strongSelf.model.region = selectedCity.code;
            strongSelf.model.regionFullName = selectedCity.fullName;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [self.view addSubview:self.titlesPickerView];
    self.titlesPickerView.block = ^(TitlesModel *model) {
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            strongSelf.model.professionalTitle = model.name;
            strongSelf.model.professionalTitleId = model.titleId;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.cityView removeFromSuperview];
    [self.titlesPickerView removeFromSuperview];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods
- (void)checkTitleArray:(BOOL)seleted {
    if (seleted) {
        _headTitleArray = @[@"姓  名", @"性  别", @"城  市", @"职  称", @"医  院", @"科  室"];
    } else {
        _headTitleArray = @[@"姓  名", @"性  别", @"城  市", @"职  称", @"诊  所", @"职  位"];
    }
}
//信息是否能编辑
- (void)checkEditable {
    if (!self.model.status || [self.model.status integerValue] == 1 || [self.model.status integerValue] == 3) {
        _editable = YES;
        self.submitButton.hidden = NO;
    } else {
        _editable = NO;
        self.submitButton.hidden = YES;
    }
    [self resetTipView];
}
- (void)resetTipView {
    if (!self.model.status || [self.model.status integerValue] == 1) {
        self.footerView.hidden = YES;
    } else {
        self.footerView.hidden = NO;
        if ([self.model.status integerValue] == 2) {
            self.tipImageView.image = [UIImage imageNamed:@"authentication_waiting"];
            self.failureReasonLabel.textColor = XJRGBColor(67, 175, 61, 1);
            self.failureReasonLabel.text = @"您的信息已提交，请耐心等待审核";
        } else if ([self.model.status integerValue] == 3) {
            self.tipImageView.image = [UIImage imageNamed:@"authentication_failure"];
            self.failureReasonLabel.textColor = XJRGBColor(225, 80, 41, 1);
            NSString *failureString = @"请修改信息后重新提交审核";
            if (!XLIsNullObject(self.model.remark)) {
                failureString = [NSString stringWithFormat:@"%@,%@", self.model.remark, failureString];
            }
            self.failureReasonLabel.text = failureString;
        } else {
            self.tipImageView.image = [UIImage imageNamed:@"authentication_success"];
            self.failureReasonLabel.textColor = NAVIGATIONBAR_COLOR;
            self.failureReasonLabel.text = @"您已通过审核";
        }
    }
}
- (void)refreshData {
    [self checkTitleArray:_isHospital];
    [self.tableView reloadData];
}
- (BOOL)checkIsCanUpload {
    if (XLIsNullObject(self.model.realname)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入您的真实姓名");
        return NO;
    }
    if (XLIsNullObject(self.model.region)) {
        XLDismissHUD(self.view, YES, NO, @"请先选择您所在城市");
        return NO;
    }
    if (XLIsNullObject(self.model.professionalTitleId)) {
        XLDismissHUD(self.view, YES, NO, @"请先选择您的职称");
        return NO;
    }
    if (_isHospital) {
        if (XLIsNullObject(self.model.hospital)) {
            XLDismissHUD(self.view, YES, NO, @"请先输入您所在医院名称");
            return NO;
        }
        if (XLIsNullObject(self.model.department)) {
            XLDismissHUD(self.view, YES, NO, @"请先输入您所属科室");
            return NO;
        }
    } else {
        if (XLIsNullObject(self.model.hospital)) {
            XLDismissHUD(self.view, YES, NO, @"请先输入您所在诊所名称");
            return NO;
        }
        if (XLIsNullObject(self.model.position)) {
            XLDismissHUD(self.view, YES, NO, @"请先输入您的职位");
            return NO;
        }
    }

    return YES;
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshInformations {
    self.sex = XLIsNullObject(self.model.gender) ? XJUserSexMale : [self.model.gender integerValue];
    if (XLIsNullObject(self.model.workplaceType)) {
        _isHospital = YES;
    } else {
        _isHospital = [self.model.workplaceType integerValue] == 1 ? YES : NO;
    }
    [self checkTitleArray:_isHospital];
    [self.tableView reloadData];
    [self fetchCities];
    [self fetchTitles];
    
}

#pragma mark - Request
//获取认证消息
- (void)fetchInformations {
    [InformationModel fetchInformations:^(id object, NSString *msg) {
        if (msg) {
            XLDismissHUD(self.view, YES, NO, msg);
        } else {
            self.model = (InformationModel *)object;
            [self checkEditable];
            [self refreshInformations];
        }
    }];
}

//提交认证信息
- (void)uploadInformations {
    self.model.gender = @(self.sex);
    self.model.workplaceType = _isHospital ? @1 : @2;
    AuthenticationPicturesViewController *picturesController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthenticationPictures"];
    picturesController.informationModel = self.model;
    picturesController.editable = _editable;
    [self.navigationController pushViewController:picturesController animated:YES];
}
//获取城市列表
- (void)fetchCities {
    [ProvincesModel fetchAreas:^(id object, NSString *msg) {
        if (object) {
            self.areasArray = [object copy];
            CitiesModel *tempModel = [[CitiesModel alloc] init];
            tempModel.code = self.model.region;
            tempModel.fullName = self.model.regionFullName;
            [self.cityView resetContents:self.areasArray selectedCity:tempModel];
        }
    }];
}
//获取职称
- (void)fetchTitles {
    [TitlesModel professionalTitles:^(id object, NSString *msg) {
        if (object) {
            self.professionalTitlesArray = [object copy];
            TitlesModel *tempModel = [[TitlesModel alloc] init];
            tempModel.titleId = self.model.professionalTitleId;
            tempModel.name = self.model.professionalTitle;
            [self.titlesPickerView resetContents:self.professionalTitlesArray selected:tempModel];
        }
    }];
}

#pragma mark - IBAction
- (IBAction)submitAction:(id)sender {
    if ([self checkIsCanUpload]) {
        [self uploadInformations];
    }
    
}
- (void)hospitalAction {
    if (_editable) {
        if (!self.hospitalButton.selected) {
            self.hospitalButton.selected = YES;
            self.clinicButton.selected = NO;
            _isHospital = YES;
            [self refreshData];
        }
    }
}
- (void)clinicAction {
    if (_editable) {
        if (!self.clinicButton.selected) {
            self.hospitalButton.selected = NO;
            self.clinicButton.selected = YES;
            _isHospital = NO;
            [self refreshData];
        }
    }
}

#pragma mark - UITextField
- (void)textChanged:(UITextField *)textField {
    if (textField.tag == 100) {
        self.model.realname = textField.text;
    } else {
        if (_isHospital) {
            if (textField.tag == 110) {
                self.model.hospital = textField.text;
            } else if (textField.tag == 111) {
                self.model.department = textField.text;
            }
        } else {
            if (textField.tag == 110) {
                self.model.hospital = textField.text;
            } else if (textField.tag == 111) {
                self.model.position = textField.text;
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 4 : 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AuthenticationContent";
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: {
                AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.headLabel.text = _headTitleArray[indexPath.row];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.contentTextField.placeholder = @"必输";
                cell.contentTextField.tag = 100;
                [cell.contentTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
                cell.contentTextField.text = self.model.realname;
                cell.contentTextField.enabled = _editable ? YES : NO;
                return cell;
            }
                break;
            case 1:{
                static NSString *identifier = @"SelectSex";
                SelectSexCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.editable = _editable;
                if (self.sex == XJUserSexMale) {
                    cell.maleButton.selected = YES;
                    cell.femaleButton.selected = NO;
                } else {
                    cell.maleButton.selected = NO;
                    cell.femaleButton.selected = YES;
                }
                cell.block = ^(XJUserSex userSex) {
                    self.sex = userSex;
                };
                return cell;
            }
                break;
            case 2:{
                AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.accessoryType = _editable ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
                cell.selectionStyle = _editable ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
                cell.headLabel.text = _headTitleArray[indexPath.row];
                cell.contentTextField.enabled = NO;
                cell.contentTextField.placeholder = @"必选";
                if (!XLIsNullObject(self.model.region)) {
                    cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.model.regionFullName];
                }
                return cell;
            }
                break;
            case 3:{
                AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.accessoryType = _editable ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
                cell.selectionStyle = _editable ? UITableViewCellSelectionStyleDefault : UITableViewCellSelectionStyleNone;
                cell.headLabel.text = _headTitleArray[indexPath.row];
                cell.contentTextField.enabled = NO;
                cell.contentTextField.placeholder = @"必选";
                if (!XLIsNullObject(self.model.professionalTitleId)) {
                    cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.model.professionalTitle];
                }
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    } else {
        AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.headLabel.text = _headTitleArray[indexPath.row + 4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentTextField.tag = 110 + indexPath.row;
        cell.contentTextField.placeholder = @"必输";
        [cell.contentTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        if (_isHospital) {
            if (indexPath.row == 0) {
                cell.contentTextField.text = self.model.hospital;
            } else {
                cell.contentTextField.text = self.model.department;
            }
        } else {
            if (indexPath.row == 0) {
                cell.contentTextField.text = self.model.hospital;
            } else {
                cell.contentTextField.text = self.model.position;
            }
        }
        cell.contentTextField.enabled = _editable ? YES : NO;
        return cell;

    }
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            if (_editable) {
                CitiesModel *tempModel = [[CitiesModel alloc] init];
                tempModel.code = self.model.region;
                tempModel.fullName = self.model.regionFullName;
                [self.cityView resetContents:self.areasArray selectedCity:tempModel];
                [UIView animateWithDuration:0.3 animations:^{
                    self.cityView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
                }];
            }
        } else if (indexPath.row == 3) {
            if (_editable) {
                TitlesModel *tempModel = [[TitlesModel alloc] init];
                tempModel.titleId = self.model.professionalTitleId;
                tempModel.name = self.model.professionalTitle;
                [self.titlesPickerView resetContents:self.professionalTitlesArray selected:tempModel];
                [self.titlesPickerView show];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 1 ? 45.f : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
        headerView.backgroundColor = [UIColor whiteColor];
        [headerView addSubview:self.hospitalButton];
        [headerView addSubview:self.clinicButton];
        [self.hospitalButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(50, 30));
            make.centerY.equalTo(headerView);
            make.centerX.equalTo(headerView).with.mas_offset(- 50);
        }];
        [self.clinicButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(50, 30));
            make.centerY.equalTo(headerView);
            make.centerX.equalTo(headerView).with.mas_offset(50);
        }];
        if (_isHospital) {
            self.hospitalButton.selected = YES;
            self.clinicButton.selected = NO;
        } else {
            self.hospitalButton.selected = NO;
            self.clinicButton.selected = YES;
        }
        return headerView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section == 2 ? 0 : 10.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Getters
- (InformationModel *)model {
    if (!_model) {
        _model = [[InformationModel alloc] init];
    }
    return _model;
}
- (UIButton *)hospitalButton {
    if (!_hospitalButton) {
        _hospitalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_hospitalButton setTitle:@"医院" forState:UIControlStateNormal];
        [_hospitalButton setTitleColor:XJRGBColor(100, 100, 100, 1) forState:UIControlStateNormal];
        [_hospitalButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateSelected];
        [_hospitalButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_hospitalButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        _hospitalButton.titleLabel.font = XJSystemFont(15);
        [_hospitalButton setImageEdgeInsets:UIEdgeInsetsMake(0, - 5, 0, 0)];
        [_hospitalButton addTarget:self action:@selector(hospitalAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _hospitalButton;
}
- (UIButton *)clinicButton {
    if (!_clinicButton) {
        _clinicButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_clinicButton setTitle:@"诊所" forState:UIControlStateNormal];
        [_clinicButton setTitleColor:XJRGBColor(100, 100, 100, 1) forState:UIControlStateNormal];
        [_clinicButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateSelected];
        [_clinicButton setImage:[UIImage imageNamed:@"unchecked"] forState:UIControlStateNormal];
        [_clinicButton setImage:[UIImage imageNamed:@"checked"] forState:UIControlStateSelected];
        _clinicButton.titleLabel.font = XJSystemFont(15);
        [_clinicButton setImageEdgeInsets:UIEdgeInsetsMake(0, - 5, 0, 0)];
        [_clinicButton addTarget:self action:@selector(clinicAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clinicButton;
}
- (SelectCityView *)cityView {
    if (!_cityView) {
        _cityView = [[SelectCityView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _cityView;
}
- (TitlesPickerView *)titlesPickerView {
    if (!_titlesPickerView) {
        _titlesPickerView = [[TitlesPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _titlesPickerView;
}

@end
