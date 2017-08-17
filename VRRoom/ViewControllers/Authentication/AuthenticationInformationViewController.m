//
//  AuthenticationInformationViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationInformationViewController.h"
//#import "EditInformationViewController.h"
//#import "AuthenticationPicturesViewController.h"

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
@property (copy, nonatomic) NSString *nameString;               //姓名
@property (strong, nonatomic) CitiesModel *selectedCityModel;   //已经选择的城市model
@property (copy, nonatomic) NSArray *professionalTitlesArray;   //职称数组
@property (strong, nonatomic) TitlesModel *selectedTitleModel;  //已经选择的职称model
@property (copy, nonatomic) NSString *hospitalString;           //医院名称
@property (copy, nonatomic) NSString *departmentString;         //医院科室
@property (copy, nonatomic) NSString *clinicString;             //诊所名称
@property (copy, nonatomic) NSString *positionString;           //诊所职位
@property (strong, nonatomic) UIImage *selectedPersonalImage;   //个人照片
@property (copy, nonatomic) NSString *personalImageUrl;         //个人照片链接
@property (copy, nonatomic) NSString *introductionString;       //个人介绍
@property (copy, nonatomic) NSString *selectedSpecialits;        //个人擅长
@property (copy, nonatomic) NSArray *authenticationPicturesArray1;  //认证图片
@property (copy, nonatomic) NSArray *authenticationPicturesArray2;  //认证图片
@property (copy, nonatomic) NSArray *authenticationPicturesUrlArray1;   //认证图片Url
@property (copy, nonatomic) NSArray *authenticationPicturesUrlArray2;
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
            strongSelf.selectedCityModel = selectedCity;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
    [self.view addSubview:self.titlesPickerView];
    self.titlesPickerView.block = ^(TitlesModel *model) {
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            strongSelf.selectedTitleModel = model;
            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    };
