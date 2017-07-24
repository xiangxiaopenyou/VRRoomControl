//
//  PrescriptionDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/9.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "PrescriptionDetailViewController.h"

#import "PrescriptionDetailInformationCell.h"
#import "PrescriptionDetailContentCell.h"
#import "PrescriptionPriceCell.h"
#import "PrescriptionModel.h"
#import "ContentModel.h"

@interface PrescriptionDetailViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *payStateLabel;
@property (strong, nonatomic) PrescriptionModel *model;

@end

@implementation PrescriptionDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self fetchDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
- (void)fetchDetail {
    XLShowHUDWithMessage(nil, self.view);
    [PrescriptionModel prescriptionDetail:self.prescriptionId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.model = (PrescriptionModel *)object;
            GJCFAsyncMainQueue((^{
                //self.orderNumberLabel.text = self.model.billno;
                self.orderNumberLabel.text = [NSString stringWithFormat:@"订单号：%@", self.model.billno];
                NSString *payStateString;
                if (self.model.payStatus.integerValue == 1) {
                    payStateString = @"待付款";
                    self.payStateLabel.textColor = XJHexRGBColorWithAlpha(0xEC0202, 1);
                } else if (self.model.payStatus.integerValue == 2) {
                    payStateString = @"已付款";
                    self.payStateLabel.textColor = NAVIGATIONBAR_COLOR;
                } else if (self.model.payStatus.integerValue == 3) {
                    payStateString = @"已取消";
                    self.payStateLabel.textColor = XJHexRGBColorWithAlpha(0xEC0202, 1);
                } else {
                    payStateString = @"线下支付";
                    self.payStateLabel.textColor = NAVIGATIONBAR_COLOR;
                }
                self.payStateLabel.text = payStateString;
                [self.tableView reloadData];
            }));
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
#pragma mark - Action
- (IBAction)serviceAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001667866"]];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.model ? 4 : 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.section) {
        case 0:
            height = 20 + XLSizeOfText(self.model.disease, SCREEN_WIDTH - 30, XJSystemFont(14)).height;
            break;
        case 1:
            height = 20 + XLSizeOfText(self.model.suggestion, SCREEN_WIDTH - 30, XJSystemFont(14)).height;
            break;
        case 2:
            height = 90.f * self.model.prescriptionContentList.count;
            break;
        case 3:
            height = 50.f;
            break;
            
        default:
            break;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:{
            static NSString *identifier = @"DetailInformationCell";
            PrescriptionDetailInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", self.model.disease];
            return cell;
        }
            
            break;
        case 1:{
            static NSString *identifier = @"DetailInformationCell";
            PrescriptionDetailInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentLabel.text = [NSString stringWithFormat:@"%@", self.model.suggestion];
            return cell;
        }
            break;
        case 2:{
            static NSString *identifier = @"PrescriptionDetailContentCell";
            PrescriptionDetailContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            NSArray *tempArray = [ContentModel setupWithArray:self.model.prescriptionContentList];
            [cell resetContents:tempArray];
            return cell;
        }
            break;
        case 3:{
            static NSString *identifier = @"PrescriptionPriceCell";
            PrescriptionPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.priceLabel.text = [NSString stringWithFormat:@"%.2f", [self.model.total floatValue]];
            return cell;
        }
            break;
            
        default:
            return [UITableViewCell new];
            break;
    }
}

#pragma mark - UITableViewDelegae
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
    headerLabel.font = XJSystemFont(14);
    headerLabel.textColor = [UIColor blackColor];
    NSString *title;
    switch (section) {
        case 0:
            title = @"病症";
            break;
        case 1:
            title = @"医嘱";
            break;
        case 2:
            title = @"内容";
            break;
        case 3:
            title = @"总价";
            break;
            
        default:
            break;
    }
    headerLabel.text = title;
    [headerView addSubview:headerLabel];
    return headerView;
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
