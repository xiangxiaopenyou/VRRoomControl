//
//  WritePrescriptionViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/10.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "WritePrescriptionViewController.h"
#import "SceneContentsViewController.h"

#import "XLBlockAlertView.h"
#import "ContentsItemCell.h"
#import "XJAddContentCell.h"
#import "PrescriptionPriceCell.h"
#import "AdjustCycleView.h"

#import "ContentModel.h"
#import "UserModel.h"
#import "PrescriptionModel.h"

#import "UtilDefine.h"
#import "CommonsDefines.h"

#import <UIImageView+WebCache.h>


@interface WritePrescriptionViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UITextView *diseaseTextView;
@property (strong, nonatomic) AdjustCycleView *cycleView;

@property (strong, nonatomic) NSMutableArray *contentsArray;

@end

@implementation WritePrescriptionViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //[self fetchPrice];
    [self.diseaseTextView becomeFirstResponder];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self hideKeyboard];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Requests
- (void)sendPrescription {
    XLShowHUDWithMessage(nil, self.view);
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.leftBarButtonItem.enabled = NO;
    CGFloat price = 0;
    NSMutableArray *list = [[NSMutableArray alloc] init];
    for (ContentModel *tempModel in self.contentsArray) {
        NSInteger times = tempModel.frequency.integerValue * tempModel.period.integerValue;
        [list addObject:@{@"contentId" : tempModel.id,
                         @"frequency" : tempModel.frequency,
                         @"period" : tempModel.period,
                         @"periodUnit" : tempModel.periodUnit,
                          @"times" : @(times)}];
        price += tempModel.price.floatValue * times;
    }
    NSString *doctorId = [[NSUserDefaults standardUserDefaults] stringForKey:USERID];
    PrescriptionModel *model = [[PrescriptionModel alloc] init];
    model.doctorId = doctorId;
    model.patientId = self.patientId;
    model.disease = self.diseaseTextView.text;
    model.suggestion = self.adviceTextView.text;
    model.total = @(price);
    model.prescriptionContentList = list;
    [UserModel sendPrescription:model handler:^(id object, NSString *msg) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        self.navigationItem.leftBarButtonItem.enabled = YES;
        if (object && object[@"prescriptionId"]) {
            XLDismissHUD(XJKeyWindow, YES, YES, @"发送成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction & Selector
- (IBAction)submitAction:(id)sender {
    [self hideKeyboard];
    if (XLIsNullObject(self.diseaseTextView.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先写好病症描述");
        return;
    }
    if (XLIsNullObject(self.adviceTextView.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先写好医嘱");
        return;
    }
    if (self.contentsArray.count <= 0) {
        XLDismissHUD(self.view, YES, NO, @"请先添加内容");
        return;
    }
    BOOL isSetCycle = YES;
    for (ContentModel *tempModel in self.contentsArray) {
        if (tempModel.frequency.integerValue <= 0) {
            isSetCycle = NO;
        }
    }
    if (!isSetCycle) {
        XLDismissHUD(self.view, YES, NO, @"请先给每个内容设置周期");
        return;
    }
    [self sendPrescription];
}
- (void)resetCycleAction:(UIButton *)button {
    [self hideKeyboard];
    [self.cycleView show];
    __block ContentModel *tempModel = self.contentsArray[button.tag - 1000];
    [self.cycleView reloadContents:tempModel];
    GJCFWeakSelf weakSelf = self;
    self.cycleView.submitBlock = ^(ContentModel *model) {
        tempModel = model;
        [weakSelf.contentsArray replaceObjectAtIndex:button.tag - 1000 withObject:tempModel];
        GJCFAsyncMainQueue(^{
            [weakSelf.tableView reloadData];
        });
    };
}

#pragma mark - private methods
- (void)hideKeyboard {
    [self.adviceTextView resignFirstResponder];
    [self.diseaseTextView resignFirstResponder];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count + 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == self.contentsArray.count ? 45.f : 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.contentsArray.count + 1) {
        static NSString *identifier = @"PrescriptionPriceCell";
        PrescriptionPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        CGFloat price = 0;
        for (ContentModel *tempModel in self.contentsArray) {
            NSInteger times = tempModel.frequency.integerValue * tempModel.period.integerValue;
            price += tempModel.price.floatValue * times;
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", price];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.row == self.contentsArray.count) {
        static NSString *identifier = @"AddContentCell";
        XJAddContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        static NSString *identifier = @"ContentsItemCell";
        ContentsItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ContentModel *tempModel = self.contentsArray[indexPath.row];
        [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
        cell.contentNameLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
        cell.contentPriceLabel.text = [NSString stringWithFormat:@"￥%.2f", [tempModel.price floatValue]];
        if (tempModel.frequency.integerValue > 0) {
            cell.contentCycleLabel.hidden = NO;
            NSString *unit = @"日";
            switch ([tempModel.periodUnit integerValue]) {
                case 1:
                    unit = @"日";
                    break;
                case 2:
                    unit = @"周";
                    break;
                case 3:
                    unit = @"月";
                    break;
                default:
                    break;
            }
            NSInteger count = tempModel.frequency.integerValue * tempModel.period.integerValue;
            cell.contentCycleLabel.text = [NSString stringWithFormat:@"%@次/%@-共%@%@-共%@次", tempModel.frequency, unit, tempModel.period, unit, @(count)];
        } else {
            cell.contentCycleLabel.hidden = YES;
        }
        cell.resetCycleButton.tag = 1000 + indexPath.row;
        [cell.resetCycleButton addTarget:self action:@selector(resetCycleAction:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.contentsArray.count) {
        SceneContentsViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"SceneContents"];
        contentsViewController.viewType = 2;
        contentsViewController.selectedArray = [self.contentsArray copy];
        contentsViewController.pickBlock = ^(NSArray *array) {
            self.contentsArray = [array mutableCopy];
        };
        [self.navigationController pushViewController:contentsViewController animated:YES];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.contentsArray.count) {
        return YES;
    }
    return NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.contentsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
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
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
}
- (AdjustCycleView *)cycleView {
    if (!_cycleView) {
        _cycleView = [[AdjustCycleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _cycleView;
}
@end
