//
//  XJPatientDetailViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/17.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPatientDetailViewController.h"
#import "PatientModel.h"
#import "XJDataBase.h"

#import <GJCFUitils.h>

@interface XJPatientDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (copy, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) PatientModel *patientModel;

@end

@implementation XJPatientDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MAIN_BACKGROUND_COLOR;
    NSArray *tempArray = [[XJDataBase sharedDataBase] selectUser:self.patientId];
    if (tempArray.count > 0) {
        self.patientModel = tempArray[0];
        [self.tableView reloadData];
    } else {
        [self fetchInformations];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchInformations {
    XLShowHUDWithMessage(nil, self.view);
    [PatientModel patientInformations:self.patientId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.patientModel = object;
            [[XJDataBase sharedDataBase] insertUser:self.patientModel];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 2;
            break;
        case 1:
            number = 4;
            break;
        case 2:
            number = 6;
            break;
        case 3:
            number = 1;
            break;
        default:
            break;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.titlesArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.patientModel.name;
            } else {
                if (XLIsNullObject(self.patientModel.remark)) {
                    cell.detailTextLabel.text = @"未设置";
                } else {
                    cell.detailTextLabel.text = self.patientModel.remark;
                }
            }
        }
            break;
        case 1: {
            cell.textLabel.text = self.titlesArray[indexPath.row + 2];
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                NSString *hospital = [[NSUserDefaults standardUserDefaults] stringForKey:USERHOSPITAL];
                cell.detailTextLabel.text = hospital;
            } else if (indexPath.row == 1) {
                cell.detailTextLabel.text = self.patientModel.clinichistoryNo;
            } else if (indexPath.row == 2) {
                cell.detailTextLabel.text = XLIsNullObject(self.patientModel.medicalInsuranceCardNo) ? @"未设置" : self.patientModel.medicalInsuranceCardNo;
            } else {
                cell.detailTextLabel.text = self.patientModel.disease;
            }
        }
            break;
        case 2: {
            cell.textLabel.text = self.titlesArray[indexPath.row + 6];
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = XLIsNullObject(self.patientModel.phone) ? @"未设置" : self.patientModel.phone;
            } else if (indexPath.row == 1) {
                if (self.patientModel.sex.integerValue == XJUserSexUnknown) {
                    cell.detailTextLabel.text = @"保密";
                } else if (self.patientModel.sex.integerValue == XJUserSexMale) {
                    cell.detailTextLabel.text = @"男";
                } else if (self.patientModel.sex.integerValue == XJUserSexFemale) {
                    cell.detailTextLabel.text = @"女";
                }
            } else if (indexPath.row == 2) {
                cell.detailTextLabel.text = XLIsNullObject(self.patientModel.birthday) ? @"" : [self.patientModel.birthday substringToIndex:9];
            } else if (indexPath.row == 3) {
                switch (self.patientModel.educationDegree.integerValue) {
                    case XJEducationDegreeUnknown:
                        cell.detailTextLabel.text = @"保密";
                        break;
                    case XJEducationDegreeNone:
                        cell.detailTextLabel.text = @"文盲";
                        break;
                    case XJEducationDegreePrimary:
                        cell.detailTextLabel.text = @"小学";
                        break;
                    case XJEducationDegreeMiddle:
                        cell.detailTextLabel.text = @"初中";
                        break;
                    case XJEducationDegreeHigh:
                        cell.detailTextLabel.text = @"高中";
                        break;
                    case XJEducationDegreeUniversity:
                        cell.detailTextLabel.text = @"大学";
                        break;
                    case XJEducationDegreeMaster:
                        cell.detailTextLabel.text = @"研究生及以上";
                        break;
                    default:
                        break;
                }
            } else {
                if (self.patientModel.maritalStatus.integerValue == XJMaritalStatusUnknown) {
                    cell.detailTextLabel.text = @"保密";
                } else if (self.patientModel.maritalStatus.integerValue == XJMaritalStatusMarried) {
                    cell.detailTextLabel.text = @"已婚";
                } else if (self.patientModel.maritalStatus.integerValue == XJMaritalStatusNotMarried) {
                    cell.detailTextLabel.text = @"未婚";
                }
            }
        }
            break;
        case 3: {
            cell.textLabel.text = self.titlesArray[indexPath.row + 11];
            cell.detailTextLabel.text = nil;
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
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    return headerView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

#pragma mark - Getters
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"姓       名", @"备       注", @"医       院", @"病 历 号", @"医保卡号", @"病       症", @"手       机", @"性       别", @"出生日期", @"文化程度", @"婚姻状况", @"处方记录"];
    }
    return _titlesArray;
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
