//
//  XJMyPatientsViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/15.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJMyPatientsViewController.h"
#import "XJAddPatientViewController.h"
#import "XJPatientDetailViewController.h"
#import "XJPatientCell.h"

#import "PatientModel.h"
#import "UserModel.h"

#import <ChineseString.h>

@interface XJMyPatientsViewController ()<UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) UITableView *searchTableView;

@property (copy, nonatomic) NSArray *myPatientsArray;
@property (strong, nonatomic) NSMutableArray *indexArray;
@property (strong, nonatomic) NSMutableArray *patientsDataArray;
@property (strong, nonatomic) NSMutableArray *historyArray;
@property (strong, nonatomic) NSMutableArray *selectedHistoryArray;

@end

@implementation XJMyPatientsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.tableFooterView = [UIView new];
    [self.searchController.view addSubview:self.searchTableView];
    //self.definesPresentationContext = YES;
    self.historyArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:SEARCHHISTORY] mutableCopy];
    self.selectedHistoryArray = [self.historyArray mutableCopy];
    XLShowHUDWithMessage(nil, self.view);
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchMyPatients];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Requests
- (void)fetchMyPatients {
    [UserModel myPatients:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.myPatientsArray = [object copy];
            self.indexArray = [self indexArray:self.myPatientsArray];
            self.patientsDataArray = [self sortResultArray:self.myPatientsArray];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
                if (self.myPatientsArray.count == 0) {
                    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 100)];
                    tipLabel.textColor = [UIColor lightGrayColor];
                    tipLabel.font = XJBoldSystemFont(17);
                    tipLabel.text = @"暂无患者";
                    tipLabel.textAlignment = NSTextAlignmentCenter;
                    self.tableView.tableFooterView = tipLabel;
                } else {
                    self.tableView.tableFooterView = [UIView new];
                }
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)searchPatient:(NSString *)keyword {
    XLShowHUDWithMessage(@"正在搜索", XJKeyWindow);
    [PatientModel searchPatient:keyword handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(XJKeyWindow, NO, YES, nil);
            PatientModel *tempModel = object;
            [self pushToPatientDetail:tempModel.userId];
            [self saveSearchHistory:keyword];
        } else {
            XLDismissHUD(XJKeyWindow, YES, NO, msg);
        }
    }];
}

#pragma mark - Private methods
- (void)pushToPatientDetail:(NSString *)patientId {
    XJPatientDetailViewController *detailController = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientDetail"];
    detailController.patientId = patientId;
    [self.navigationController pushViewController:detailController animated:YES];
    [self.searchController dismissViewControllerAnimated:NO completion:^{
        self.searchBar.hidden = NO;
        self.view.hidden = NO;
        self.searchTableView.hidden = YES;
    }];
}

#pragma mark - Action
- (void)deleteHistoryAction {
    [self.selectedHistoryArray removeAllObjects];
    [self.historyArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCHHISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.searchTableView reloadData];
}
- (IBAction)addPatientAction:(id)sender {
    XJAddPatientViewController *addController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"AddPatient"];
    [self.navigationController pushViewController:addController animated:YES];
}

#pragma mark - Search bar delegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if (searchBar.tag == 1001) {
        [self presentViewController:self.searchController animated:YES completion:^{
            self.searchBar.hidden = YES;
            self.view.hidden = YES;
            self.searchTableView.hidden = NO;
        }];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchBar == self.searchController.searchBar) {
        if (searchText.length == 0) {
            self.selectedHistoryArray = [self.historyArray mutableCopy];
        } else {
            [self.selectedHistoryArray removeAllObjects];
            [self.historyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *string = (NSString *)obj;
                if ([string containsString:searchText]) {
                    [self.selectedHistoryArray addObject:string];
                }
            }];
        }
        [self.searchTableView reloadData];
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (searchBar == self.searchController.searchBar) {
        if (searchBar.text.length > 0) {
            [self searchPatient:searchBar.text];
        }
    }
}

#pragma mark - Search controller delegate
- (void)willDismissSearchController:(UISearchController *)searchController {
    self.searchBar.hidden = NO;
    self.view.hidden = NO;
    self.searchTableView.hidden = YES;
}

#pragma mark - Search results updating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return tableView == self.tableView ? self.indexArray.count : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        NSArray *tempArray = [self.patientsDataArray[section][@"models"] copy];
        return tempArray.count;
    } else {
        if (self.selectedHistoryArray.count > 0) {
            return self.selectedHistoryArray.count + 1;
        } else {
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return tableView == self.tableView ? 50.f : 40.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        static NSString *identifier = @"PatientCell";
        XJPatientCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSArray *tempArray = [self.patientsDataArray[indexPath.section][@"models"] copy];
        PatientModel *tempModel = tempArray[indexPath.row];
        cell.avatarImageView.image = [UIImage imageNamed:@"personal_avatar"];
        cell.nameLabel.text = tempModel.remark ? tempModel.remark : tempModel.name;
        return cell;
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HistoryHeader"];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 40)];
            label.font = XJSystemFont(15);
            label.textColor = MAIN_TEXT_COLOR;
            label.text = @"历史搜索";
            [cell.contentView addSubview:label];
            UIButton *deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteButton setImage:[UIImage imageNamed:@"delete_history"] forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteHistoryAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:deleteButton];
            [deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(- 10);
                make.centerY.equalTo(cell.contentView);
                make.size.mas_offset(CGSizeMake(50, 40));
            }];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"History"];
            cell.textLabel.font = XJSystemFont(14);
            cell.textLabel.textColor = XJRGBColor(100, 100, 100, 1);
            NSString *temp = self.selectedHistoryArray[indexPath.row - 1];
            cell.textLabel.text = temp;
            return cell;
        }
    }
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    return tableView == self.tableView ? self.indexArray : nil;
}

