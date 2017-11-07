//
//  XJHistoricalPrescriptionsViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/20.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJHistoricalPrescriptionsViewController.h"
#import "XJPlanInformationsViewController.h"
//#import "PrescriptionCell.h"
#import "XJHistoricalPlanCell.h"
#import "XLAlertControllerObject.h"

#import "PrescriptionModel.h"
#import "PatientModel.h"
#import "UserModel.h"
#import "XJPlanModel.h"

#import <MJRefresh.h>

@interface XJHistoricalPrescriptionsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation XJHistoricalPrescriptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self prescriptionsListRequest];
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self prescriptionsListRequest];
    }]];
    self.tableView.mj_footer.automaticallyHidden = YES;
    _paging = 1;
    XLShowHUDWithMessage(nil, self.view);
    [self prescriptionsListRequest];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)prescriptionsListRequest {
    [PrescriptionModel historicalPrescriptions:self.patientId paging:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.dataArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.dataArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.dataArray = [tempArray mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
                if (self.dataArray.count == 0) {
                    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
                    label.font = XJBoldSystemFont(17);
                    label.textColor = [UIColor lightGrayColor];
                    label.text = @"暂无历史处方";
                    label.textAlignment = NSTextAlignmentCenter;
                    self.tableView.tableFooterView = label;
                    self.tableView.mj_header.hidden = YES;
                } else {
                    self.tableView.tableFooterView = [UIView new];
                    self.tableView.mj_header.hidden = NO;
                }
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    _paging += 1;
                }
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"HistoricalPlanCell";
    XJHistoricalPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    XJPlanModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    cell.diseaseLabel.text = [NSString stringWithFormat:@"%@", model.diseaseName];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", [model.createdAt substringToIndex:16]];
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XJPlanModel *model = self.dataArray[indexPath.row];
    XJPlanInformationsViewController *informationsController = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"PlanInformations"];
    informationsController.isView = YES;
    informationsController.isPatientsPlan = YES;
    informationsController.planModel = model;
    [self.navigationController pushViewController:informationsController animated:YES];
}

#pragma mark - Getters
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
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
