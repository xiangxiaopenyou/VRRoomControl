//
//  XJScenesListViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/16.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJScenesListViewController.h"
#import "ContentDetailViewController.h"
#import "DetailNavigationController.h"
#import "AdviceWebViewController.h"

#import "XJSearchTitleView.h"
#import "XJTopTherapyCell.h"
#import "XJTopDiseasesCell.h"
#import "SceneContentCell.h"

#import "DiseaseModel.h"
#import "TherapyModel.h"
#import "ContentModel.h"

#import <MJRefresh.h>

@interface XJScenesListViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *diseaseView;
@property (weak, nonatomic) IBOutlet UIView *therapyView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintOfTherapy;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;

@property (strong, nonatomic) UITableView *diseaseTableView;
@property (strong, nonatomic) UITableView *therapyTableView;
@property (strong, nonatomic) UITextField *searchTextField;

@property (copy, nonatomic) NSArray *diseasesArray;
@property (strong, nonatomic) NSIndexPath *selectedDiseaseIndexPath;
@property (strong, nonatomic) NSIndexPath *selectedTherapyIndexPath;
@property (assign, nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *contentsArray;

@property (strong, nonatomic) NSMutableArray *searchResultArray;
@property (assign, nonatomic) BOOL isSearching;

@end

@implementation XJScenesListViewController

#pragma mark - UIViewController cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self createNavigationTitleView];
    
    [self.diseaseView addSubview:self.diseaseTableView];
    self.diseaseTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.5);
    [self.therapyView addSubview:self.therapyTableView];
    self.therapyTableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44.5);
    _selectedDiseaseIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    _selectedTherapyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self fetchDiseases];
    
    //场景列表
    self.tableView.tableFooterView = [UIView new];
    [self.tableView setMj_header:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _paging = 1;
        if (self.diseasesArray.count == 0) {
            [self fetchDiseases];
        } else {
            if (_selectedDiseaseIndexPath.row == 0) {
                [self fetchMyCollections];
            } else {
                [self fetchContents];
            }
        }
        
    }]];
    [self.tableView setMj_footer:[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (_selectedDiseaseIndexPath.row == 0) {
            [self fetchMyCollections];
        } else {
            [self fetchContents];
        }
    }]];
    self.tableView.mj_footer.automaticallyHidden = YES;
    
    //搜索列表
    self.searchTableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)backAction {
    if (_isSearching) {
        [_searchTextField resignFirstResponder];
        self.searchTableView.hidden = YES;
        _isSearching = NO;
        [self.searchResultArray removeAllObjects];
        self.searchTextField.text = nil;
        [self.searchTableView reloadData];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (IBAction)helpAction:(id)sender {
    AdviceWebViewController *adviceController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdviceWeb"];
    if (self.selectedDiseaseIndexPath.row == 1) {
        adviceController.adviceType = XJAdviceTypeAll;
    } else {
        DiseaseModel *tempModel = self.diseasesArray[self.selectedDiseaseIndexPath.row - 1];
        adviceController.adviceType = XJAdviceTypeDisease;
        adviceController.resultId = tempModel.diseaseId;
    }
    [self.navigationController pushViewController:adviceController animated:YES];
}

#pragma mark - PrivateMethods
- (void)createNavigationTitleView {
    XJSearchTitleView *titleView = [[XJSearchTitleView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 70, 30)];
    titleView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    titleView.layer.masksToBounds = YES;
    titleView.layer.cornerRadius = 4.0;
    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"content_search"];
    [titleView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(titleView.mas_leading).with.mas_offset(15);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.equalTo(titleView);
    }];
    [titleView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(searchImage.mas_trailing).with.mas_offset(5);
        make.top.bottom.trailing.equalTo(titleView);
    }];
    self.navigationItem.titleView = titleView;
}

