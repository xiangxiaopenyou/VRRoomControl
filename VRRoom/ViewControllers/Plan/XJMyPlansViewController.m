//
//  XJMyPlansViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJMyPlansViewController.h"
#import "XJPlanDetailViewController.h"
#import "WritePrescriptionViewController.h"
#import "XJPlanCell.h"

#import "XJPlanModel.h"
#import "ContentModel.h"

@interface XJMyPlansViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;

@property (strong, nonatomic) NSMutableArray *plansArray;

@end

@implementation XJMyPlansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.viewType == 1) {
        self.navigationItem.rightBarButtonItem = self.addItem;
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.tableView.tableFooterView = [UIView new];
    XLShowHUDWithMessage(nil, self.view);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self myPlansRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)myPlansRequest {
    [XJPlanModel myPlans:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.plansArray = [object mutableCopy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)selectContents:(NSArray *)array {
    for (ContentModel *tempModel in array) {
        BOOL isContains = NO;
        for (ContentModel *model in self.selectedContentsArray) {
            if ([model.id isEqualToString:tempModel.id]) {
                isContains = YES;
            }
        }
        if (!isContains) {
            tempModel.isAdded = @(1);
            [self.selectedContentsArray addObject:tempModel];
        }
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.plansArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCell" forIndexPath:indexPath];
    cell.selectButton.hidden = self.viewType == 1 ? YES : NO;
    XJPlanModel *model = self.plansArray[indexPath.row];
    cell.nameLabel.text = model.name;
    cell.selectBlock = ^{
        NSArray *tempArray = model.contents;
        [self selectContents:tempArray];
        if (self.block) {
            self.block(self.selectedContentsArray);
        }
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[WritePrescriptionViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
    };
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XJPlanDetailViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanDetail"];
    detailController.viewType = self.viewType;
    detailController.planModel = self.plansArray[indexPath.row];
    [self.navigationController pushViewController:detailController animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.viewType == 1 ? YES : NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        XJPlanModel *model = self.plansArray[indexPath.row];
        XLShowHUDWithMessage(nil, XJKeyWindow);
        [XJPlanModel deletePlan:model.id handler:^(id object, NSString *msg) {
            if (object) {
                XLDismissHUD(XJKeyWindow, YES, YES, @"删除成功");
                [self.plansArray removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            } else {
                XLDismissHUD(XJKeyWindow, YES, NO, msg);
            }
        }];
    }
}

#pragma mark - Getters
- (NSMutableArray *)selectedContentsArray {
    if (!_selectedContentsArray) {
        _selectedContentsArray = [[NSMutableArray alloc] init];
    }
    return _selectedContentsArray;
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
