//
//  SearchViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "SearchViewController.h"
#import "PrescriptionContentsTableViewController.h"
#import "PrescriptionCell.h"
#import "CommonsDefines.h"
#import "UtilDefine.h"

#import "PatientModel.h"
#import "PrescriptionModel.h"
#import "PrescriptionContentModel.h"

#import <Masonry.h>

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *informationViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *historyTableView;

@property (strong, nonatomic) UIView *titleView;
@property (strong, nonatomic) UIView *titleContentView;
@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) UIButton *backButton;
@property (strong, nonatomic) UIButton *searchButton;

@property (copy, nonatomic) NSArray *prescriptionsArray;
@property (strong, nonatomic) PatientModel *patientModel;
@property (strong, nonatomic) NSMutableArray *historyArray;
@property (strong, nonatomic) NSMutableArray *selectedHistoryArray;
@property (copy, nonatomic) NSString *selectedKeyword;
@property (assign, nonatomic) NSInteger paging;
@property (strong, nonatomic) NSMutableArray *usersContentsArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.title = @"";
    [self createNavigationTitleView];
    [self.searchTextField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textValueDidChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    self.historyTableView.tableFooterView = [UIView new];
    self.historyArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:SEARCHHISTORY] mutableCopy];
    self.selectedHistoryArray = [self.historyArray mutableCopy];
    _paging = 1;
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.searchTextField resignFirstResponder];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self.searchTextField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)deleteHistoryAction:(id)sender {
    [self.selectedHistoryArray removeAllObjects];
    [self.historyArray removeAllObjects];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCHHISTORY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.historyTableView reloadData];
}

#pragma mark - Request
- (void)fetchPrescriptions {
    [PrescriptionModel fetchPrescriptionsList:self.patientModel.userId handler:^(id object, NSString *msg) {
        if (object) {
//            XLDismissHUD(self.view, NO, YES, nil);
            self.prescriptionsArray = [object copy];
            [self fetchUsersContents];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)fetchUsersContents {
    [PrescriptionContentModel fetchUsersContents:self.patientModel.userId paging:@(_paging) handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - PrivateMethods
- (void)createNavigationTitleView {
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    _titleView.backgroundColor = [UIColor clearColor];

    [_titleView addSubview:self.titleContentView];
    [self.titleContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(_titleView.mas_leading).with.mas_offset(0);
        make.height.mas_offset(30);
        make.centerY.equalTo(_titleView);
        make.trailing.equalTo(_titleView.mas_trailing).with.mas_offset(-50);
    }];

    UIImageView *searchImage = [[UIImageView alloc] init];
    searchImage.image = [UIImage imageNamed:@"content_search"];
    [self.titleContentView addSubview:searchImage];
    [searchImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.titleContentView.mas_leading).with.mas_offset(15);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.equalTo(self.titleContentView);
    }];
    [self.titleContentView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(searchImage.mas_trailing).with.mas_offset(5);
        make.top.bottom.trailing.equalTo(self.titleContentView);
    }];
    
    [_titleView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.trailing.equalTo(_titleView);
        make.width.mas_offset(50);
    }];
    
    self.navigationItem.titleView = _titleView;
}
- (void)refreshView {
    if (self.patientModel) {
        self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@", self.patientModel.realname];
        self.phoneLabel.text = [NSString stringWithFormat:@"手机号：%@", self.patientModel.mobile];
        if (XLIsNullObject(self.patientModel.mobile)) {
            self.phoneLabel.hidden = YES;
        } else {
            self.phoneLabel.hidden = NO;
        }
        self.informationViewHeightConstraint.constant = 44;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
        }];
        [self fetchPrescriptions];
    } else {
        self.informationViewHeightConstraint.constant = 0;
        self.prescriptionsArray = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}
- (void)turnLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateDidChanged" object:nil];
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