//    self.titlesPickerView.block = ^(TitlesModel *model) {
//        GJCFStrongSelf strongSelf = weakSelf;
//        if (model) {
//            strongSelf.selectedTitleModel = model;
//            [strongSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    };
    
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
        _headTitleArray = @[@"姓  名", @"性  别", @"城  市", @"职  称", @"医  院", @"科  室", @"更  多", @"认  证"];
    } else {
        _headTitleArray = @[@"姓  名", @"性  别", @"城  市", @"职  称", @"诊  所", @"职  位", @"更  多", @"认  证"];
    }
}
//信息是否能编辑
- (void)checkEditable {
    if (!self.model || [self.model.status integerValue] == 1 || [self.model.status integerValue] == 3) {
        _editable = YES;
        self.submitButton.hidden = NO;
    } else {
        _editable = NO;
        self.submitButton.hidden = YES;
    }
    [self resetTipView];
}
- (void)resetTipView {
    if (!self.model || [self.model.status integerValue] == 1) {
        self.footerView.hidden = YES;
    } else {
        self.footerView.hidden = NO;
        if ([self.model.status integerValue] == 2) {
            self.tipImageView.image = [UIImage imageNamed:@"authentication_waiting"];
            self.failureReasonLabel.textColor = XJRGBColor(67, 175, 61, 1);
            self.failureReasonLabel.text = NSLocalizedString(@"personal.waitingAuthentication", nil);
        } else if ([self.model.status integerValue] == 3) {
            self.tipImageView.image = [UIImage imageNamed:@"authentication_failure"];
            self.failureReasonLabel.textColor = XJRGBColor(225, 80, 41, 1);
            NSString *failureString = NSLocalizedString(@"personal.pleaseSubmitAgain", nil);
            if (!XLIsNullObject(self.model.remark)) {
                failureString = [NSString stringWithFormat:@"%@,%@", self.model.remark, failureString];
            }
            self.failureReasonLabel.text = [NSString stringWithFormat:@"%@, %@", self.model.remark, NSLocalizedString(@"personal.pleaseSubmitAgain", nil)];
        } else {
            self.tipImageView.image = [UIImage imageNamed:@"authentication_success"];
            self.failureReasonLabel.textColor = NAVIGATIONBAR_COLOR;
            self.failureReasonLabel.text = NSLocalizedString(@"personal.authenticationSuccess", nil);
        }
    }
}
- (void)refreshData {
    [self checkTitleArray:_isHospital];
    [self.tableView reloadData];
}
- (BOOL)checkIsCanUpload {
    UITextField *nameTextField = (UITextField *)[self.tableView viewWithTag:100];
    self.nameString = nameTextField.text;
    if (XLIsNullObject(self.nameString)) {
        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseEntryName", nil));
        return NO;
    }
    if (XLIsNullObject(self.selectedCityModel)) {
        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseChooseRegion", nil));
        return NO;
    }
    if (XLIsNullObject(self.selectedTitleModel)) {
        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseChooseTitle", nil));
        return NO;
    }
    if (_isHospital) {
        if (XLIsNullObject(self.hospitalString)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseEntryHospitalName", nil));
            return NO;
        }
        if (XLIsNullObject(self.departmentString)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseEntryDepartment", nil));
            return NO;
        }
    } else {
        if (XLIsNullObject(self.clinicString)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseEntryClinicName", nil));
            return NO;
        }
        if (XLIsNullObject(self.positionString)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseEntryPostion", nil));
            return NO;
        }
    }
    if (XLIsNullObject(self.selectedPersonalImage) && XLIsNullObject(self.model.headPictureUrl)) {
        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseUploadPersonalPhoto", nil));
        return NO;
    }
    if (XLIsNullObject(self.introductionString)) {
        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseEntryIntroduction", nil));
        return NO;
    }
    if (XLIsNullObject(self.selectedSpecialits)) {
        XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseChooseSpecialits", nil));
        return NO;
    }
    if ([self.selectedTitleModel.titleId integerValue] == 5 || [self.selectedTitleModel.titleId integerValue] == 6) {
        if (XLIsNullObject(self.authenticationPicturesArray1)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseUploadCard3", nil));
            return NO;
        }
        if (XLIsNullObject(self.authenticationPicturesArray2)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseUploadCard4", nil));
            return NO;
        }
    } else {
        if (XLIsNullObject(self.authenticationPicturesArray1)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseUploadCard1", nil));
            return NO;
        }
        if (XLIsNullObject(self.authenticationPicturesArray2)) {
            XLDismissHUD(self.view, YES, NO, NSLocalizedString(@"personal.pleaseUploadCard2", nil));
            return NO;
        }
    }

    return YES;
}
- (void)popView {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshInformations {
    self.nameString = self.model.realname;
    self.sex = XLIsNullObject(self.model.gender) ? XJUserSexMale : [self.model.gender integerValue];
    self.selectedCityModel.code = self.model.region;
    self.selectedCityModel.fullName = self.model.regionFullName;
    self.selectedTitleModel.titleId = self.model.professionalTitleId;
    self.selectedTitleModel.name = self.model.professionalTitle;
    if (XLIsNullObject(self.model.workplaceType)) {
        _isHospital = YES;
    } else {
        _isHospital = [self.model.workplaceType integerValue] == 1 ? YES : NO;
    }
    [self checkTitleArray:_isHospital];
    if (self.isHospital) {
        self.hospitalString = self.model.hospital;
        self.departmentString = self.model.department;
    } else {
        self.clinicString = self.model.hospital;
        self.positionString = self.model.position;
    }
    self.personalImageUrl = self.model.headPictureUrl;
    self.introductionString = self.model.introduction;
    self.selectedSpecialits = self.model.expertise;
    if ([self.model.professionalTitleId integerValue] == 5 || [self.model.professionalTitleId integerValue] == 6) {
        self.authenticationPicturesArray1 = [self.model.psychologicalConsultantImageUrl componentsSeparatedByString:@","];
        self.authenticationPicturesArray2 = [self.model.employeeImageUrl componentsSeparatedByString:@","];
    } else {
        self.authenticationPicturesArray1 = [self.model.doctorProfessionImageUrl componentsSeparatedByString:@","];
        self.authenticationPicturesArray2 = [self.model.professionalQualificationImageUrl componentsSeparatedByString:@","];
    }
    [self.tableView reloadData];
    [self fetchCities];
    [self fetchTitles];
    
}

#pragma mark - Request
//获取认证消息
- (void)fetchInformations {
//    [InformationModel fetchInformations:^(id object, NSString *msg) {
//        if (msg) {
//            XLDismissHUD(self.view, YES, NO, msg);
//        } else {
//            self.model = (InformationModel *)object;
//            [self checkEditable];
//            [self refreshInformations];
//        }
//    }];
}

//上传认证图片
- (void)uploadAuthenticationPictures {
//    if ([self.selectedTitleModel.titleId integerValue] == 5 || [self.selectedTitleModel.titleId integerValue] == 6) {
//        [InformationModel uploadAuthenticationImages:self.authenticationPicturesArray1 fileType:@2 handler:^(id object, NSString *msg) {
//            if (object && [object isKindOfClass:[NSArray class]]) {
//                self.authenticationPicturesUrlArray1 = (NSArray *)object;
//                [InformationModel uploadAuthenticationImages:self.authenticationPicturesArray2 fileType:@3 handler:^(id object, NSString *msg) {
//                    if (object && [object isKindOfClass:[NSArray class]]) {
//                        self.authenticationPicturesUrlArray2 = (NSArray *)object;
//                        [self uploadInformations];
//                    } else {
//                        XLDismissHUD(self.view, YES, NO, msg);
//                    }
//                }];
//            } else {
//                XLDismissHUD(self.view, YES, NO, msg);
//            }
//        }];
//    } else {
//        [InformationModel uploadAuthenticationImages:self.authenticationPicturesArray1 fileType:@4 handler:^(id object, NSString *msg) {
//            if (object && [object isKindOfClass:[NSArray class]]) {
//                self.authenticationPicturesUrlArray1 = (NSArray *)object;
//                [InformationModel uploadAuthenticationImages:self.authenticationPicturesArray2 fileType:@5 handler:^(id object, NSString *msg) {
//                    if (object && [object isKindOfClass:[NSArray class]]) {
//                        self.authenticationPicturesUrlArray2 = (NSArray *)object;
//                        [self uploadInformations];
//                    } else {
//                        XLDismissHUD(self.view, YES, NO, msg);
//                    }
//                }];
//            } else {
//                XLDismissHUD(self.view, YES, NO, msg);
//            }
//        }];
//    }
}
//提交认证信息
- (void)uploadInformations {
    InformationModel *tempModel = [[InformationModel alloc] init];
    tempModel.realname = self.nameString;
    tempModel.gender = @(self.sex);
    tempModel.region = self.selectedCityModel.code;
    tempModel.regionFullName = self.selectedCityModel.fullName;
    tempModel.professionalTitleId = self.selectedTitleModel.titleId;
    tempModel.workplaceType = _isHospital ? @1 : @2;
    if (_isHospital) {
        tempModel.hospital = self.hospitalString;
        tempModel.department = self.departmentString;
    } else {
        tempModel.hospital = self.clinicString;
        tempModel.position = self.positionString;
    }
    tempModel.headPictureUrl = self.personalImageUrl;
    tempModel.introduction = self.introductionString;
    tempModel.expertise = self.selectedSpecialits;
    NSString *urlString1 = [self.authenticationPicturesUrlArray1 componentsJoinedByString:@","];
    NSString *urlString2 = [self.authenticationPicturesUrlArray2 componentsJoinedByString:@","];
    if ([self.selectedTitleModel.titleId integerValue] == 5 || [self.selectedTitleModel.titleId integerValue] == 6) {
        tempModel.psychologicalConsultantImageUrl = urlString1;
        tempModel.employeeImageUrl = urlString2;
    } else {
        tempModel.doctorProfessionImageUrl = urlString1;
        tempModel.professionalQualificationImageUrl = urlString2;
    }
//    [InformationModel uploadInformations:tempModel handler:^(id object, NSString *msg) {
//        if (object) {
//            XLDismissHUD(self.view, YES, YES, @"提交成功");
//            if (self.selectedPersonalImage) {
//                NSData *headData = UIImageJPEGRepresentation(self.selectedPersonalImage, 1.0);
//                [[NSUserDefaults standardUserDefaults] setObject:headData forKey:USERAVATARDATA];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//            }
//            [self performSelector:@selector(popView) withObject:nil afterDelay:1.5];
//        } else {
//            XLDismissHUD(self.view, YES, NO, msg);
//        }
//    }];
}
//获取城市列表
- (void)fetchCities {
//    [ProvincesModel fetchAreas:^(id object, NSString *msg) {
//        if (object) {
//            self.areasArray = [object copy];
//            [self.cityView resetContents:self.areasArray selectedCity:self.selectedCityModel];
//        }
//    }];
}
//获取职称
- (void)fetchTitles {
//    [TitlesModel professionalTitles:^(id object, NSString *msg) {
//        if (object) {
//            self.professionalTitlesArray = [object copy];
//            [self.titlesPickerView resetContents:self.professionalTitlesArray selected:self.selectedTitleModel];
//        }
//    }];
}

#pragma mark - IBAction
- (IBAction)submitAction:(id)sender {
    if ([self checkIsCanUpload]) {
        XLShowHUDWithMessage(@"正在提交...", self.view);
        if (XLIsNullObject(self.selectedPersonalImage)) {
            self.personalImageUrl = self.model.headPictureUrl;
            [self uploadAuthenticationPictures];
        } else {
            //NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
            NSData *tempData = UIImageJPEGRepresentation(self.selectedPersonalImage, 1.0);
            if (tempData.length > 300 * 1024) {
                CGFloat rate = 300.0 * 1024.0 / tempData.length;
                tempData = UIImageJPEGRepresentation(self.selectedPersonalImage, rate);
            }
//            [InformationModel uploadCommonImage:tempName fileType:@1 data:tempData handler:^(id object, NSString *msg) {
//                if (object) {
//                    NSDictionary *tempDictionary = (NSDictionary *)object;
//                    self.personalImageUrl = tempDictionary[@"imageUrl"];
//                    GJCFAsyncMainQueue(^{
//                        [self uploadAuthenticationPictures];
//                    });
//                } else {
//                    XLDismissHUD(self.view, YES, NO, msg);
//                }
//                
//            }];
        }
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
        _nameString = textField.text;
    } else {
        if (_isHospital) {
            if (textField.tag == 110) {
                _hospitalString = textField.text;
            } else if (textField.tag == 111) {
                _departmentString = textField.text;
            }
        } else {
            if (textField.tag == 110) {
                _clinicString = textField.text;
            } else if (textField.tag == 111) {
                _positionString = textField.text;
            }
        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
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
                cell.contentTextField.text = self.nameString;
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
                if (!XLIsNullObject(self.selectedCityModel.code)) {
                    cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.selectedCityModel.fullName];
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
                if (!XLIsNullObject(self.selectedTitleModel.titleId)) {
                    cell.contentTextField.text = [NSString stringWithFormat:@"%@", self.selectedTitleModel.name];
                }
                return cell;
            }
                break;
            default:
                return nil;
                break;
        }
    } else if (indexPath.section == 1) {
        AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.headLabel.text = _headTitleArray[indexPath.row + 4];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.contentTextField.tag = 110 + indexPath.row;
        cell.contentTextField.placeholder = @"必输";
        [cell.contentTextField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
        if (_isHospital) {
            if (indexPath.row == 0) {
                cell.contentTextField.text = _hospitalString;
            } else {
                cell.contentTextField.text = _departmentString;
            }
        } else {
            if (indexPath.row == 0) {
                cell.contentTextField.text = _clinicString;
            } else {
                cell.contentTextField.text = _positionString;
            }
        }
        cell.contentTextField.enabled = _editable ? YES : NO;
        return cell;

    } else {
        AuthenticationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.headLabel.text = _headTitleArray[indexPath.row + 6];
        cell.contentTextField.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.contentTextField.placeholder = indexPath.row == 0 ? @"完善资料" : @"认证信息";
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.section == 2) {
//        if (indexPath.row == 0) {
//            EditInformationViewController *editViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditInformation"];
//            editViewController.editable = _editable;
//            editViewController.introductionString = self.introductionString;
//            editViewController.selectedAvatarImage = self.selectedPersonalImage;
//            editViewController.specialitsString = self.selectedSpecialits;
//            editViewController.avatarUrl = self.model.headPictureUrl;
//            editViewController.finishBlock = ^(UIImage *image, NSString *introduction, NSString *specialits) {
//                if (!XLIsNullObject(image)) {
//                    self.selectedPersonalImage = image;
//                }
//                self.introductionString = introduction;
//                self.selectedSpecialits = specialits;
//            };
//            [self.navigationController pushViewController:editViewController animated:YES];
//        } else {
//            if (XLIsNullObject(self.selectedTitleModel)) {
//                XLDismissHUD(self.view, YES, NO, @"请先选择您的职称");
//                return;
//            }
//            AuthenticationPicturesViewController *picturesViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AuthenticationPicturesView"];
//            picturesViewController.editable = _editable;
//            picturesViewController.titleModel = self.selectedTitleModel;
//            picturesViewController.array1 = [self.authenticationPicturesArray1 mutableCopy];
//            picturesViewController.array2 = [self.authenticationPicturesArray2 mutableCopy];
//            picturesViewController.block = ^(NSArray *array1, NSArray *array2) {
//                self.authenticationPicturesArray1 = [array1 copy];
//                self.authenticationPicturesArray2 = [array2 copy];
//            };
//            [self.navigationController pushViewController:picturesViewController animated:YES];
//        }
//    } else if (indexPath.section == 0) {
//        if (indexPath.row == 2) {
//            if (_editable) {
//                [self.cityView resetContents:self.areasArray selectedCity:self.selectedCityModel];
//                [UIView animateWithDuration:0.3 animations:^{
//                    self.cityView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//                }];
//            }
//        } else if (indexPath.row == 3) {
//            if (_editable) {
//                [self.titlesPickerView resetContents:self.professionalTitlesArray selected:self.selectedTitleModel];
//                [self.titlesPickerView show];
//            }
//        }
//    }
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
- (CitiesModel *)selectedCityModel {
    if (!_selectedCityModel) {
        _selectedCityModel = [[CitiesModel alloc] init];
    }
    return _selectedCityModel;
}
- (TitlesModel *)selectedTitleModel {
    if (!_selectedTitleModel) {
        _selectedTitleModel = [[TitlesModel alloc] init];
    }
    return _selectedTitleModel;
}

@end
