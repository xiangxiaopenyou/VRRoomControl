//
//  SceneContentsViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/3/14.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SceneContentsViewController.h"
#import "SceneContentsListViewController.h"
#import "AdviceWebViewController.h"
#import "XJMyPlansViewController.h"

#import "DepartmentSelectCell.h"
#import "TherapyItemCell.h"
#import "TherapyCollectionCell.h"
#import "XJSearchTitleView.h"

#import "DiseaseModel.h"
#import "TherapyModel.h"

#import <GJCFUitils.h>

#define THERAPY_ITEM_WIDTH SCREEN_WIDTH / 3.0 - 7.5

@interface SceneContentsViewController ()<UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *departmentTableView;
@property (weak, nonatomic) IBOutlet UITableView *diseaseTableView;

@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) NSIndexPath *seletedDepartmentIndexPath;  //当前选择的病症

@property (copy, nonatomic) NSArray *diseasesArray;
@property (copy, nonatomic) NSArray *selectedTherapiesArray;

@end

@implementation SceneContentsViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    [self createNavigationTitleView];
    
    self.departmentTableView.tableFooterView = [UIView new];
    //默认当前选择全部病种
    _seletedDepartmentIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self fetchDiseases];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)adviceAction {
    AdviceWebViewController *adviceController = [self.storyboard instantiateViewControllerWithIdentifier:@"AdviceWeb"];
    if (self.seletedDepartmentIndexPath.row == 1) {
        adviceController.adviceType = XJAdviceTypeAll;
    } else {
        DiseaseModel *tempModel = self.diseasesArray[self.seletedDepartmentIndexPath.row - 1];
        adviceController.adviceType = XJAdviceTypeDisease;
        adviceController.resultId = tempModel.diseaseId;
    }
    [self.navigationController pushViewController:adviceController animated:YES];
    
}

