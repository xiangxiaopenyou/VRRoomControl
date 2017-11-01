//
//  XJPlanInformationsViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/18.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanInformationsViewController.h"
#import "XJPlanItemCell.h"
#import "XJPlanGridView.h"

#import "XJPlanModel.h"

@interface XJPlanInformationsViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) XJPlanGridView *gridView;

@end

@implementation XJPlanInformationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.planModel.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanGridCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:self.gridView];
        [self.gridView setupContents:self.planModel.times.integerValue scenes:self.planModel.scenes.integerValue contents:self.planModel.contents canEdit:NO];
        return cell;
    } else {
        XJPlanItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getters
- (XJPlanGridView *)gridView {
    if (!_gridView) {
        _gridView = [[XJPlanGridView alloc] initWithFrame:CGRectZero];
    }
    return _gridView;
}

@end
