//
//  XJAddPatientViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJAddPatientViewController.h"
#import "XJPatientDetailViewController.h"
#import "XJPatientsInformationCell.h"
#import "XJDatePickerView.h"
#import "XJDiseasePickerView.h"
#import "XLBlockActionSheet.h"

#import "DiseaseModel.h"
#import "UserModel.h"

#import <GJCFUitils.h>

@interface XJAddPatientViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XJDatePickerView *datePickerView;
@property (strong, nonatomic) XJDiseasePickerView *diseasePickerView;

@property (copy, nonatomic) NSArray *titlesArray;
@property (copy, nonatomic) NSString *birthdayString;
@property (strong, nonatomic) DiseaseModel *selectedDisease;
@property (nonatomic) XJUserSex sex;
@property (nonatomic) XJMaritalStatus maritalStatus;
@property (nonatomic) XJEducationDegree educationDegree;
@property (copy, nonatomic) NSString *patientId;

@end

@implementation XJAddPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [XJKeyWindow addSubview:self.datePickerView];
    GJCFWeakSelf weakSelf = self;
    self.datePickerView.selectBlock = ^(NSString *dateString) {
        GJCFStrongSelf strongSelf = weakSelf;
        _birthdayString = dateString;
        [strongSelf.tableView reloadData];
    };
    [XJKeyWindow addSubview:self.diseasePickerView];
    self.diseasePickerView.selectBlock = ^(DiseaseModel *model) {
        GJCFStrongSelf strongSelf = weakSelf;
        _selectedDisease = model;
        [strongSelf.tableView reloadData];
    };
    _sex = XJUserSexUnknown;
    _maritalStatus = XJMaritalStatusUnknown;
    _educationDegree = XJEducationDegreeUnknown;
    [self fetchDiseasesList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)nextStepAction:(id)sender {
    if ([self checkInformations]) {
        XLShowHUDWithMessage(nil, self.view);
        UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:100];
        UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:101];
        UITextField *textField5 = (UITextField *)[self.tableView viewWithTag:102];  //备注
        UITextField *textField3 = (UITextField *)[self.tableView viewWithTag:106];  //手机号
        UITextField *textField4 = (UITextField *)[self.tableView viewWithTag:109];  //医保卡号
        NSMutableDictionary *informations = [@{@"clinichistoryNo" : textField1.text,
                                               @"name" : textField2.text,
                                               @"birthday" : [_birthdayString stringByAppendingString:@" 00:00:00"],
                                               @"diseaseId" : _selectedDisease.diseaseId,
                                               @"sex" : @(_sex) } mutableCopy];
        if (!XLIsNullObject(textField3.text)) {
            [informations setObject:textField3.text forKey:@"phone"];
        }
        if (!XLIsNullObject(textField5.text)) {
            [informations setObject:textField5.text forKey:@"remark"];
        }
        [informations setObject:@(_maritalStatus) forKey:@"maritalStatus"];
        [informations setObject:@(_educationDegree) forKey:@"educationDegree"];
        if (!XLIsNullObject(textField4.text)) {
            [informations setObject:textField4.text forKey:@"medicalInsuranceCardNo"];
        }
        [UserModel addPatient:informations handler:^(id object, NSString *msg) {
            if (object) {
                XLDismissHUD(self.view, YES, YES, @"增加患者成功");
                self.patientId = object[@"id"];
                [self performSelector:@selector(turnToAddPrescription) withObject:nil afterDelay:0.5];
            } else {
                XLDismissHUD(self.view, YES, NO, msg);
            }
        }];

    };
    
}