#pragma mark - Notification
- (void)textValueDidChange:(NSNotification *)textField {
    if (self.searchTextField.text.length == 0) {
        self.selectedHistoryArray = [self.historyArray mutableCopy];
    } else {
        [self.selectedHistoryArray removeAllObjects];
        [self.historyArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *string = (NSString *)obj;
            if ([string containsString:self.self.searchTextField.text]) {
                [self.selectedHistoryArray addObject:string];
            }
        }];
    }
    [self.historyTableView reloadData];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.historyTableView.hidden = NO;
    [self textValueDidChange:nil];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (XLIsNullObject(self.searchTextField.text) && XLIsNullObject(self.selectedKeyword)) {
        XLShowThenDismissHUD(NO, @"请先输入手机号或姓名再进行搜索", self.view);
        return NO;
    }
    [self.searchTextField resignFirstResponder];
    self.historyTableView.hidden = YES;
    XLShowHUDWithMessage(@"正在查询...", self.view);
    NSString *searchString;
    if (!XLIsNullObject(self.selectedKeyword)) {
        searchString = self.selectedKeyword;
    } else {
        searchString = self.searchTextField.text;
    }
    self.selectedKeyword = nil;
    [PatientModel searchPatient:searchString handler:^(id object, NSString *msg) {
        if (object) {
            self.patientModel = (PatientModel *)object;
            [self saveSearchHistory:searchString];
            dispatch_async(dispatch_get_main_queue(), ^{
                 [self refreshView];
            });
        } else {
            self.patientModel = nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self refreshView];
            });
            if ([msg integerValue] >= 95 && [msg integerValue] < 100) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:ROOMID];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:VRROOMNAME];
                [[NSUserDefaults standardUserDefaults] synchronize];
                XLDismissHUD(self.view, YES, NO, @"登录失效，请重新登录");
                [self performSelector:@selector(turnLogin) withObject:nil afterDelay:1.0];
            } else {
                XLDismissHUD(self.view, YES, NO, msg);
            }
        }
    }];
    return YES;
}

#pragma mark - UITableViewDelegate DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.tableView) {
        return self.prescriptionsArray.count * 2;
    } else {
        if (self.selectedHistoryArray.count > 0) {
            return self.selectedHistoryArray.count + 1;
        } else {
            return 0;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        return indexPath.row % 2 == 0 ? 10.f : 100.f;
    } else {
        return 40.f;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
        if (indexPath.row % 2 == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeparatorCell"];
            cell.backgroundColor = [UIColor clearColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        static NSString *identifier = @"PrescriptionCell";
        PrescriptionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        PrescriptionModel *model = self.prescriptionsArray[indexPath.row / 2];
        cell.doctorLabel.text = [NSString stringWithFormat:@"医生：%@", model.doctorName ? model.doctorName : @""];
        cell.typeLabel.text = [model.source integerValue] == 1 ? @"类型：线上" : @"类型：线下";
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
    } else {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HistoryCell" forIndexPath:indexPath];
            cell.textLabel.font = kSystemFont(14);
            cell.textLabel.textColor = kRGBColor(100, 100, 100, 1);
            NSString *temp = self.selectedHistoryArray[indexPath.row - 1];
            cell.textLabel.text = temp;
            return cell;
        }
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView) {
        if (indexPath.row % 2 == 1) {
            PrescriptionModel *model = self.prescriptionsArray[indexPath.row / 2];
            PrescriptionContentsTableViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]  instantiateViewControllerWithIdentifier:@"PrescriptionContents"];
            contentsViewController.prescriptionId = model.id;
            [self.navigationController pushViewController:contentsViewController animated:YES];
        }
    } else {
        if (indexPath.row > 0) {
            self.selectedKeyword = self.selectedHistoryArray[indexPath.row - 1];
            [self textFieldShouldReturn:self.searchTextField];
        }
    }
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
- (UIView *)titleContentView {
    if (!_titleContentView) {
        _titleContentView = [[UIView alloc] init];
        _titleContentView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
        _titleContentView.layer.masksToBounds = YES;
        _titleContentView.layer.cornerRadius = 4.0;
    }
    return _titleContentView;
}
- (UITextField *)searchTextField {
    if (!_searchTextField) {
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = @"请输入手机号或姓名";
        [_searchTextField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
        _searchTextField.textColor = [UIColor whiteColor];
        _searchTextField.font = kSystemFont(14);
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.delegate = self;

    }
    return _searchTextField;
}
- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_searchButton setTitle:@"查询" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _searchButton.titleLabel.font = kSystemFont(15);
        [_searchButton addTarget:self action:@selector(textFieldShouldReturn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
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
- (NSMutableArray *)usersContentsArray {
    if (!_usersContentsArray) {
        _usersContentsArray = [[NSMutableArray alloc] init];
    }
    return _usersContentsArray;
}

@end
