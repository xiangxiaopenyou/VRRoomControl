//
//  XJPlanDetailViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/26.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanDetailViewController.h"
#import "SceneContentsListViewController.h"
#import "SceneContentCell.h"

#import "XJPlanModel.h"
#import "ContentModel.h"

@interface XJPlanDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) UIButton *saveButton;

@property (strong, nonatomic) NSMutableArray *selectedContents;
@property (copy, nonatomic) NSString *currentNameString;

@end

@implementation XJPlanDetailViewController

#pragma mark - Life cycle methods
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.viewType == 1) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.saveButton];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }

    self.addButton.hidden = self.viewType == 1 ? NO : YES;
    for (ContentModel *tempModel in self.planModel.contents) {
        tempModel.isAdded = @(1);
    }
    self.selectedContents = [self.planModel.contents mutableCopy];
    _currentNameString = self.planModel.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)addAction:(id)sender {
    SceneContentsListViewController *listViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"SceneContentsList"];
    listViewController.viewType = 2;
    listViewController.selectedContents = [self.selectedContents mutableCopy];
    listViewController.isCollectionView = YES;
    listViewController.isAddPlan = YES;
    listViewController.selectedBlock = ^(NSArray *array) {
        self.selectedContents = [array copy];
        GJCFAsyncMainQueue(^{
            [self.tableView reloadData];
            [self refreshSaveItem];
        });
    };
    [self.navigationController pushViewController:listViewController animated:YES];
}
- (void)submitAction {
    
}

#pragma mark - Private methods
- (void)refreshSaveItem {
    if (self.selectedContents.count > 0 && _currentNameString.length > 0) {
        self.saveButton.enabled = YES;
        [self.saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    } else {
        self.saveButton.enabled = NO;
        [self.saveButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.selectedContents.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 68.f : 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanNameCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSeparatorStyleNone;
        cell.accessoryType = self.viewType == 1 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.textLabel.text = _currentNameString;
        cell.textLabel.font = XJBoldSystemFont(16);
        return cell;
    } else {
        static NSString *identifier = @"SceneContentsCell";
        SceneContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ContentModel *tempModel = _selectedContents[indexPath.row - 1];
        [cell setupContents:tempModel viewType:self.viewType];
        return cell;
    }
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0 && self.viewType == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"修改方案名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.text = _currentNameString;
            textField.placeholder = @"方案名称不能为空";
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            UITextField *nameTextField = alert.textFields.firstObject;
            if (nameTextField.text.length > 0) {
                _currentNameString = nameTextField.text;
                [self.tableView reloadData];
                [self refreshSaveItem];
            } else {
                XLDismissHUD(XJKeyWindow, YES, NO, @"方案名称不能为空");
            }
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:okAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewType == 1 ? YES : NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.selectedContents removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - Getters
- (UIButton *)saveButton {
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(0, 0, 70, 40);
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        [_saveButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
        _saveButton.enabled = NO;
        _saveButton.titleLabel.font = XJSystemFont(16);
        [_saveButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _saveButton;
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