#pragma mark - Request
- (void)fetchDiseases {
    XLShowHUDWithMessage(nil, self.view);
    [DiseaseModel fetchDiseasesAndTherapies:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.diseasesArray = [object copy];
//            DiseaseModel *tempModel = self.diseasesArray[0];
//            self.selectedTherapiesArray = [tempModel.therapiesArray copy];
            GJCFAsyncMainQueue(^{
                [self.departmentTableView reloadData];
                [self.diseaseTableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
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

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (XLIsNullObject(textField.text)) {
        XLDismissHUD(self.view, YES, NO, @"请先输入搜索内容");
    } else {
        [textField resignFirstResponder];
        SceneContentsListViewController *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneContentsList"];
        listViewController.viewType = self.viewType;
        listViewController.keyword = textField.text;
        if (self.viewType == 2) {
            listViewController.selectedContents = [self.selectedArray mutableCopy];
        }
        listViewController.selectedBlock = ^(NSArray *array) {
            self.selectedArray = [array copy];
            if (self.pickBlock) {
                self.pickBlock(self.selectedArray);
            }
        };
        [self.navigationController pushViewController:listViewController animated:YES];
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableView == self.departmentTableView ? self.diseasesArray.count + 1 : 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 45.f;
    if (tableView == self.departmentTableView) {
        if (indexPath.row > 0) {
//            DiseaseModel *model = self.diseasesArray[indexPath.row - 1];
//            CGSize size = XLSizeOfText(model.diseaseName, SCREEN_WIDTH / 3.0 - 10, XJSystemFont(15));
//            height =  size.height + 24.f;
            height = 55.f;
        }
    } else {
        height = (SCREEN_WIDTH / 3.0 - 2.5) * (self.selectedTherapiesArray.count / 2 + 1);
    }
    return height;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.departmentTableView) {
        static NSString *identifier = @"DepartmentCell";
        DepartmentSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        if (indexPath.row == 0) {
            cell.departmentNameLabel.text = @"我的收藏";
        } else {
            DiseaseModel *model = self.diseasesArray[indexPath.row - 1];
            cell.departmentNameLabel.text = [NSString stringWithFormat:@"%@", model.diseaseName];
        }
        if (indexPath == _seletedDepartmentIndexPath) {
            [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        }
        return cell;
    } else {
        static NSString *identifier = @"DiseaseCell";
        TherapyItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        [cell.collectionView reloadData];
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.departmentTableView) {
        return 0;
    } else {
        if (self.seletedDepartmentIndexPath.row == 0) {
            return 0;
        } else {
            return 50.f;
        }
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2 * SCREEN_WIDTH / 3.0, 50)];
    header.backgroundColor = MAIN_BACKGROUND_COLOR;
    UIButton *adviceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [adviceButton setTitle:@"建议指导" forState:UIControlStateNormal];
    [adviceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    adviceButton.titleLabel.font = XJSystemFont(15);
    [adviceButton setBackgroundColor:NAVIGATIONBAR_COLOR];
    [adviceButton addTarget:self action:@selector(adviceAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:adviceButton];
    [adviceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.top.equalTo(header).with.mas_offset(5);
        make.trailing.bottom.equalTo(header).with.mas_offset(-5);
    }];
    return header;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _seletedDepartmentIndexPath = indexPath;
    if (indexPath.row == 0) {
        self.selectedTherapiesArray = nil;
    } else {
        DiseaseModel *model = self.diseasesArray[indexPath.row - 1];
        self.selectedTherapiesArray = [model.therapiesArray copy];
    }
    [self.diseaseTableView reloadData];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.seletedDepartmentIndexPath.row == 0 ? 2 : self.selectedTherapiesArray.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TherapyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TherapyCollection" forIndexPath:indexPath];
    if (self.seletedDepartmentIndexPath.row == 0) {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"常用场景";
        } else {
            cell.nameLabel.text = @"我的方案";
        }
    } else {
        if (indexPath.row == 0) {
            cell.nameLabel.text = @"所有疗法";
        } else {
            TherapyModel *model = self.selectedTherapiesArray[indexPath.row - 1];
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.therapyName];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.seletedDepartmentIndexPath.row == 0 && indexPath.row == 1) {
        XJMyPlansViewController *planController = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPlans"];
        planController.viewType = self.viewType;
        planController.selectedContentsArray = [self.selectedArray mutableCopy];
        planController.block = ^(NSArray *array) {
            self.selectedArray = [array copy];
            if (self.pickBlock) {
                self.pickBlock(self.selectedArray);
            }
        };
        [self.navigationController pushViewController:planController animated:YES];
    } else {
        SceneContentsListViewController *listViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SceneContentsList"];
        if (self.seletedDepartmentIndexPath.row > 1) {
            DiseaseModel *tempModel = self.diseasesArray[self.seletedDepartmentIndexPath.row - 1];
            listViewController.diseaseModel = tempModel;
        }
        if (self.seletedDepartmentIndexPath.row > 0 && indexPath.row > 0) {
            TherapyModel *model = self.selectedTherapiesArray[indexPath.row - 1];
            listViewController.therapyModel = model;
        }
        listViewController.viewType = self.viewType;
        if (self.viewType == 2) {
            listViewController.selectedContents = [self.selectedArray mutableCopy];
        }
        if (self.seletedDepartmentIndexPath.row == 0 && indexPath.row == 0) {
            listViewController.isCollectionView = YES;
        }
        listViewController.selectedBlock = ^(NSArray *array) {
            self.selectedArray = [array copy];
            if (self.pickBlock) {
                self.pickBlock(self.selectedArray);
            }
        };
        [self.navigationController pushViewController:listViewController animated:YES];
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(THERAPY_ITEM_WIDTH, THERAPY_ITEM_WIDTH);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 5, 5, 5);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
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
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入你要搜索的内容";
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.textColor = MAIN_TEXT_COLOR;
        _searchTextField.font = XJSystemFont(14);
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchTextField;
}

@end
