//
//  XJModifyInformationsViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJModifyInformationsViewController.h"
#import "XJModifyInformationCell.h"
#import "XJDatePickerView.h"
#import "XJDiseasePickerView.h"
#import "XLBlockActionSheet.h"

#import "DiseaseModel.h"
#import "PatientModel.h"

@interface XJModifyInformationsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XJDatePickerView *datePickerView;
@property (strong, nonatomic) XJDiseasePickerView *diseasePickerView;

@property (strong, nonatomic) DiseaseModel *selectedDisease;
@property (copy, nonatomic) NSString *birthdayString;
@property (nonatomic) XJUserSex sex;
@property (nonatomic) XJMaritalStatus maritalStatus;
@property (nonatomic) XJEducationDegree educationDegree;

@end

@implementation XJModifyInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *titleString;
    switch (self.type) {
        case XJPatientInformationTypesName:
            titleString = @"姓名";
            break;
        case XJPatientInformationTypesRemark:
            titleString = @"备注";
            break;
        case XJPatientInformationTypesClinichistoryNo:
            titleString = @"病历号";
            break;
        case XJPatientInformationTypesMedicalInsuranceCardNo:
            titleString = @"医保卡号";
            break;
        case XJPatientInformationTypesDisease: {
            titleString = @"病症";
            GJCFWeakSelf weakSelf = self;
            [[UIApplication sharedApplication].keyWindow addSubview:self.diseasePickerView];
            self.diseasePickerView.selectBlock = ^(DiseaseModel *model) {
                GJCFStrongSelf strongSelf = weakSelf;
                strongSelf.selectedDisease = model;
                if (![strongSelf.selectedDisease.diseaseId isEqualToString:strongSelf.model.diseaseId]) {
                    strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
                } else {
                    strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
                }
                [strongSelf.tableView reloadData];
            };
            [self fetchDiseasesList];
        }
            break;
        case XJPatientInformationTypesPhone:
            titleString = @"手机";
            break;
        case XJPatientInformationTypesSex: {
            titleString = @"性别";
            _sex = self.model.sex.integerValue;
            [self initSexPicker];
        }
            break;
        case XJPatientInformationTypesBirthday: {
            titleString = @"出生日期";
            _birthdayString = self.model.birthday;
            [[UIApplication sharedApplication].keyWindow addSubview:self.datePickerView];
            [self.datePickerView selectDate:[_birthdayString substringToIndex:10]];
            GJCFWeakSelf weakSelf = self;
            self.datePickerView.selectBlock = ^(NSString *dateString) {
                GJCFStrongSelf strongSelf = weakSelf;
                strongSelf.birthdayString = dateString;
                if ([strongSelf.birthdayString isEqualToString:[strongSelf.model.birthday substringToIndex:10]]) {
                    strongSelf.navigationItem.rightBarButtonItem.enabled = NO;
                } else {
                    strongSelf.navigationItem.rightBarButtonItem.enabled = YES;
                }
                [strongSelf.tableView reloadData];
            };
        }
            break;
        case XJPatientInformationTypesEducationDegree: {
            titleString = @"文化程度";
            _educationDegree = self.model.educationDegree.integerValue;
            [self initEducationDegreePicker];
        }
            break;
        case XJPatientInformationTypesMaritalStatus: {
            titleString = @"婚姻状况";
            _maritalStatus = self.model.maritalStatus.integerValue;
            [self initMaritalStatusPicker];
        }
            break;
        default:
            break;
    }
    self.title = titleString;
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.type == XJPatientInformationTypesBirthday) {
        [self.datePickerView show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)saveAction:(id)sender {
    XJModifyInformationCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell.modifyTextField resignFirstResponder];
    XLShowHUDWithMessage(@"正在保存...", self.view);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    switch (self.type) {
        case XJPatientInformationTypesName: {
            self.model.name = cell.modifyTextField.text;
        }
            break;
        case XJPatientInformationTypesRemark: {
            if (XLIsNullObject(cell.modifyTextField.text)) {
                self.model.remark = @"";
            } else {
                self.model.remark = cell.modifyTextField.text;
            }
        }
            break;
        case XJPatientInformationTypesClinichistoryNo: {
            self.model.clinichistoryNo = cell.modifyTextField.text;
        }
            break;
        case XJPatientInformationTypesMedicalInsuranceCardNo: {
            if (XLIsNullObject(cell.modifyTextField.text)) {
                self.model.medicalInsuranceCardNo = @"";
            } else {
                self.model.medicalInsuranceCardNo = cell.modifyTextField.text;
            }
        }
            break;
        case XJPatientInformationTypesDisease: {
            self.model.diseaseId = self.selectedDisease.diseaseId;
            self.model.disease = self.selectedDisease.diseaseName;
        }
            break;
        case XJPatientInformationTypesPhone: {
            if (XLIsNullObject(cell.modifyTextField.text)) {
                self.model.phone = @"";
            } else {
                self.model.phone = cell.modifyTextField.text;
            }
        }
            break;
        case XJPatientInformationTypesSex: {
            self.model.sex = @(_sex);
        }
            break;
        case XJPatientInformationTypesBirthday: {
            self.model.birthday = [self.birthdayString stringByAppendingString:@" 00:00:00"];
        }
            break;
        case XJPatientInformationTypesEducationDegree: {
            self.model.educationDegree = @(_educationDegree);
        }
            break;
        case XJPatientInformationTypesMaritalStatus: {
            self.model.maritalStatus = @(_maritalStatus);
        }
            break;
        default:
            break;
    }
    [PatientModel modifyInformations:self.model patientId:self.model.id handler:^(id object, NSString *msg) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        if (object) {
            XLDismissHUD(self.view, YES, YES, @"保存成功");
            if (self.modifyBlock) {
                self.modifyBlock(self.model);
            }
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Requests
- (void)fetchDiseasesList {
    [DiseaseModel fetchDiseasesList:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.diseasePickerView addData:tempArray];
                for (NSInteger i = 0; i < tempArray.count; i ++) {
                    DiseaseModel *tempModel = tempArray[i];
                    if ([tempModel.diseaseId isEqualToString:self.model.diseaseId]) {
                        [self.diseasePickerView selectRow:i];
                    }
                }
                [self.diseasePickerView show];
            });
        }
    }];
}