#pragma mark Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return tableView == self.tableView ? 20.f : 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
        headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
        UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
        headerLabel.textColor = [UIColor lightGrayColor];
        headerLabel.text = self.indexArray[section];
        headerLabel.font = XJSystemFont(14);
        [headerView addSubview:headerLabel];
        return headerView;
    }
    return [UIView new];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        NSArray *tempArray = [self.patientsDataArray[indexPath.section][@"models"] copy];
        PatientModel *tempModel = tempArray[indexPath.row];
        XJPatientDetailViewController *informationsController = [self.storyboard instantiateViewControllerWithIdentifier:@"PatientDetail"];
        informationsController.patientId = tempModel.id;
        [self.navigationController pushViewController:informationsController animated:YES];
    } else {
        if (indexPath.row > 0) {
            NSString *temp = self.selectedHistoryArray[indexPath.row - 1];
            [self searchPatient:temp];
        }
    }
}

#pragma mark - Private methods
//排序
- (NSMutableArray *)indexArray:(NSArray *)dataArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(PatientModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![resultArray containsObject:obj.realnameFirstSpell]) {
            [resultArray addObject:obj.realnameFirstSpell];
        }
    }];
    [resultArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSCaseInsensitiveSearch];
    }];
    return resultArray;
}
- (NSMutableArray *)sortResultArray:(NSArray *)dataArray {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    [dataArray enumerateObjectsUsingBlock:^(PatientModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BOOL isContains = NO;
        for (NSMutableDictionary *dictionary in resultArray) {
            if ([obj.realnameFirstSpell isEqualToString:dictionary[@"spell"]]) {
                isContains = YES;
                NSMutableArray *tempArray = [dictionary[@"models"] mutableCopy];
                [tempArray addObject:obj];
                [dictionary setObject:tempArray forKey:@"models"];
            }
        }
        if (!isContains) {
            NSMutableDictionary *temp = [@{@"spell" : obj.realnameFirstSpell,
                                           @"models" : [NSMutableArray arrayWithObjects:obj, nil]} mutableCopy];
            [resultArray addObject:temp];
        }
    }];
    [resultArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1[@"spell"] compare:obj2[@"spell"] options:NSLiteralSearch];
    }];
    [resultArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray *models = obj[@"models"];
        [models sortedArrayUsingComparator:^NSComparisonResult(PatientModel *obj1, PatientModel *obj2) {
            if (obj1.remark) {
                if (obj2.remark) {
                    return [obj1.remark compare:obj2.remark];
                } else {
                    return [obj1.remark compare:obj2.name];
                }
            } else {
                if (obj2.remark) {
                    return [obj1.name compare:obj2.remark];
                } else {
                    return [obj1.name compare:obj2.name];
                }
            }
        }];
    }];
    return resultArray;
}
//保存搜索记录
- (void)saveSearchHistory:(NSString *)searchString {
    if ([self.historyArray containsObject:searchString]) {
        [self.historyArray removeObject:searchString];
        [self.historyArray insertObject:searchString atIndex:0];
    } else {
        [self.historyArray insertObject:searchString atIndex:0];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.historyArray forKey:SEARCHHISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Getters
- (UISearchController *)searchController {
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.delegate = self;
        _searchController.searchResultsUpdater = self;
        _searchController.searchBar.placeholder = @"输入病历号或手机号搜索";
        _searchController.searchBar.delegate = self;
        _searchController.view.backgroundColor = MAIN_BACKGROUND_COLOR;
        _searchController.hidesNavigationBarDuringPresentation = NO;
    }
    return _searchController;
}
- (UITableView *)searchTableView {
    if (!_searchTableView) {
        _searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT - 64) style:UITableViewStylePlain];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.separatorColor = BREAK_LINE_COLOR;
        _searchTableView.backgroundColor = [UIColor clearColor];
        _searchTableView.tableFooterView = [UIView new];
    }
    return _searchTableView;
}
- (NSMutableArray *)indexArray {
    if (!_indexArray) {
        _indexArray = [[NSMutableArray alloc] init];
    }
    return _indexArray;
}
- (NSMutableArray *)patientsDataArray {
    if (!_patientsDataArray) {
        _patientsDataArray = [[NSMutableArray alloc] init];
    }
    return _patientsDataArray;
}
- (NSMutableArray *)historyArray {
    if (!_historyArray) {
        _historyArray = [[NSMutableArray alloc] init];
    }
    return _historyArray;
}
- (NSMutableArray *)selectedHistoryArray {
    if (!_selectedHistoryArray) {
        _selectedHistoryArray = [[NSMutableArray alloc] init];
    }
    return _selectedHistoryArray;
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
