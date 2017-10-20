//
//  XJPlansListViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/13.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlansListViewController.h"
#import "XJPlanInformationsViewController.h"

#import "XJTopDiseasesCell.h"
#import "XJPlanCell.h"

@interface XJPlansListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) UITableView *topTableView;

@property (copy, nonatomic) NSArray *topArray;

@end

@implementation XJPlansListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topView addSubview:self.topTableView];
    self.topTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.5);
    _topArray = @[@"收藏", @"全部病症", @"失眠症", @"ADHD", @"病症", @"!!!"];
    
    self.contentTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 4;
    if (tableView == self.topTableView) {
        number = _topArray.count;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100.f;
    if (tableView == self.topTableView) {
        NSString *titleString = _topArray[indexPath.row];
        CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(14)}];
        height = titleSize.width + 25.f;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        XJTopDiseasesCell *cell = [[XJTopDiseasesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopDiseasesCell"];
        cell.transform = CGAffineTransformMakeRotation(- M_PI * 1.5);
        NSString *titleString = _topArray[indexPath.row];
        cell.contentLabel.text = titleString;
        CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(14)}];
        cell.contentLabel.frame = CGRectMake(0, 0, titleSize.width + 25.f, 44.5);
        return cell;
    } else {
        XJPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCell" forIndexPath:indexPath];
        cell.selectButton.hidden = NO;
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {\
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    XJPlanInformationsViewController *informationsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanInformations"];
    [self.navigationController pushViewController:informationsController animated:YES];
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
- (UITableView *)topTableView {
    if (!_topTableView) {
        _topTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _topTableView.showsVerticalScrollIndicator = NO;
        _topTableView.showsHorizontalScrollIndicator = NO;
        _topTableView.backgroundColor = [UIColor clearColor];
        _topTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _topTableView.delegate = self;
        _topTableView.dataSource = self;
        _topTableView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    }
    return _topTableView;
    
}
@end
