//
//  XJPatientDetailViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/17.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPatientDetailViewController.h"
#import "XJModifyInformationsViewController.h"
#import "WritePrescriptionViewController.h"
#import "XJAddPatientViewController.h"
#import "XJHistoricalPrescriptionsViewController.h"
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
    }
    NSMutableArray *viewControllers = [self.navigationController.viewControllers mutableCopy];
    for (NSInteger i = 0; i < self.navigationController.viewControllers.count; i ++) {
        UIViewController *controller = self.navigationController.viewControllers[i];
        if ([controller isKindOfClass:[XJAddPatientViewController class]]) {
            [viewControllers removeObjectAtIndex:i];
        }
    }
    [self.navigationController setViewControllers:viewControllers];
    [self fetchInformations];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)addPrescriptionAction:(id)sender {
    WritePrescriptionViewController *writePrescriptionController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"WritePrescription"];
    writePrescriptionController.patientId = self.patientId;
    [self.navigationController pushViewController:writePrescriptionController animated:YES];
}
#pragma mark - Request
- (void)fetchInformations {
    if (!self.patientModel) {
        XLShowHUDWithMessage(nil, self.view);
    }
    [PatientModel patientInformations:self.patientId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.patientModel = object;
            self.patientModel.id = self.patientId;
            if ([[XJDataBase sharedDataBase] selectUser:self.patientId].count > 0) {
                [[XJDataBase sharedDataBase] updatePatientData:self.patientModel];
            } else {
                [[XJDataBase sharedDataBase] insertUser:self.patientModel];
                GJCFAsyncMainQueue(^{
                    [self.tableView reloadData];
                });
            }
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    switch (section) {
        case 0:
            number = 4;
            break;
        case 1:
            number = 1;
            break;
        case 2:
            number = 3;
            break;
        case 3:
            number = 2;
            break;
        case 4:
            number = 1;
            break;
        default:
            break;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 52.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsCell" forIndexPath:indexPath];
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = self.titlesArray[indexPath.row];
            if (indexPath.row == 0) {
                cell.detailTextLabel.text = self.patientModel.name;
            } else if (indexPath.row == 1) {
                if (self.patientModel.sex.integerValue == XJUserSexUnknown) {
                    cell.detailTextLabel.text = @"保密";
                } else if (self.patientModel.sex.integerValue == XJUserSexMale) {
                    cell.detailTextLabel.text = @"男";
                } else if (self.patientModel.sex.integerValue == XJUserSexFemale) {
                    cell.detailTextLabel.text = @"女";
                }
            } else if (indexPath.row == 2) {
                cell.detailTextLabel.text = XLIsNullObject(self.patientModel.age) ? @"" : [NSString stringWithFormat:@"%@", self.patientModel.age];
            } else {
                cell.detailTextLabel.text = XLIsNullObject(self.patientModel.phone) ? @"未设置" : self.patientModel.phone;
            }
        }
            break;
        case 1: {
            
            cell.textLabel.text = self.titlesArray[indexPath.row + 4];
            if (XLIsNullObject(self.patientModel.remark)) {
                cell.detailTextLabel.text = @"未设置";
            } else {
                cell.detailTextLabel.text = self.patientModel.remark;
            }
        }
            break;
        case 2: {
            cell.textLabel.text = self.titlesArray[indexPath.row + 5];
            if (indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryNone;
                NSString *hospital = [[NSUserDefaults standardUserDefaults] stringForKey:USERHOSPITAL];
                cell.detailTextLabel.text = hospital;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            } else if (indexPath.row == 1) {
                cell.detailTextLabel.text = self.patientModel.clinichistoryNo;
            } else {
                cell.detailTextLabel.text = self.patientModel.disease;
            }
        }
            break;
        case 3: {
            cell.textLabel.text = self.titlesArray[indexPath.row + 8];
            if (indexPath.row == 0) {
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
        case 4: {
            cell.textLabel.text = self.titlesArray[indexPath.row + 10];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 4) {
        XJHistoricalPrescriptionsViewController *historicalController = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoricalPrescriptions"];
        historicalController.patientId = self.patientId;
        historicalController.patientModel = self.patientModel;
        [self.navigationController pushViewController:historicalController animated:YES];
    }
    if (self.patientModel.canModify.integerValue == 1) {         //可以修改所有信息
        if (indexPath.section < 4 && !(indexPath.section == 2 && indexPath.row == 0)) {
            XJModifyInformationsViewController *modifyController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyInformations"];
            XJPatientInformationTypes type = XJPatientInformationTypesNone;
            if (indexPath.section == 0) {
                if (indexPath.row == 0) {
                    type = XJPatientInformationTypesName;
                } else if (indexPath.row == 1) {
                    type = XJPatientInformationTypesSex;
                } else if (indexPath.row == 2) {
                    type = XJPatientInformationTypesAge;
                } else {
                    type = XJPatientInformationTypesPhone;
                }
            } else if (indexPath.section == 1) {
                    type = XJPatientInformationTypesRemark;
            } else if (indexPath.section == 2) {
                if (indexPath.row == 1) {
                    type = XJPatientInformationTypesClinichistoryNo;
                } else if (indexPath.row == 2) {
                    type = XJPatientInformationTypesDisease;
                }
            } else if (indexPath.section == 3) {
                if (indexPath.row == 0) {
                    type = XJPatientInformationTypesEducationDegree;
                } else {
                    type = XJPatientInformationTypesMaritalStatus;
                }
            }
            modifyController.type = type;
            modifyController.model = self.patientModel;
            modifyController.modifyBlock = ^(PatientModel *model) {
                if (model) {
                    self.patientModel = model;
                    GJCFAsyncMainQueue(^{
                        [self.tableView reloadData];
                    });
                }
            };
            [self.navigationController pushViewController:modifyController animated:YES];
        }
    } else {                                //只能修改备注
        if (indexPath.section == 1) {
            XJModifyInformationsViewController *modifyController = [self.storyboard instantiateViewControllerWithIdentifier:@"ModifyInformations"];
            modifyController.type = XJPatientInformationTypesRemark;
            modifyController.model = self.patientModel;
            modifyController.modifyBlock = ^(PatientModel *model) {
                if (model) {
                    self.patientModel = model;
                    GJCFAsyncMainQueue(^{
                        [self.tableView reloadData];
                    });
                }
            };
            [self.navigationController pushViewController:modifyController animated:YES];
        }
    }
}

#pragma mark - Getters
- (NSArray *)titlesArray {
    if (!_titlesArray) {
        _titlesArray = @[@"姓　　名", @"性　　别", /*@"出生日期",*/ @"年　　龄", @"手　　机", @"备　　注", @"医　　院", @"病历号", @"病　　症", @"文化程度", @"婚姻状况", @"历史处方"];
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
