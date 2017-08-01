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
#import "PrescriptionContentsCell.h"
#import "PrescriptionPriceCell.h"

#import "ContentModel.h"
#import "UserModel.h"
#import "PrescriptionModel.h"

#import "UtilDefine.h"
#import "CommonsDefines.h"


@interface WritePrescriptionViewController ()<UITableViewDelegate, UITableViewDataSource, PrescriptionContentsCellDelegate, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextView *adviceTextView;
@property (weak, nonatomic) IBOutlet UITextView *diseaseTextView;

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

#pragma mark - private methods
- (void)hideKeyboard {
    [self.adviceTextView resignFirstResponder];
    [self.diseaseTextView resignFirstResponder];
}

#pragma mark - UITextField Delegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    const char *ch = [string cStringUsingEncoding:NSUTF8StringEncoding];
//    if ([textField.text rangeOfString:@"."].length == 1) {
//        if (*ch == 0) {
//            return YES;
//        }
//        NSUInteger length = [textField.text rangeOfString:@"."].location;
//        if ([[textField.text substringFromIndex:length] length] > 2 || *ch == 46) {
//            return NO;
//        }
//    }
//    return YES;
//}

#pragma mark - PrescriptionContentsCellDelegate
- (void)didClickAddContent {
    SceneContentsViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"SceneContents"];
    contentsViewController.viewType = 2;
    contentsViewController.selectedArray = [self.contentsArray copy];
    contentsViewController.pickBlock = ^(NSArray *array) {
        self.contentsArray = [array mutableCopy];
    };
    [self.navigationController pushViewController:contentsViewController animated:YES];
}
- (void)didDeleteContent:(NSArray *)contentsArray {
    self.contentsArray = [contentsArray mutableCopy];
    [self.tableView reloadData];
}
- (void)didSetContentCycle:(NSArray *)contentsArray {
    self.contentsArray = [contentsArray mutableCopy];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 90.f * self.contentsArray.count + 105;
    } else {
        return 90.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *identifier = @"PrescriptionContentsCell";
        PrescriptionContentsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell resetContents:self.contentsArray];
        return cell;
    } else {
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
//- (void)addContentsAction {
//    ChooseContentsViewController *contentsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ChooseContents"];
//    contentsViewController.contentArray = [self.contentsArray mutableCopy];
//    contentsViewController.saveBlock = ^(NSArray *array) {
//        NSArray *tempArray = [array copy];
//        self.contentsArray = [tempArray mutableCopy];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self resetViewOfContents];
//        });
//    };
//    [self.navigationController pushViewController:contentsViewController animated:YES];
//}

#pragma mark - Getters
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
}

@end
