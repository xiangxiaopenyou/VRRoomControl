//
//  XJHistoricalPrescriptionsViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/20.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJHistoricalPrescriptionsViewController.h"
#import "PrescriptionDetailViewController.h"
#import "PrescriptionCell.h"

#import "PrescriptionModel.h"
#import "PatientModel.h"

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
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        [self prescriptionsListRequest];
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self prescriptionsListRequest];
    }]];
    self.tableView.mj_footer.hidden = YES;
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
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    self.tableView.mj_footer.hidden = NO;
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
    return self.dataArray.count * 2;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row % 2 == 0 ? 10.f : 100.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeparatorCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    static NSString *identifier = @"PrescriptionCell";
    PrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    PrescriptionModel *model = self.dataArray[indexPath.row / 2];
    cell.doctorLabel.text = [NSString stringWithFormat:@"患者：%@", self.patientModel.name ? self.patientModel.name : @""];
    cell.typeLabel.text = [model.payStatus integerValue] == 4 ? @"类型：院内" : @"类型：线上";
    cell.diseaseLabel.text = [NSString stringWithFormat:@"病症：%@", model.disease ? model.disease : @""];
    cell.dateLabel.text = [NSString stringWithFormat:@"日期：%@", model.createdAt ? model.createdAt : @""];
    NSString *stateString = @" ";
    switch ([model.status integerValue]) {
        case 1:
            stateString = @"未开始";
            break;
        case 2:
            stateString = @"进行中";
            break;
        case 3:
            stateString = @"已完成";
            break;
        case 9:
            stateString = @"已中止";
            break;
        default:
            break;
    }
    cell.stateLabel.text = stateString;
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    PrescriptionModel *model = self.dataArray[indexPath.row / 2];
    PrescriptionDetailViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"Patients" bundle:nil]  instantiateViewControllerWithIdentifier:@"PrescriptionDetail"];
    contentsViewController.prescriptionId = model.id;
    [self.navigationController pushViewController:contentsViewController animated:YES];
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
