//
//  XJPlanEditViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/1.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanEditViewController.h"
#import "XJPlanItemEditTableViewController.h"
#import "XJScenesListViewController.h"
#import "XJPatientDetailViewController.h"

#import "XJPlanGridView.h"
#import "XJPlanItemCell.h"
#import "XJDiseasePickerView.h"

#import "XJPlanModel.h"
#import "DiseaseModel.h"

@interface XJPlanEditViewController ()<UITableViewDelegate, UITableViewDataSource, XJPlanGridViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XJPlanGridView *gridView;
@property (strong, nonatomic) XJDiseasePickerView *diseasePickerView;

@property (copy, nonatomic) NSArray *diseaseArray;

@end

@implementation XJPlanEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [XJKeyWindow addSubview:self.diseasePickerView];
    GJCFWeakSelf weakSelf = self;
    self.diseasePickerView.selectBlock = ^(DiseaseModel *model) {
        GJCFStrongSelf strongSelf = weakSelf;
        if (model) {
            strongSelf.planModel.diseaseId = model.diseaseId;
            strongSelf.planModel.diseaseName = model.diseaseName;
            [strongSelf.tableView reloadData];
        }
    };
    [self fetchDiseases];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)fetchDiseases {
    [DiseaseModel fetchDiseasesList:^(id object, NSString *msg) {
        if (object) {
            _diseaseArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.diseasePickerView addData:_diseaseArray];
                for (NSInteger i = 0; i < _diseaseArray.count; i ++) {
                    DiseaseModel *tempModel = _diseaseArray[i];
                    if ([tempModel.diseaseId isEqualToString:self.planModel.diseaseId]) {
                        [self.diseasePickerView selectRow:i];
                    }
                }
            });
        }
    }];
}

#pragma mark - IBAction
- (IBAction)sendAction:(id)sender {
    XLShowHUDWithMessage(@"正在发送", XJKeyWindow);
    [XJPlanModel sendPlan:self.planModel patientId:self.patientId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(XJKeyWindow, YES, YES, @"发送成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                NSArray *viewControllers = self.navigationController.viewControllers;
                for (UIViewController *viewController in viewControllers) {
                    if ([viewController isKindOfClass:[XJPatientDetailViewController class]]) {
                        [self.navigationController popToViewController:viewController animated:YES];
                    }
                }
            });
        } else {
            XLDismissHUD(XJKeyWindow, YES, NO, msg);
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Grid view delegate
- (void)gridViewDidClickCell:(NSInteger)index {
    XJScenesListViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"ScenesList"];
    contentsViewController.viewType = 2;
    contentsViewController.chooseSceneBlock = ^(ContentModel *model) {
        NSMutableArray *tempArray = [self.planModel.contents mutableCopy];
        [tempArray replaceObjectAtIndex:index withObject:model];
        self.planModel.contents = [tempArray copy];
        GJCFAsyncMainQueue(^{
            [self.tableView reloadData];
        });
    };
    [self.navigationController pushViewController:contentsViewController animated:YES];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 50.f;
            break;
        case 1:
            height = 50.f;
            break;
        case 2: {
            NSString *instructionString = @"暂无";
            if (!XLIsNullObject(self.planModel.instruction)) {
                instructionString = self.planModel.instruction;
            }
            CGSize size = XLSizeOfText(instructionString, SCREEN_WIDTH - 115, XJSystemFont(14));
            height = size.height + 40.f;
        }
            break;
        case 3: {
            height = (self.planModel.times.integerValue + 1) * 60.f;
        }
            break;
        default:
            break;
    }
    return height;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath { 
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanGridCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.gridView];
        [self.gridView setupContents:self.planModel.times.integerValue scenes:self.planModel.scenes.integerValue contents:self.planModel.contents canEdit:YES];
        self.gridView.delegate = self;
        return cell;
    } else {
        XJPlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell" forIndexPath:indexPath];
        NSString *leftString = nil;
        NSString *rightString = nil;
        switch (indexPath.section) {
            case 0: {
                leftString = @"方案名";
                rightString = self.planModel.name;
            }
                break;
            case 1: {
                leftString = @"病症";
                rightString = self.planModel.diseaseName;
            }
                break;
            case 2: {
                leftString = @"说明";
                if (XLIsNullObject(self.planModel.instruction)) {
                    rightString = @"暂无";
                } else {
                    rightString = self.planModel.instruction;
                }
            }
            default:
                break;
        }
        cell.leftLabel.text = leftString;
        cell.rightLabel.text = rightString;
        return cell;
    }
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        if (_diseaseArray.count > 0) {
            [self.diseasePickerView show];
        }
    } else {
        XJPlanItemEditTableViewController *itemEditController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanItemEdit"];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:itemEditController];
        if (indexPath.section == 0) {
            itemEditController.itemType = XJPlanEditItemName;
            itemEditController.editString = self.planModel.name;
        } else {
            itemEditController.itemType = XJPlanEditItemInstruction;
            itemEditController.editString = self.planModel.instruction;
        }
        itemEditController.finishBlock = ^(NSString *resultString) {
            if (indexPath.section == 0) {
                self.planModel.name = resultString;
            } else {
                self.planModel.instruction = resultString;
            }
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        };
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    
    
}

#pragma mark - Getters
- (XJPlanGridView *)gridView {
    if (!_gridView) {
        _gridView = [[XJPlanGridView alloc] initWithFrame:CGRectZero];
    }
    return _gridView;
}
- (XJDiseasePickerView *)diseasePickerView {
    if (!_diseasePickerView) {
        _diseasePickerView = [[XJDiseasePickerView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _diseasePickerView;
}


@end
