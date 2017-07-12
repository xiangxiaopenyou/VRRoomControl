//
//  XJAddPatientViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/11.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJAddPatientViewController.h"
#import "WritePrescriptionViewController.h"
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

@end

@implementation XJAddPatientViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [[UIApplication sharedApplication].keyWindow addSubview:self.datePickerView];
    GJCFWeakSelf weakSelf = self;
    self.datePickerView.selectBlock = ^(NSString *dateString) {
        GJCFStrongSelf strongSelf = weakSelf;
        _birthdayString = dateString;
        [strongSelf.tableView reloadData];
    };
    [[UIApplication sharedApplication].keyWindow addSubview:self.diseasePickerView];
    self.diseasePickerView.selectBlock = ^(DiseaseModel *model) {
        GJCFStrongSelf strongSelf = weakSelf;
        _selectedDisease = model;
        [strongSelf.tableView reloadData];
    };
    _sex = XJUserSexEmpty;
    _maritalStatus = XJMaritalStatusEmpty;
    _educationDegree = XJEducationDegreeEmpty;
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
        UITextField *textField3 = (UITextField *)[self.tableView viewWithTag:105];  //手机号
        UITextField *textField4 = (UITextField *)[self.tableView viewWithTag:108];  //医保卡号
        NSMutableDictionary *informations = [@{@"clinichistoryNo" : textField1.text,
                                               @"name" : textField2.text,
                                               @"birthday" : [_birthdayString stringByAppendingString:@" 00:00:00"],
                                               @"diseaseId" : _selectedDisease.diseaseId,
                                               @"sex" : @(_sex) } mutableCopy];
        if (!XLIsNullObject(textField3.text)) {
            [informations setObject:textField3.text forKey:@"phone"];
        }
        if (_maritalStatus != XJMaritalStatusEmpty) {
            [informations setObject:@(_maritalStatus) forKey:@"maritalStatus"];
        }
        if (_educationDegree != XJEducationDegreeEmpty) {
            [informations setObject:@(_educationDegree) forKey:@"educationDegree"];
        }
        if (!XLIsNullObject(textField4.text)) {
            [informations setObject:textField4.text forKey:@"medicalInsuranceCardNo"];
        }
        NSString *roomId = [[NSUserDefaults standardUserDefaults] stringForKey:ROOMID];
        [UserModel addPatient:roomId informations:informations handler:^(id object, NSString *msg) {
            if (object) {
                XLDismissHUD(self.view, YES, YES, @"增加患者成功");
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
    if (XLIsNullObject(textField1.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入患者病历号");
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
    if (_sex == XJUserSexEmpty) {
        XLDismissHUD(self.view, YES, NO, @"请先选择患者性别");
        return NO;
    }
    return canUpload;
}
- (void)turnToAddPrescription {
    WritePrescriptionViewController *writePrescriptionController = [self.storyboard instantiateViewControllerWithIdentifier:@"WritePrescription"];
    [self.navigationController pushViewController:writePrescriptionController animated:YES];
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
    return 50.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJPatientsInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PatientsInformationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headerLabel.text = self.titlesArray[indexPath.row];
    cell.textField.tag = 100 + indexPath.row;
    cell.textField.delegate = self;
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 5 || indexPath.row == 8) {
        cell.textField.enabled = YES;
    } else {
        cell.textField.enabled = NO;
    }
    if (indexPath.row > 4) {
        cell.textField.placeholder = @"非必输";
    } else {
        cell.textField.placeholder = @"必输";
    }
    if (indexPath.row == 5) {
        cell.textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    switch (indexPath.row) {
        case 2: {
            cell.textField.text = _birthdayString;
        }
            break;
        case 3: {
            if (_selectedDisease) {
                cell.textField.text = _selectedDisease.diseaseName;
            }
        }
            break;
        case 4: {
            if (_sex == XJUserSexUnknown) {
                cell.textField.text = @"保密";
            } else if (_sex == XJUserSexMale) {
                cell.textField.text = @"男";
            } else if (_sex == XJUserSexFemale) {
                cell.textField.text = @"女";
            } else {
                cell.textField.text = nil;
            }
        }
            break;
        case 6: {
            if (_maritalStatus == XJMaritalStatusUnknown) {
                cell.textField.text = @"保密";
            } else if (_maritalStatus == XJMaritalStatusMarried) {
                cell.textField.text = @"已婚";
            } else if (_maritalStatus == XJMaritalStatusNotMarried) {
                cell.textField.text = @"未婚";
            } else {
                cell.textField.text = nil;
            }
        }
            break;
        case 7: {
            switch (_educationDegree) {
                case XJEducationDegreeEmpty:
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
        case 2: {
            [self.datePickerView show];
        }
            break;
        case 3: {
            [self.diseasePickerView show];
        }
            break;
        case 4: {
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
        case 6: {
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
        case 7: {
            [[[XLBlockActionSheet alloc] initWithTitle:nil clickedBlock:^(NSInteger buttonIndex) {
                switch (buttonIndex) {
                    case 1:
                        _educationDegree = XJEducationDegreeNone;
                        break;
                    case 2:
                        _educationDegree = XJEducationDegreePrimary;
                        break;
                    case 3:
                        _educationDegree = XJEducationDegreeMiddle;
                        break;
                    case 4:
                        _educationDegree = XJEducationDegreeHigh;
                        break;
                    case 5:
                        _educationDegree = XJEducationDegreeUniversity;
                        break;
                    case 6:
                        _educationDegree = XJEducationDegreeMaster;
                        break;
                    default:
                        break;
                }
                if (buttonIndex != 0) {
                    GJCFAsyncMainQueue(^{
                        [self.tableView reloadData];
                    });
                }
            } cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"文盲", @"小学", @"初中", @"高中", @"大学", @"研究生及以上", nil] showInView:self.view];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Getters
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"病 历 号", @"姓       名", @"出生日期", @"病       症", @"性       别", @"手       机", @"婚姻状况", @"文化程度", @"医保卡号"];
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
