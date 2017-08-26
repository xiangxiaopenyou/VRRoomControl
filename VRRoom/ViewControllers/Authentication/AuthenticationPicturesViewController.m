//
//  AuthenticationPicturesViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AuthenticationPicturesViewController.h"

#import "AuthenticationPicturesCell.h"
#import "InformationModel.h"
#import <UIImageView+WebCache.h>


@interface AuthenticationPicturesViewController ()<UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

@property (strong, nonatomic) UIImage *personalImage;
@property (strong, nonatomic) UIImage *image1;
@property (strong, nonatomic) UIImage *image2;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;

@end

@implementation AuthenticationPicturesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self checkPictures];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
- (void)presentImagePickerController:(UIImagePickerControllerSourceType)type {
    UIImagePickerController *pickerController = [[UIImagePickerController alloc] init];
    pickerController.delegate = self;
    pickerController.sourceType = type;
    pickerController.mediaTypes = @[(NSString *)kUTTypeImage];
    pickerController.allowsEditing = YES;
    [self presentViewController:pickerController animated:YES completion:nil];
}
- (void)checkPictures {
    self.submitButton.hidden = !self.editable;
}
- (void)popView {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - IBAction
- (IBAction)finishAction:(id)sender {
    if (!_personalImage && !self.informationModel.headPictureUrl) {
        XLDismissHUD(self.view, YES, NO, @"请先上传个人照片");
        return;
    }
    if ([self.informationModel.professionalTitleId integerValue] == 5 || [self.informationModel.professionalTitleId integerValue] == 6) {
        if (!_image1 && !self.informationModel.psychologicalConsultantImageUrl) {
            XLDismissHUD(self.view, YES, NO, @"请先上传心理咨询师证照片");
            return;
        }
        if (!_image2 && !self.informationModel.employeeImageUrl) {
            XLDismissHUD(self.view, YES, NO, @"请先上传工作证照片");
            return;
        }
    } else {
        if (!_image1 && !self.informationModel.doctorProfessionImageUrl) {
            XLDismissHUD(self.view, YES, NO, @"请先上传医师资格证照片");
            return;
        }
        if (!_image2 && !self.informationModel.professionalQualificationImageUrl) {
            XLDismissHUD(self.view, YES, NO, @"请先上传职业资格证照片");
            return;
        }
    }
    XLShowHUDWithMessage(@"正在提交...", self.view);
    if (_personalImage) {
        [InformationModel uploadCommonImage:_personalImage fileType:@1 handler:^(id object, NSString *msg) {
            if (object) {
                NSDictionary *tempDictionary = (NSDictionary *)object;
                self.informationModel.headPictureUrl = tempDictionary[@"imageUrl"];
                GJCFAsyncMainQueue(^{
                    [self uploadAuthenticationPictures];
                });
            } else {
                XLDismissHUD(self.view, YES, NO, msg);
            }
            
        }];
    } else {
        [self uploadAuthenticationPictures];
    }
    
}

#pragma mark - Requests
//上传认证图片
- (void)uploadAuthenticationPictures {
    if ([self.informationModel.professionalTitleId integerValue] == 5 || [self.informationModel.professionalTitleId integerValue] == 6) {
        if (_image1) {
            [InformationModel uploadCommonImage:_image1 fileType:@2 handler:^(id object, NSString *msg) {
                if (object) {
                    self.informationModel.psychologicalConsultantImageUrl = object[@"imageUrl"];
                    if (_image2) {
                        [InformationModel uploadCommonImage:_image2 fileType:@3 handler:^(id object, NSString *msg) {
                            if (object) {
                                self.informationModel.employeeImageUrl = object[@"imageUrl"];
                                [self uploadInformations];
                            } else {
                                XLDismissHUD(self.view, YES, NO, msg);
                            }
                        }];
                    } else {
                        [self uploadInformations];
                    }
                } else {
                    XLDismissHUD(self.view, YES, NO, msg);
                }
            }];
        } else {
            if (_image2) {
                [InformationModel uploadCommonImage:_image2 fileType:@3 handler:^(id object, NSString *msg) {
                    if (object) {
                        self.informationModel.employeeImageUrl = object[@"imageUrl"];
                        [self uploadInformations];
                    } else {
                        XLDismissHUD(self.view, YES, NO, msg);
                    }
                }];
            } else {
                [self uploadInformations];
            }
        }
    } else {
        if (_image1) {
            [InformationModel uploadCommonImage:_image1 fileType:@4 handler:^(id object, NSString *msg) {
                if (object) {
                    self.informationModel.doctorProfessionImageUrl = object[@"imageUrl"];
                    if (_image2) {
                        [InformationModel uploadCommonImage:_image2 fileType:@5 handler:^(id object, NSString *msg) {
                            if (object) {
                                self.informationModel.professionalQualificationImageUrl = object[@"imageUrl"];
                                [self uploadInformations];
                            } else {
                                XLDismissHUD(self.view, YES, NO, msg);
                            }
                        }];
                    } else {
                        [self uploadInformations];
                    }
                } else {
                    XLDismissHUD(self.view, YES, NO, msg);
                }
            }];
        } else {
            if (_image2) {
                [InformationModel uploadCommonImage:_image2 fileType:@5 handler:^(id object, NSString *msg) {
                    if (object) {
                        self.informationModel.professionalQualificationImageUrl = object[@"imageUrl"];
                        [self uploadInformations];
                    } else {
                        XLDismissHUD(self.view, YES, NO, msg);
                    }
                }];
            } else {
                [self uploadInformations];
            }
        }
    }
}
//提交认证信息
- (void)uploadInformations {
    [InformationModel uploadInformations:self.informationModel handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, YES, YES, @"提交成功");
            [self performSelector:@selector(popView) withObject:nil afterDelay:1.f];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}


#pragma mark - UIImagePickerController Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resultImage = [info objectForKey:UIImagePickerControllerEditedImage];
    if (resultImage) {
        switch (_selectedIndexPath.row) {
            case 0:
                self.personalImage = resultImage;
                break;
            case 1:
                self.image1 = resultImage;
                break;
            case 2:
                self.image2 = resultImage;
                break;
            default:
                break;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AuthenticationPictures";
    AuthenticationPicturesCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.tag = 100 + indexPath.row;
    if (indexPath.row == 0) {
        cell.cardTitleLabel.text = @"个人照片";
        cell.statementLabel.text = @"请上传清晰的免冠个人照";
        cell.contentImageView.layer.masksToBounds = YES;
        cell.contentImageView.layer.cornerRadius = 25.f;
        if (self.personalImage) {
            cell.contentImageView.image = self.personalImage;
        } else {
            [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.informationModel.headPictureUrl] placeholderImage:[UIImage imageNamed:@"default_head"]];
        }
    } else {
        //cell.contentImageView.clipsToBounds = YES;
        //cell.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
        if ([self.informationModel.professionalTitleId integerValue] == 5 || [self.informationModel.professionalTitleId integerValue] == 6) {
            cell.cardTitleLabel.text = indexPath.row == 1 ? @"心理咨询师证" : @"工作证";
            cell.statementLabel.text = indexPath.row == 1 ? @"请上传清晰的心理咨询师证照片" : @"请上传清晰的工作证照片";
            if (indexPath.row == 1) {
                if (self.image1) {
                    cell.contentImageView.image = self.image1;
                } else {
                    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.informationModel.psychologicalConsultantImageUrl] placeholderImage:[UIImage imageNamed:@"default_add_picture"]];
                }
            } else {
                if (self.image2) {
                    cell.contentImageView.image = self.image2;
                } else {
                    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.informationModel.employeeImageUrl] placeholderImage:[UIImage imageNamed:@"default_add_picture"]];
                }
            }
            
        } else {
            cell.cardTitleLabel.text = indexPath.row == 1 ? @"医师资格证" : @"职称资格证";
            cell.statementLabel.text = indexPath.row == 1 ? @"请上传清晰的医师资格证照片" : @"请上传清晰的职业资格证照片";
            if (indexPath.row == 1) {
                if (self.image1) {
                    cell.contentImageView.image = self.image1;
                } else {
                    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.informationModel.doctorProfessionImageUrl] placeholderImage:[UIImage imageNamed:@"default_add_picture"]];
                }
            } else {
                if (self.image2) {
                    cell.contentImageView.image = self.image2;
                } else {
                    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:self.informationModel.professionalQualificationImageUrl] placeholderImage:[UIImage imageNamed:@"default_add_picture"]];
                }
            }
        }
        
    }
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _selectedIndexPath = indexPath;
    [self presentImagePickerController:UIImagePickerControllerSourceTypePhotoLibrary];
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
