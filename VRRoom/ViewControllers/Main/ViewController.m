//
//  ViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "ViewController.h"
#import "SearchViewController.h"
#import "ChangePasswordTableViewController.h"
#import "XJAddPatientViewController.h"
#import "XJMainItemsCell.h"

#import "PatientModel.h"
#import "PrescriptionModel.h"

#define XLAppVersion [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (strong, nonatomic) UIView *titleView;
//@property (strong, nonatomic) UIButton *searchButton;
//@property (strong, nonatomic) UIButton *menuButton;

@property (copy, nonatomic) NSArray *prescriptionsArray;
@property (strong, nonatomic) PatientModel *patientModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.tableView.userInteractionEnabled = YES;
    [self.tableView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMemu)]];
    NSString *roomName = [[NSUserDefaults standardUserDefaults] stringForKey:VRROOMNAME];
    self.roomNameLabel.text = XLIsNullObject(roomName) ? nil : roomName;
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnChangePassword) name:@"changePasswordDidClick" object:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)addAction:(id)sender {
    XJAddPatientViewController *addController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"AddPatient"];
    [self.navigationController pushViewController:addController animated:YES];
}
- (IBAction)searchPatientAction:(id)sender {
    SearchViewController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
    [self.navigationController pushViewController:searchController animated:YES];
}
- (IBAction)vrContentsAction:(id)sender {
}
- (IBAction)directionAction:(id)sender {
}
//- (void)searchAction {
//    SearchViewController *searchController = [self.storyboard instantiateViewControllerWithIdentifier:@"Search"];
//    [self.navigationController pushViewController:searchController animated:YES];
//}
- (void)closeMemu {
    if ([SlideNavigationController sharedInstance].isMenuOpen) {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    }
}

#pragma mark - PrivateMethods
//- (void)createNavigationTitleView {
//    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
//    _titleView.backgroundColor = [UIColor clearColor];
//    
//    [_titleView addSubview:self.searchButton];
//    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.leading.equalTo(_titleView);
//        make.trailing.equalTo(_titleView.mas_trailing).with.mas_offset(- 10);
//        make.centerY.equalTo(_titleView);
//        make.height.mas_offset(30);
//    }];
//    
//    self.navigationItem.titleView = _titleView;
//}

#pragma mark - SlideNavigationControllerDelegate
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SCREEN_WIDTH - 65.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJMainItemsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell" forIndexPath:indexPath];
    return cell;
}

#pragma mark - Getters
//- (UIButton *)searchButton {
//    if (!_searchButton) {
//        _searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_searchButton setTitle:@"请输入手机号或姓名" forState:UIControlStateNormal];
//        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_searchButton setImage:[UIImage imageNamed:@"content_search"] forState:UIControlStateNormal];
//        [_searchButton setImage:[UIImage imageNamed:@"content_search"] forState:UIControlStateHighlighted];
//        [_searchButton setImageEdgeInsets:UIEdgeInsetsMake(0, - SCREEN_WIDTH / 2.0 + 60, 0, 0)];
//        [_searchButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -SCREEN_WIDTH / 2.0 + 70, 0, 0)];
//        _searchButton.titleLabel.font = kSystemFont(14);
//        _searchButton.layer.masksToBounds = YES;
//        _searchButton.layer.cornerRadius = 4.0;
//        _searchButton.backgroundColor = [UIColor colorWithWhite:1 alpha:0.4];
//        [_searchButton addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
//    }
//    return _searchButton;
//}


@end
