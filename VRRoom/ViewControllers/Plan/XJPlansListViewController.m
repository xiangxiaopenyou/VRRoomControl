//
//  XJPlansListViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/13.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlansListViewController.h"
#import "XJPlanInformationsViewController.h"
#import "XJPlanEditViewController.h"

#import "XJTopDiseasesCell.h"
#import "XJPlanCell.h"

#import "DiseaseModel.h"
#import "XJPlanModel.h"

#import <MJRefresh.h>

@interface XJPlansListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *contentTableView;

@property (strong, nonatomic) UITableView *topTableView;

@property (copy, nonatomic) NSArray *topArray;
@property (strong, nonatomic) NSIndexPath *selectedPlanIndexPath;
@property (assign, nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *plansArray;

@end

@implementation XJPlansListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.topView addSubview:self.topTableView];
    self.topTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.5);
    _selectedPlanIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    XLShowHUDWithMessage(nil, self.view);
    [self fetchDiseases];
    
    self.contentTableView.tableFooterView = [UIView new];
    self.contentTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        if (_selectedPlanIndexPath.row == 0) {
            [self fetchMyCollections];
        } else {
            [self fetchPlansList];
        }
    }];
    self.contentTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_selectedPlanIndexPath.row == 0) {
            [self fetchMyCollections];
        } else {
            [self fetchPlansList];
        }
    }];
    self.contentTableView.mj_footer.automaticallyHidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)fetchDiseases {
    [DiseaseModel fetchDiseasesList:^(id object, NSString *msg) {
        if (object) {
            _topArray = [object copy];
            _paging = 1;
            if (_selectedPlanIndexPath.row > 0) {
                [self fetchPlansList];
            } else {
                [self fetchMyCollections];
            }
            GJCFAsyncMainQueue(^{
                [self.topTableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)fetchPlansList {
    NSString *diseaseIdString = nil;
    if (_selectedPlanIndexPath.row > 1) {
        DiseaseModel *tempModel = _topArray[_selectedPlanIndexPath.row - 2];
        diseaseIdString = tempModel.diseaseId;
    }
    [XJPlanModel plansList:diseaseIdString paging:@(_paging) handler:^(id object, NSString *msg) {
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.plansArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.plansArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.plansArray = [tempArray mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self.contentTableView reloadData];
                if (resultArray.count < 10) {
                    [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
                    //self.contentTableView.mj_footer.hidden = YES;
                } else {
                    _paging += 1;
                }
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)fetchMyCollections {
    [XJPlanModel collectedPlansList:@(_paging) handler:^(id object, NSString *msg) {
        [self.contentTableView.mj_header endRefreshing];
        [self.contentTableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.plansArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.plansArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.plansArray = [tempArray mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self.contentTableView reloadData];
                if (resultArray.count < 10) {
                    [self.contentTableView.mj_footer endRefreshingWithNoMoreData];
                    //self.contentTableView.mj_footer.hidden = YES;
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
    NSInteger number = 0;
    if (tableView == self.topTableView) {
        number = _topArray.count + 2;
    } else {
        number = self.plansArray.count;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 100.f;
    if (tableView == self.topTableView) {
        NSString *titleString = nil;
        if (indexPath.row == 0) {
            titleString = @"收藏";
        } else if (indexPath.row == 1) {
            titleString = @"全部病症";
        } else {
            DiseaseModel *tempModel = _topArray[indexPath.row - 2];
            titleString = tempModel.diseaseName;
        }
        CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(14)}];
        height = titleSize.width + 25.f;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        XJTopDiseasesCell *cell = [[XJTopDiseasesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopDiseasesCell"];
        if (indexPath == _selectedPlanIndexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        cell.transform = CGAffineTransformMakeRotation(- M_PI * 1.5);
        NSString *titleString = nil;
        if (indexPath.row == 0) {
            titleString = @"收藏";
        } else if (indexPath.row == 1) {
            titleString = @"全部病症";
        } else {
            DiseaseModel *tempModel = _topArray[indexPath.row - 2];
            titleString = tempModel.diseaseName;
        }
        cell.contentLabel.text = titleString;
        CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(14)}];
        cell.contentLabel.frame = CGRectMake(0, 0, titleSize.width + 25.f, 44.5);
        return cell;
    } else {
        XJPlanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanCell" forIndexPath:indexPath];
        XJPlanModel *model = self.plansArray[indexPath.row];
        cell.nameLabel.text = model.name;
        [cell setupContents:model isView:self.isView];
        cell.selectBlock = ^(BOOL isSelected) {
            if (self.isView) {
                if (isSelected) {
                    [XJPlanModel collectPlan:model.id handler:^(id object, NSString *msg) {
                        if (object) {
                            model.isCollected = @(1);
                            XLDismissHUD(self.view, YES, YES, @"收藏成功");
                        } else {
                            XLDismissHUD(self.view, YES, NO, @"收藏失败");
                        }
                    }];
                } else {
                    [XJPlanModel cancelCollectPlan:model.id handler:^(id object, NSString *msg) {
                        if (object) {
                            model.isCollected = @(0);
                            XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
                            if (_selectedPlanIndexPath.row == 0) {
                                [self.plansArray removeObjectAtIndex:indexPath.row];
                                GJCFAsyncMainQueue(^{
                                    [self.contentTableView reloadData];
                                });
                            }
                        } else {
                            XLDismissHUD(self.view, YES, NO, @"取消收藏失败");
                        }
                    }];
                }
            } else {
                XJPlanEditViewController *editController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanEdit"];
                editController.planModel = model;
                editController.patientId = self.patientId;
                [self.navigationController pushViewController:editController animated:YES];
            }
        };
        
        return cell;
    }
    
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.topTableView) {
        if (indexPath != _selectedPlanIndexPath) {
            _selectedPlanIndexPath = indexPath;
            if (self.plansArray.count > 0) {
                 [self.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            }
            [self.contentTableView.mj_header beginRefreshing];
        }
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        XJPlanInformationsViewController *informationsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PlanInformations"];
        XJPlanModel *model = self.plansArray[indexPath.row];
        informationsController.planModel = model;
        informationsController.isView = self.isView;
        informationsController.patientId = self.patientId;
        informationsController.block = ^(BOOL isCollected) {
            if (isCollected) {
                model.isCollected = @1;
            } else{
                model.isCollected = @0;
            }
            GJCFAsyncMainQueue(^{
                if (_selectedPlanIndexPath.row == 0) {
                    [self.contentTableView.mj_header beginRefreshing];
                } else {
                    [self.contentTableView reloadData];
                }
            });
        };
        [self.navigationController pushViewController:informationsController animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (tableView == self.contentTableView) {
        if (self.plansArray.count == 0) {
            height = SCREEN_HEIGHT - 180.f;
        }
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.contentTableView) {
        if (self.plansArray.count == 0) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 160.f)];
            headerView.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
            label.text = @"暂无方案";
            label.font = XJBoldSystemFont(17);
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
            [headerView addSubview:label];
            return headerView;
        }
    }
    return nil;
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
- (NSMutableArray *)plansArray {
    if (!_plansArray) {
        _plansArray = [[NSMutableArray alloc] init];
    }
    return _plansArray;
}
@end