#pragma mark - Request
//获取病症类型和疗法类型
- (void)fetchDiseases {
    XLShowHUDWithMessage(nil, self.view);
    [DiseaseModel fetchDiseasesAndTherapies:^(id object, NSString *msg) {
        if (object) {
            //XLDismissHUD(self.view, NO, YES, nil);
            self.diseasesArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.diseaseTableView reloadData];
                [self.therapyTableView reloadData];
                if (_selectedDiseaseIndexPath.row == 0) {
                    _paging = 1;
                    [self fetchMyCollections];
                } else {
                    _paging = 1;
                    [self fetchContents];
                }
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
//获取我收藏的场景
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
                [self.tableView reloadData];
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
//获取筛选的场景
- (void)fetchContents {
    if (!_isSearching) {
        NSString *diseaseId = nil;
        NSString *therapyId = nil;
        if (_selectedDiseaseIndexPath.row > 1) {
            DiseaseModel *model = self.diseasesArray[_selectedDiseaseIndexPath.row - 1];
            diseaseId = model.diseaseId;
        }
        if (_selectedTherapyIndexPath.row > 0) {
            DiseaseModel *model = self.diseasesArray[_selectedDiseaseIndexPath.row - 1];
            NSArray *tempArray = [model.therapiesArray copy];
            TherapyModel *therapyModel = tempArray[_selectedTherapyIndexPath.row - 1];
            therapyId = therapyModel.therapyId;
        }
        [ContentModel searchContents:diseaseId
                             therapy:therapyId
                             keyword:nil
                                page:@(_paging)
                            sortName:nil
                           sortOrder:nil
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
                                         [self.tableView reloadData];
                                         if (tempArray.count < 10) {
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
    } else {
        [ContentModel searchContents:nil
                             therapy:nil
                             keyword:self.searchTextField.text
                                page:@(1)
                            sortName:nil
                           sortOrder:nil
                             handler:^(id object, NSString *msg) {
                                 if (object) {
                                     XLDismissHUD(self.view, NO, YES, nil);
                                     NSArray *tempArray = [(NSArray *)object copy];
                                     self.searchResultArray = [tempArray mutableCopy];
                                     GJCFAsyncMainQueue(^{
                                         [self.searchTableView reloadData];
                                     });
                                 } else {
                                     XLDismissHUD(self.view, YES, NO, msg);
                                 }
                                 
                             }];
    }
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.searchTableView.hidden = NO;
    _isSearching = YES;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (XLIsNullObject(textField.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入关键字");
    } else {
        [textField resignFirstResponder];
        XLShowHUDWithMessage(@"正在搜索...", self.view);
        [self fetchContents];
    }
    return YES;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    if (tableView == self.diseaseTableView) {
        number = self.diseasesArray.count + 1;
    } else if (tableView == self.therapyTableView) {
        if (_selectedDiseaseIndexPath.row > 0) {
            DiseaseModel *model = self.diseasesArray[_selectedDiseaseIndexPath.row - 1];
            NSArray *tempArray = [model.therapiesArray copy];
            number = tempArray.count + 1;
        }
    } else if (tableView == self.tableView) {
        number = self.contentsArray.count;
    } else {
        number = self.searchResultArray.count;
    }
    return number;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (tableView == self.diseaseTableView) {
        NSString *tempString = @"";
        if (indexPath.row == 0) {
            tempString = @"收藏";
        }  else {
            DiseaseModel *model = self.diseasesArray[indexPath.row - 1];
            tempString = model.diseaseName;
        }
        CGSize titleSize = [tempString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(14)}];
        height = titleSize.width + 25.f;
    } else if (tableView == self.therapyTableView) {
        NSString *tempString = @"";
        if (indexPath.row == 0) {
            tempString = @"所有疗法";
        } else {
            if (_selectedDiseaseIndexPath.row > 0) {
                DiseaseModel *model = self.diseasesArray[_selectedDiseaseIndexPath.row - 1];
                NSArray *tempTherapyArray = model.therapiesArray;
                TherapyModel *therapyModel = tempTherapyArray[indexPath.row - 1];
                tempString = therapyModel.therapyName;
            }
        }
        CGSize titleSize = [tempString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(13)}];
        height = titleSize.width + 30.f;
    } else {
        height = 100.f;
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.diseaseTableView) {
        XJTopDiseasesCell *cell = [[XJTopDiseasesCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopDiseasesCell"];
        if (indexPath == _selectedDiseaseIndexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        cell.transform = CGAffineTransformMakeRotation(- M_PI * 1.5);
        NSString *titleString = @"";
        if (indexPath.row == 0) {
            titleString = @"收藏";
        } else {
            DiseaseModel *model = self.diseasesArray[indexPath.row - 1];
            titleString = model.diseaseName;
        }
        cell.contentLabel.text = titleString;
        CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(14)}];
        cell.contentLabel.frame = CGRectMake(0, 0, titleSize.width + 25.f, 44.5);
        return cell;
    } else if (tableView == self.therapyTableView) {
        XJTopTherapyCell *cell = [[XJTopTherapyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TopTherapyCell"];
        if (indexPath == _selectedTherapyIndexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        cell.transform = CGAffineTransformMakeRotation(- M_PI * 1.5);
        NSString *titleString = @"";
        if (indexPath.row == 0) {
            titleString = @"所有疗法";
        } else {
            if (_selectedDiseaseIndexPath.row > 0) {
                DiseaseModel *model = self.diseasesArray[_selectedDiseaseIndexPath.row - 1];
                NSArray *tempTherapyArray = model.therapiesArray;
                TherapyModel *therapyModel = tempTherapyArray[indexPath.row - 1];
                titleString = therapyModel.therapyName;
            }
        }
        CGSize titleSize = [titleString sizeWithAttributes:@{NSFontAttributeName : XJSystemFont(13)}];
        [cell.contentButton setTitle:titleString forState:UIControlStateNormal];
        cell.contentButton.frame = CGRectMake(7.5, 10, titleSize.width + 15, 25);
        return cell;
    } else {
        static NSString *identifier = @"SceneContentsCell";
        SceneContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (tableView == self.tableView) {
            ContentModel *tempModel = self.contentsArray[indexPath.row];
            [cell setupContents:tempModel viewType:self.viewType];
        } else {
            ContentModel *tempModel = self.searchResultArray[indexPath.row];
            [cell setupContents:tempModel viewType:self.viewType];
        }
        cell.block = ^(BOOL selected) {
            if (self.viewType == 1) {
                if (selected) {
                    if (tableView == self.tableView) {
                        ContentModel *tempModel = self.contentsArray[indexPath.row];
                        [ContentModel collectContent:tempModel.id handler:^(id object, NSString *msg) {
                            if (object) {
                                tempModel.isCollected = @1;
                                XLDismissHUD(self.view, YES, YES, @"收藏成功");
                            } else {
                                XLDismissHUD(self.view, YES, NO, @"收藏失败");
                            }
                        }];
                    } else {
                        ContentModel *tempModel = self.searchResultArray[indexPath.row];
                        [ContentModel collectContent:tempModel.id handler:^(id object, NSString *msg) {
                            if (object) {
                                tempModel.isCollected = @1;
                                XLDismissHUD(self.view, YES, YES, @"收藏成功");
                                if (_selectedDiseaseIndexPath.row == 0) {
                                    //如果是收藏，则刷新收藏列表
                                    [self.tableView.mj_header beginRefreshing];
                                } else {
                                    //如果是其他，则手动处理
                                    if (self.contentsArray.count > 0) {
                                        [self.contentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            ContentModel *contentModel = (ContentModel *)obj;
                                            if ([contentModel.id isEqualToString:tempModel.id]) {
                                                contentModel.isCollected = @1;
                                                [self.tableView reloadData];
                                            }
                                        }];
                                    }
                                }
                            } else {
                                XLDismissHUD(self.view, YES, NO, @"收藏失败");
                            }
                        }];
                    }
                } else {
                    if (tableView == self.tableView) {
                        ContentModel *tempModel = self.contentsArray[indexPath.row];
                        [ContentModel cancelCollectContent:tempModel.id handler:^(id object, NSString *msg) {
                            if (object) {
                                tempModel.isCollected = @0;
                                XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
                                if (_selectedDiseaseIndexPath.row == 0) {
                                    [self.contentsArray removeObjectAtIndex:indexPath.row];
                                    GJCFAsyncMainQueue(^{
                                        [self.tableView reloadData];
                                    });
                                }
                            } else {
                                XLDismissHUD(self.view, YES, NO, @"取消收藏失败");
                            }
                        }];
                    } else {
                        ContentModel *tempModel = self.searchResultArray[indexPath.row];
                        [ContentModel cancelCollectContent:tempModel.id handler:^(id object, NSString *msg) {
                            if (object) {
                                tempModel.isCollected = @0;
                                XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
                                if (_selectedDiseaseIndexPath.row == 0) {
                                    //如果是收藏，则刷新收藏列表
                                    [self.tableView.mj_header beginRefreshing];
                                } else {
                                    //如果是其他，则手动处理
                                    if (self.contentsArray.count > 0) {
                                        [self.contentsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                            ContentModel *contentModel = (ContentModel *)obj;
                                            if ([contentModel.id isEqualToString:tempModel.id]) {
                                                contentModel.isCollected = @0;
                                                [self.tableView reloadData];
                                            }
                                        }];
                                    }
                                }
                            } else {
                                XLDismissHUD(self.view, YES, NO, @"取消收藏失败");
                            }
                        }];
                    }
                }
            } else {
                ContentModel *tempModel = [[ContentModel alloc] init];
                if (tableView == self.tableView) {
                    tempModel = self.contentsArray[indexPath.row];
                } else {
                    tempModel = self.searchResultArray[indexPath.row];
                }
                if (self.chooseSceneBlock) {
                    self.chooseSceneBlock(tempModel);
                }
                GJCFAsyncMainQueue(^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        };
        return cell;
    }
}
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.diseaseTableView) {
        if (indexPath != _selectedDiseaseIndexPath) {
            self.heightConstraintOfTherapy.constant = indexPath.row == 0 ? 0 : 45.f;
            self.helpButton.hidden = indexPath.row == 0 ? YES : NO;
            _selectedDiseaseIndexPath = indexPath;
            _selectedTherapyIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];        //选中的疗法清空
            [self.therapyTableView reloadData];
            if (indexPath.row > 0) {
                DiseaseModel *model = self.diseasesArray[_selectedDiseaseIndexPath.row - 1];
                NSArray *tempArray = [model.therapiesArray copy];
                if (tempArray.count > 0) {
                    //疗法列表滑动到最前面
                    [self.therapyTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
                if (self.contentsArray.count > 0) {
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                }
            }
            [self.tableView.mj_header beginRefreshing];
            
        }
    } else if (tableView == self.therapyTableView) {
        if (indexPath != _selectedTherapyIndexPath) {
            _selectedTherapyIndexPath = indexPath;
        }
        if (self.contentsArray.count > 0) {
            [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        [self.tableView.mj_header beginRefreshing];
        
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        __block ContentModel *tempModel  = [[ContentModel alloc] init];
        if (tableView == self.tableView) {
            tempModel = self.contentsArray[indexPath.row];
        } else {
            tempModel = self.searchResultArray[indexPath.row];
        }
        ContentDetailViewController *detailViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"ContentDetail"];
        detailViewController.viewType = self.viewType;
        detailViewController.contentModel = tempModel;
        detailViewController.collectBlock = ^(ContentModel *model) {
            if (self.viewType == 1) {
                [self.contentsArray replaceObjectAtIndex:indexPath.row withObject:model];
                if (_selectedDiseaseIndexPath.row == 0) {
                    if (model.isCollected.integerValue == 0) {
                        [self.contentsArray removeObject:model];
                    } else {
                        [self.tableView.mj_header beginRefreshing];
                    }
                }
                GJCFAsyncMainQueue(^{
                    [self.tableView reloadData];
                });
            } else {
                if (self.chooseSceneBlock) {
                    self.chooseSceneBlock(tempModel);
                }
                GJCFAsyncMainQueue(^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
        };
        DetailNavigationController *navigationController = [[DetailNavigationController alloc] initWithRootViewController:detailViewController];
        navigationController.contentModel = tempModel;
        [self presentViewController:navigationController animated:YES completion:nil];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (tableView == self.tableView) {
        if (self.contentsArray.count == 0) {
            height = SCREEN_HEIGHT - 180.f;
        }
    }
    return height;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        if (self.contentsArray.count == 0) {
            UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 160.f)];
            headerView.backgroundColor = [UIColor clearColor];
            UILabel *label = [[UILabel alloc] initWithFrame:headerView.bounds];
            label.text = @"暂无场景";
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
- (UITableView *)diseaseTableView {
    if (!_diseaseTableView) {
        _diseaseTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _diseaseTableView.showsVerticalScrollIndicator = NO;
        _diseaseTableView.showsHorizontalScrollIndicator = NO;
        _diseaseTableView.backgroundColor = [UIColor clearColor];
        _diseaseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _diseaseTableView.delegate = self;
        _diseaseTableView.dataSource = self;
        _diseaseTableView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    }
    return _diseaseTableView;
    
}
- (UITableView *)therapyTableView {
    if (!_therapyTableView) {
        _therapyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _therapyTableView.showsVerticalScrollIndicator = NO;
        _therapyTableView.showsHorizontalScrollIndicator = NO;
        _therapyTableView.backgroundColor = [UIColor clearColor];
        _therapyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _therapyTableView.delegate = self;
        _therapyTableView.dataSource = self;
        _therapyTableView.transform = CGAffineTransformMakeRotation(- M_PI / 2);
    }
    return _therapyTableView;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入场景关键字";
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.textColor = MAIN_TEXT_COLOR;
        _searchTextField.font = XJSystemFont(14);
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTextField;
}
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
}
- (NSMutableArray *)searchResultArray {
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    return _searchResultArray;
}

@end