#pragma mark - Private methods
- (BOOL)checkInformations {
    BOOL canUpload = YES;
    UITextField *textField1 = (UITextField *)[self.tableView viewWithTag:100];
    UITextField *textField2 = (UITextField *)[self.tableView viewWithTag:101];
    UITextField *textField5 = (UITextField *)[self.tableView viewWithTag:102];  //备注
    UITextField *textField3 = (UITextField *)[self.tableView viewWithTag:106];  //手机号
    UITextField *textField4 = (UITextField *)[self.tableView viewWithTag:109];  //医保卡号
    [textField1 resignFirstResponder];
    [textField2 resignFirstResponder];
    [textField3 resignFirstResponder];
    [textField4 resignFirstResponder];
    [textField5 resignFirstResponder];
    if (XLIsNullObject(textField1.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入患者病历号");
        return NO;
    }
    if (XLIsMobileNumber(textField1.text)) {
        XLDismissHUD(self.view, YES, NO, @"病历号格式错误");
        return NO;
    }
    if (XLIsNullObject(textField2.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入患者姓名");
        return NO;
    }
    if (XLIsNullObject(_birthdayString)) {
        XLDismissHUD(self.view, YES, NO, @"请先选择患者出生日期");
        return NO;
    }
    if (!_selectedDisease) {
        XLDismissHUD(self.view, YES, NO, @"请先选择患者病症");
        return NO;
    }
    if (!XLIsNullObject(textField3.text)) {
        if (textField3.text.length != 11) {
            XLDismissHUD(self.view, YES, NO, @"手机号应为11位");
            return NO;
        } else if (!XLIsMobileNumber(textField3.text)) {
            XLDismissHUD(self.view, YES, NO, @"请输入正确的手机号");
            return NO;
        }
    }
    return canUpload;
}
- (void)turnToAddPrescription {
    XJPatientDetailViewController *detailController = [[UIStoryboard storyboardWithName:@"Patients" bundle:nil] instantiateViewControllerWithIdentifier:@"PatientDetail"];
    detailController.patientId = self.patientId;
    [self.navigationController pushViewController:detailController animated:YES];
}

#pragma mark - Requests
- (void)fetchDiseasesList {
    [DiseaseModel fetchDiseasesList:^(id object, NSString *msg) {
        if (object) {
            NSArray *tempArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.diseasePickerView addData:tempArray];
            });
        }
    }];
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJPatientsInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientsInformationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headerLabel.text = self.titlesArray[indexPath.row];
    cell.textField.tag = 100 + indexPath.row;
    cell.textField.delegate = self;
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 9) {
        cell.textField.enabled = YES;
    } else {
        cell.textField.enabled = NO;
    }
    if (indexPath.row == 2 || indexPath.row == 6 || indexPath.row == 9) {
        cell.textField.placeholder = @"非必输";
    } else if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 3 || indexPath.row == 4) {
        cell.textField.placeholder = @"必输";
    } else {
        cell.textField.placeholder = @"保密";
    }
    if (indexPath.row == 0 || indexPath.row == 6) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    switch (indexPath.row) {
        case 3: {
            cell.textField.text = _birthdayString;
        }
            break;
        case 4: {
            if (_selectedDisease) {
                cell.textField.text = _selectedDisease.diseaseName;
            }
        }
            break;
        case 5: {
            if (_sex == XJUserSexUnknown) {
                cell.textField.text = nil;
            } else if (_sex == XJUserSexMale) {
                cell.textField.text = @"男";
            } else if (_sex == XJUserSexFemale) {
                cell.textField.text = @"女";
            }
        }
            break;
        case 7: {
            if (_maritalStatus == XJMaritalStatusUnknown) {
                cell.textField.text = nil;
            } else if (_maritalStatus == XJMaritalStatusMarried) {
                cell.textField.text = @"已婚";
            } else if (_maritalStatus == XJMaritalStatusNotMarried) {
                cell.textField.text = @"未婚";
            }
        }
            break;
        case 8: {
            switch (_educationDegree) {
                case XJEducationDegreeUnknown:
                    cell.textField.text = nil;
                    break;
                case XJEducationDegreeNone:
                    cell.textField.text = @"文盲";
                    break;
                case XJEducationDegreePrimary:
                    cell.textField.text = @"小学";
                    break;
                case XJEducationDegreeMiddle:
                    cell.textField.text = @"初中";
                    break;
                case XJEducationDegreeHigh:
                    cell.textField.text = @"高中";
                    break;
                case XJEducationDegreeUniversity:
                    cell.textField.text = @"大学";
                    break;
                case XJEducationDegreeMaster:
                    cell.textField.text = @"研究生及以上";
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 3: {
            [self.datePickerView show];
        }
            break;
        case 4: {
            [self.diseasePickerView show];
        }
            break;
        case 5: {
            [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    _sex = XJUserSexUnknown;
                } else if (buttonIndex == 2) {
                    _sex = XJUserSexMale;
                } else if (buttonIndex == 3) {
                    _sex = XJUserSexFemale;
                }
                if (buttonIndex != 1) {
                    GJCFAsyncMainQueue(^{
                        [self.tableView reloadData];
                    });
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"男", @"女", nil] showInView:self.view];
        }
            break;
        case 7: {
            [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
                if (buttonIndex == 0) {
                    _maritalStatus = XJMaritalStatusUnknown;
                } else if (buttonIndex == 2) {
                    _maritalStatus = XJMaritalStatusMarried;
                } else if (buttonIndex == 3) {
                    _maritalStatus = XJMaritalStatusNotMarried;
                }
                if (buttonIndex != 1) {
                    GJCFAsyncMainQueue(^{
                        [self.tableView reloadData];
                    });
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"已婚", @"未婚", nil] showInView:self.view];
        }
            break;
        case 8: {
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
                if (buttonIndex != 1) {
                    GJCFAsyncMainQueue(^{
                        [self.tableView reloadData];
                    });
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:@"保密" otherButtonTitles:@"文盲", @"小学", @"初中", @"高中", @"大学", @"研究生及以上", nil] showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Getters
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"病 历 号", @"姓       名", @"备       注", @"出生日期", @"病       症", @"性       别", @"手       机", @"婚姻状况", @"文化程度", @"医保卡号"];
    }
    return _titlesArray;
}
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
