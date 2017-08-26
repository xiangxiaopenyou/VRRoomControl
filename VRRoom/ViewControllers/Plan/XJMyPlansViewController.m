//
//  XJMyPlansViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJMyPlansViewController.h"
#import "XJPlanDetailViewController.h"
#import "XJPlanCell.h"

#import "XJPlanModel.h"

@interface XJMyPlansViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addItem;

@property (copy, nonatomic) NSArray *plansArray;

@end

@implementation XJMyPlansViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
            self.plansArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
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
    XJPlanModel *model = self.plansArray[indexPath.row];
    cell.textLabel.text = model.name;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
