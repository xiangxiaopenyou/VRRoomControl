//
//  SceneContentsListViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/16.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SceneContentsListViewController.h"
#import "WritePrescriptionViewController.h"
#import "AdviceWebViewController.h"
#import "ContentDetailViewController.h"
#import "DetailNavigationController.h"
#import "SortButton.h"
#import "SceneContentCell.h"

#import "TherapyModel.h"
#import "DiseaseModel.h"
#import "ContentModel.h"

#import "UtilDefine.h"
#import "CommonsDefines.h"

#import <MJRefresh.h>
#import <GJCFUitils.h>

@interface SceneContentsListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *clickNumberButton;
@property (weak, nonatomic) IBOutlet UIButton *priceSortButton;
@property (weak, nonatomic) IBOutlet UIButton *durationSortButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *emptyTipLabel;
@property (strong, nonatomic) UIButton *submitButton;

@property (strong, nonatomic) NSMutableArray *contentsArray;

@property (assign, nonatomic) NSInteger paging;
@property (copy, nonatomic) NSString *sortName;
@property (copy, nonatomic) NSString *sortOrder;
@property (assign, nonatomic)XJSortTypes priceSort;
@property (assign, nonatomic)XJSortTypes durationSort;

@end

@implementation SceneContentsListViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    if (self.viewType == 2) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.submitButton];
        [self checkSelectedContents];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
    if (self.therapyModel) {
        self.title = self.therapyModel.therapyName;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"建议指导" style:UIBarButtonItemStylePlain target:self action:@selector(rightAction)];
        
    } else {
        if (self.isCollectionView) {
            self.title = @"常用场景";
            self.topViewHeightConstraint.constant = 0;
        } else {
            self.title = @"所有疗法";
        }
        //self.navigationItem.rightBarButtonItem = nil;
    }
    self.tableView.tableFooterView = [UIView new];
    
    _priceSort = XJSortTypesNone;
    _durationSort = XJSortTypesNone;
    
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        if (self.isCollectionView) {
            [self fetchMyCollections];
        } else {
            [self fetchContents];
        }
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.isCollectionView) {
            [self fetchMyCollections];
        } else {
            [self fetchContents];
        }
    }]];
    self.tableView.mj_footer.hidden = YES;
    _paging = 1;
    if (self.isCollectionView) {
        [self fetchMyCollections];
    } else {
        //refresh
        [self fetchContents];
    }
    XLShowHUDWithMessage(nil, self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
//- (void)rightAction {
//    AdviceWebViewController *adviceController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdviceWeb"];
//    adviceController.adviceType = XJAdviceTypeTherapy;
//    adviceController.resultId = self.therapyModel.therapyId;
//    [self.navigationController pushViewController:adviceController animated:YES];
//}

- (void)submitAction {
    if (self.selectedBlock) {
        self.selectedBlock(self.selectedContents);
    }
    if (self.isAddPlan) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        NSArray *viewControllers = self.navigationController.viewControllers;
        for (UIViewController *viewController in viewControllers) {
            if ([viewController isKindOfClass:[WritePrescriptionViewController class]]) {
                [self.navigationController popToViewController:viewController animated:YES];
            }
        }
    }
    
}
- (IBAction)clickNumberAction:(id)sender {
    _priceSort = XJSortTypesNone;
    _durationSort = XJSortTypesNone;
    self.sortOrder = nil;
    self.priceSortButton.selected = NO;
    self.durationSortButton.selected = NO;
    [self.priceSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    [self.durationSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    if (self.clickNumberButton.selected) {
        self.clickNumberButton.selected = NO;
        self.sortName = nil;
    } else {
        self.clickNumberButton.selected = YES;
        self.sortName = @"clicks";
    }
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)priceSortAction:(id)sender {
    self.clickNumberButton.selected = NO;
    self.durationSortButton.selected = NO;
    [self.durationSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    if (_priceSort == XJSortTypesNone) {
        _priceSort = XJSortTypesDescending;
        self.sortName = @"price";
        self.sortOrder = @"desc";
        self.priceSortButton.selected = YES;
        [self.priceSortButton setImage:[UIImage imageNamed:@"sort_descending"] forState:UIControlStateNormal];
    } else if (_priceSort == XJSortTypesDescending) {
        _priceSort = XJSortTypesAscending;
        self.sortName = @"price";
        self.sortOrder = @"asc";
        self.priceSortButton.selected = YES;
        [self.priceSortButton setImage:[UIImage imageNamed:@"sort_ascending"] forState:UIControlStateNormal];
    } else {
        _priceSort = XJSortTypesNone;
        self.sortName = nil;
        self.sortOrder = nil;
        self.priceSortButton.selected = NO;
        [self.priceSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    }
    [self.tableView.mj_header beginRefreshing];
}
- (IBAction)durationSortAction:(id)sender {
    self.clickNumberButton.selected = NO;
    self.priceSortButton.selected = NO;
    [self.priceSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    if (_durationSort == XJSortTypesNone) {
        _durationSort = XJSortTypesDescending;
        self.sortName = @"duration";
        self.sortOrder = @"desc";
        self.durationSortButton.selected = YES;
        [self.durationSortButton setImage:[UIImage imageNamed:@"sort_descending"] forState:UIControlStateNormal];
    } else if (_durationSort == XJSortTypesDescending) {
        _durationSort = XJSortTypesAscending;
        self.sortName = @"duration";
        self.sortOrder = @"asc";
        self.durationSortButton.selected = YES;
        [self.durationSortButton setImage:[UIImage imageNamed:@"sort_ascending"] forState:UIControlStateNormal];
    } else {
        _durationSort = XJSortTypesNone;
        self.sortName = nil;
        self.sortOrder = nil;
        self.durationSortButton.selected = NO;
        [self.durationSortButton setImage:[UIImage imageNamed:@"sort_none"] forState:UIControlStateNormal];
    }
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark - Private methods
- (void)checkSelectedContents {
    if (self.selectedContents.count > 0) {
        self.submitButton.enabled = YES;
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitButton setTitle:[NSString stringWithFormat:@"确定(%@)", @(self.selectedContents.count)] forState:UIControlStateNormal];
    } else {
        self.submitButton.enabled = NO;
        [self.submitButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"确定" forState:UIControlStateNormal];
    }

}
- (void)checkTipLabel {
    if (self.contentsArray.count == 0) {
        self.emptyTipLabel.hidden = NO;
        self.tableView.mj_header.hidden = YES;
    } else {
        self.emptyTipLabel.hidden = YES;
        self.tableView.mj_header.hidden = NO;
    }
}

#pragma mark - Requests
- (void)fetchContents {
    [ContentModel searchContents:self.diseaseModel.diseaseId
                         therapy:self.therapyModel.therapyId
                         keyword:self.keyword
                            page:@(_paging)
                        sortName:self.sortName
                       sortOrder:self.sortOrder
                         handler:^(id object, NSString *msg) {
         [self.tableView.mj_header endRefreshing];
         [self.tableView.mj_footer endRefreshing];
         if (object) {
             XLDismissHUD(self.view, NO, YES, nil);
             NSArray *tempArray = [(NSArray *)object copy];
             if (_paging == 1) {
                 self.contentsArray = [tempArray mutableCopy];
             } else {
                 NSMutableArray *array = [self.contentsArray mutableCopy];
                 [array addObjectsFromArray:tempArray];
                 self.contentsArray = [array mutableCopy];
             }
             GJCFAsyncMainQueue(^{
                 [self checkTipLabel];
                 [self.tableView reloadData];
                 if (tempArray.count < 10) {
                     [self.tableView.mj_footer endRefreshingWithNoMoreData];
                     self.tableView.mj_footer.hidden = YES;
                 } else {
                     _paging += 1;
                     self.tableView.mj_footer.hidden = NO;
                 }
             });
         } else {
             XLDismissHUD(self.view, YES, NO, msg);
         }
        
    }];
}
- (void)fetchMyCollections {
    [ContentModel fetchCollectionsList:@(_paging) handler:^(id object, NSString *msg) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            NSArray *resultArray = [object copy];
            if (_paging == 1) {
                self.contentsArray = [resultArray mutableCopy];
            } else {
                NSMutableArray *tempArray = [self.contentsArray mutableCopy];
                [tempArray addObjectsFromArray:resultArray];
                self.contentsArray = [tempArray mutableCopy];
            }
            GJCFAsyncMainQueue(^{
                [self checkTipLabel];
                [self.tableView reloadData];
                if (resultArray.count < 10) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                    self.tableView.mj_footer.hidden = YES;
                } else {
                    _paging += 1;
                    self.tableView.mj_footer.hidden = NO;
                }
            });
            
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"SceneContentsCell";
    SceneContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    __block ContentModel *tempModel = self.contentsArray[indexPath.row];
    [self.selectedContents enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ContentModel *model = (ContentModel *)obj;
        if ([model.id isEqualToString:tempModel.id]) {
            tempModel = model;
            [self.contentsArray replaceObjectAtIndex:indexPath.row withObject:tempModel];
        }
    }];
    [cell setupContents:tempModel viewType:self.viewType];
    cell.block = ^(BOOL selected) {
        if (selected) {
            if (self.viewType == 1) {
                tempModel.isCollected = @(1);
                [ContentModel collectContent:tempModel.id handler:nil];
                XLDismissHUD(self.view, YES, YES, @"收藏成功");
            } else {
                tempModel.isAdded = @(1);
                [self.selectedContents addObject:tempModel];
            }
        } else {
            if (self.viewType == 1) {
                tempModel.isCollected = @(0);
                [ContentModel cancelCollectContent:tempModel.id handler:nil];
                XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
                if (self.isCollectionView) {
                    [self.contentsArray removeObject:tempModel];
                    [self.tableView reloadData];
                }
            } else {
                tempModel.isAdded = @(0);
                [self.selectedContents removeObject:tempModel];
            }
        }
        [self checkSelectedContents];
    };
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    __block ContentModel *tempModel = self.contentsArray[indexPath.row];
    ContentDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentDetail"];
    detailViewController.viewType = self.viewType;
    detailViewController.contentModel = tempModel;
    detailViewController.collectBlock = ^(ContentModel *model) {
        [self.contentsArray replaceObjectAtIndex:indexPath.row withObject:model];
        if (self.isCollectionView) {
            if (model.isCollected.integerValue == 0) {
                [self.contentsArray removeObject:model];
                [self.tableView reloadData];
            }
        }
        if (self.viewType == 2) {
            if (model.isAdded.integerValue == 0) {
                NSMutableArray *tempArray = [self.selectedContents mutableCopy];
                [self.selectedContents enumerateObjectsUsingBlock:^(ContentModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([tempModel.id isEqualToString:obj.id]) {
                        [tempArray removeObject:obj];
                    }
                }];
                self.selectedContents = [tempArray mutableCopy];
            } else {
                [self.selectedContents addObject:model];
            }
            [self checkSelectedContents];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    };
    DetailNavigationController *navigationController = [[DetailNavigationController alloc] initWithRootViewController:detailViewController];
    navigationController.contentModel = tempModel;
    [self presentViewController:navigationController animated:YES completion:nil];
    
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
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
}
- (UIButton *)submitButton {
    if (!_submitButton) {
        _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitButton.frame = CGRectMake(0, 0, 70, 40);
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -20)];
        [_submitButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor colorWithWhite:0.8 alpha:1] forState:UIControlStateHighlighted];
        _submitButton.enabled = NO;
        _submitButton.titleLabel.font = XJSystemFont(16);
        [_submitButton addTarget:self action:@selector(submitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitButton;
}

@end