#pragma mark - Private methods
- (void)initSexPicker {
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            _sex = XJUserSexUnknown;
        } else if (buttonIndex == 2) {
            _sex = XJUserSexMale;
        } else if (buttonIndex == 3) {
            _sex = XJUserSexFemale;
        }
        self.navigationItem.rightBarButtonItem.enabled = _sex == self.model.sex.integerValue ? NO : YES;
        if (buttonIndex != 1) {
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"男", @"女", nil] showInView:self.view];
}
- (void)initEducationDegreePicker {
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 0:
                _educationDegree = XJEducationDegreeUnknown;
                break;
            case 2:
                _educationDegree = XJEducationDegreeNone;
                break;
            case 3:
                _educationDegree = XJEducationDegreePrimary;
                break;
            case 4:
                _educationDegree = XJEducationDegreeMiddle;
                break;
            case 5:
                _educationDegree = XJEducationDegreeHigh;
                break;
            case 6:
                _educationDegree = XJEducationDegreeUniversity;
                break;
            case 7:
                _educationDegree = XJEducationDegreeMaster;
                break;
            default:
                break;
        }
        self.navigationItem.rightBarButtonItem.enabled = _educationDegree == self.model.educationDegree.integerValue ? NO : YES;
        if (buttonIndex != 1) {
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"文盲", @"小学", @"初中", @"高中", @"大学", @"研究生及以上", nil] showInView:self.view];
}
- (void)initMaritalStatusPicker {
    [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
        if (buttonIndex == 0) {
            _maritalStatus = XJMaritalStatusUnknown;
        } else if (buttonIndex == 2) {
            _maritalStatus = XJMaritalStatusMarried;
        } else if (buttonIndex == 3) {
            _maritalStatus = XJMaritalStatusNotMarried;
        }
        self.navigationItem.rightBarButtonItem.enabled = _maritalStatus == self.model.maritalStatus.integerValue ? NO : YES;
        if (buttonIndex != 1) {
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        }
    } cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"已婚", @"未婚", nil] showInView:self.view];
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (void)textFieldDidChanged:(UITextField *)textField {
    switch (self.type) {
        case XJPatientInformationTypesName: {
            if ([textField.text isEqualToString:self.model.name] || XLIsNullObject(textField.text)) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
            break;
        case XJPatientInformationTypesRemark: {
            if ([textField.text isEqualToString:self.model.remark]) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
            break;
        case XJPatientInformationTypesClinichistoryNo: {
            if ([textField.text isEqualToString:self.model.name] || XLIsNullObject(textField.text)) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
            break;
        case XJPatientInformationTypesMedicalInsuranceCardNo: {
            if ([textField.text isEqualToString:self.model.remark]) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
            break;
        case XJPatientInformationTypesPhone: {
            if ([textField.text isEqualToString:self.model.remark]) {
                self.navigationItem.rightBarButtonItem.enabled = NO;
            } else {
                self.navigationItem.rightBarButtonItem.enabled = YES;
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ModifyInformationCell";
    XJModifyInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.modifyTextField.delegate = self;
    [cell.modifyTextField addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    switch (self.type) {
        case XJPatientInformationTypesName: {
            cell.modifyTextField.enabled = YES;
            cell.modifyTextField.text = self.model.name;
            [cell.modifyTextField becomeFirstResponder];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case XJPatientInformationTypesRemark: {
            cell.modifyTextField.enabled = YES;
            cell.modifyTextField.text = self.model.remark;
            cell.modifyTextField.placeholder = @"未设置";
            [cell.modifyTextField becomeFirstResponder];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case XJPatientInformationTypesClinichistoryNo: {
            cell.modifyTextField.enabled = YES;
            cell.modifyTextField.text = self.model.clinichistoryNo;
            [cell.modifyTextField becomeFirstResponder];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case XJPatientInformationTypesMedicalInsuranceCardNo: {
            cell.modifyTextField.enabled = YES;
            cell.modifyTextField.text = self.model.medicalInsuranceCardNo;
            cell.modifyTextField.placeholder = @"未设置";
            [cell.modifyTextField becomeFirstResponder];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case XJPatientInformationTypesDisease: {
            cell.modifyTextField.enabled = NO;
            if (self.selectedDisease.diseaseName) {
                cell.modifyTextField.text = self.selectedDisease.diseaseName;
            } else {
                cell.modifyTextField.text = self.model.disease;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case XJPatientInformationTypesPhone: {
            cell.modifyTextField.enabled = YES;
            cell.modifyTextField.text = self.model.phone;
            cell.modifyTextField.placeholder = @"未设置";
            cell.modifyTextField.keyboardType = UIKeyboardTypeNumberPad;
            [cell.modifyTextField becomeFirstResponder];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            break;
        case XJPatientInformationTypesSex: {
            cell.modifyTextField.enabled = NO;
            cell.modifyTextField.placeholder = @"保密";
            if (_sex == XJUserSexUnknown) {
                cell.modifyTextField.text = nil;
            } else if (_sex == XJUserSexMale) {
                cell.modifyTextField.text = @"男";
            } else if (_sex == XJUserSexFemale) {
                cell.modifyTextField.text = @"女";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case XJPatientInformationTypesBirthday: {
            cell.modifyTextField.enabled = NO;
            cell.modifyTextField.text = [_birthdayString substringToIndex:10];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case XJPatientInformationTypesEducationDegree: {
            cell.modifyTextField.enabled = NO;
            cell.modifyTextField.placeholder = @"保密";
            switch (_educationDegree) {
                case XJEducationDegreeUnknown:
                    cell.modifyTextField.text = nil;
                    break;
                case XJEducationDegreeNone:
                    cell.modifyTextField.text = @"文盲";
                    break;
                case XJEducationDegreePrimary:
                    cell.modifyTextField.text = @"小学";
                    break;
                case XJEducationDegreeMiddle:
                    cell.modifyTextField.text = @"初中";
                    break;
                case XJEducationDegreeHigh:
                    cell.modifyTextField.text = @"高中";
                    break;
                case XJEducationDegreeUniversity:
                    cell.modifyTextField.text = @"大学";
                    break;
                case XJEducationDegreeMaster:
                    cell.modifyTextField.text = @"研究生及以上";
                    break;
                default:
                    break;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        case XJPatientInformationTypesMaritalStatus: {
            cell.modifyTextField.enabled = NO;
            cell.modifyTextField.placeholder = @"保密";
            if (_maritalStatus == XJMaritalStatusUnknown) {
                cell.modifyTextField.text = nil;
            } else if (_maritalStatus == XJMaritalStatusMarried) {
                cell.modifyTextField.text = @"已婚";
            } else if (_maritalStatus == XJMaritalStatusNotMarried) {
                cell.modifyTextField.text = @"未婚";
            }
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
            break;
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 12.f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.type) {
        case XJPatientInformationTypesDisease: {
            [self.diseasePickerView show];
        }
            break;
        case XJPatientInformationTypesSex: {
            [self initSexPicker];
        }
            break;
        case XJPatientInformationTypesBirthday: {
            [self.datePickerView show];
        }
            break;
        case XJPatientInformationTypesEducationDegree: {
            [self initEducationDegreePicker];
        }
            break;
        case XJPatientInformationTypesMaritalStatus: {
            [self initMaritalStatusPicker];
        }
        default:
            break;
    }
}

#pragma mark - Getters
- (XJDatePickerView *)datePickerView {
    if (!_datePickerView) {
        _datePickerView = [[XJDatePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _datePickerView;
}
- (XJDiseasePickerView *)diseasePickerView {
    if (!_diseasePickerView) {
        _diseasePickerView = [[XJDiseasePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _diseasePickerView;
}
    

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
