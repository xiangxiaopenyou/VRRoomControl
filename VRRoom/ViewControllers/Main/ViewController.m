//
//  ViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "ViewController.h"
#import "ChangePasswordTableViewController.h"
#import "XJAddPatientViewController.h"
#import "XJMyPatientsViewController.h"
//#import "SceneContentsViewController.h"
#import "XJScenesListViewController.h"
#import "XJCommonWebViewController.h"
#import "AuthenticationInformationViewController.h"
#import "XJBaseInformationsTableViewController.h"
#import "XJPlansListViewController.h"
#import "XJNewsCell.h"
#import "XLAlertControllerObject.h"

#import "PatientModel.h"
#import "PrescriptionModel.h"
#import "UserModel.h"
#import "InformationModel.h"
#import "XJNewsModel.h"

#import <UIImageView+WebCache.h>

#define XLAppVersion [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (copy, nonatomic) NSArray *prescriptionsArray;
@property (copy, nonatomic) NSArray *newsArray;
@property (strong, nonatomic) PatientModel *patientModel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.headerView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH * 36 / 75.0 + 92);
    self.tableView.tableHeaderView = self.headerView;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.userInteractionEnabled = YES;
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeMemu)];
    recognizer.delegate = self;
    [self.tableView addGestureRecognizer:recognizer];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(leftMenuActions:) name:@"XJLeftMenuItemDidClick" object:nil];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self versionInformationsRequest];
    NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:USERSTATUS];
    if (status != 4) {
        [self authenticationStatusRequest];
    }
    if (self.newsArray.count == 0) {
        //询问咨询请求
        [self newsListRequest];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"XJLeftMenuItemDidClick" object:nil];
}

#pragma mark - Request
- (void)versionInformationsRequest {
    [UserModel versionInformations:^(id object, NSString *msg) {
        if (object) {
            NSString *localVersion = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
            NSString *currentVersion = object[@"versionName"];
            if (![localVersion isEqualToString:currentVersion]) {
                [XLAlertControllerObject showWithTitle:@"提示" message:@"发现新版本" cancelTitle:@"以后再说" ensureTitle:@"版本升级" ensureBlock:^{
                    NSString *urlString = object[@"downloadUrl"];
                    NSURL *url = [NSURL URLWithString:urlString];
                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }];
            }
        } else {
            if ([msg integerValue] >= 95 && [msg integerValue] < 100) {
                XLUserLogout;
                XLDismissHUD(self.view, YES, NO, @"登录失效，请重新登录");
                [self performSelector:@selector(turnLogin) withObject:nil afterDelay:1.0];
            } else {
                XLDismissHUD(self.view, YES, NO, msg);
            }

        }
    }];
}
- (void)authenticationStatusRequest {
    [InformationModel authenticationStatus:^(id object, NSString *msg) {
        if (object) {
            NSInteger status = [object[@"status"] integerValue];
            if (status == XJAuthenticationStatusNot) {
                [XLAlertControllerObject showWithTitle:@"医生认证" message:@"您需要进行医生资格认证" cancelTitle:@"以后再说" ensureTitle:@"现在认证" ensureBlock:^{
                    AuthenticationInformationViewController *authenticationController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
                    [self.navigationController pushViewController:authenticationController animated:YES];
                }];
            } else if (status == XJAuthenticationStatusFail) {
                [XLAlertControllerObject showWithTitle:@"提示" message:@"您的认证申请被拒绝" cancelTitle:@"我知道了" ensureTitle:@"查看原因" ensureBlock:^{
                    AuthenticationInformationViewController *authenticationController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
                    [self.navigationController pushViewController:authenticationController animated:YES];
                }];
            } else if (status == XJAuthenticationStatusSuccess) {
                [self fetchInformations];
            }
            [[NSUserDefaults standardUserDefaults] setObject:@(status) forKey:USERSTATUS];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"XJUserStatusDidChange" object:nil];
        }
    }];
}
//获取认证消息
- (void)fetchInformations {
    [InformationModel fetchInformations:^(id object, NSString *msg) {
        if (object) {
            InformationModel *tempModel = (InformationModel *)object;
            [[NSUserDefaults standardUserDefaults] setObject:tempModel.headPictureUrl forKey:USER_PORTRAIT];
            [[NSUserDefaults standardUserDefaults] setObject:tempModel.realname forKey:REALNAME];
            [[NSUserDefaults standardUserDefaults] setObject:tempModel.hospital forKey:USERHOSPITAL];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"XJUserStatusDidChange" object:nil];
        }
    }];
}
- (void)newsListRequest {
    XLShowHUDWithMessage(nil, self.view);
    [XJNewsModel newsList:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.newsArray = [object copy];
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction
- (IBAction)myPatientsAction:(id)sender {
    NSInteger status = [[NSUserDefaults standardUserDefaults] integerForKey:USERSTATUS];
    if (status == XJAuthenticationStatusNot) {
        [XLAlertControllerObject showWithTitle:@"医生认证" message:@"您需要进行医生资格认证" cancelTitle:@"以后再说" ensureTitle:@"现在认证" ensureBlock:^{
            AuthenticationInformationViewController *authenticationController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
            [self.navigationController pushViewController:authenticationController animated:YES];
        }];
    } else if (status == XJAuthenticationStatusFail) {
        [XLAlertControllerObject showWithTitle:@"提示" message:@"您的认证申请被拒绝" cancelTitle:@"我知道了" ensureTitle:@"查看原因" ensureBlock:^{
            AuthenticationInformationViewController *authenticationController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"AuthenticationInformation"];
            [self.navigationController pushViewController:authenticationController animated:YES];
        }];
    } else if (status == XJAuthenticationStatusWait) {
        XLDismissHUD(self.view, YES, NO, @"请等待认证通过");
    } else {
        XJMyPatientsViewController *myPatientsController = [[UIStoryboard storyboardWithName:@"Patients" bundle:nil] instantiateViewControllerWithIdentifier:@"MyPatientsController"];
        [self.navigationController pushViewController:myPatientsController animated:YES];
    }
}
- (IBAction)vrContentsAction:(id)sender {
//    SceneContentsViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"SceneContents"];
//    contentsViewController.viewType = 1;
//    [self.navigationController pushViewController:contentsViewController animated:YES];
    XJScenesListViewController *contentsViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"ScenesList"];
    contentsViewController.viewType = 1;
    [self.navigationController pushViewController:contentsViewController animated:YES];
}
- (IBAction)directionAction:(id)sender {
//    XJCommonWebViewController *webController = [[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateViewControllerWithIdentifier:@"CommonWeb"];
//    webController.urlString = HELPBASEURL;
//    webController.title = @"康复综述";
//    [self.navigationController pushViewController:webController animated:YES];
    XJPlansListViewController *plansViewController = [[UIStoryboard storyboardWithName:@"Plan" bundle:nil] instantiateViewControllerWithIdentifier:@"PlansList"];
    plansViewController.isView = YES;
    [self.navigationController pushViewController:plansViewController animated:YES];
}
- (IBAction)aboutAction:(id)sender {
    XJCommonWebViewController *webController = [[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateViewControllerWithIdentifier:@"CommonWeb"];
    webController.urlString = ABOUTBASEURL;
    webController.title = @"关于心景";
    [self.navigationController pushViewController:webController animated:YES];
}
- (void)moreNewsAction {
    XJCommonWebViewController *webController = [[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateViewControllerWithIdentifier:@"CommonWeb"];
    webController.urlString = MORE_NRES_URL;
    webController.title = @"新闻资讯";
    [self.navigationController pushViewController:webController animated:YES];
}
- (void)closeMemu {
    if ([SlideNavigationController sharedInstance].isMenuOpen) {
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    }
}
- (void)leftMenuActions:(NSNotification *)notification {
    switch ([notification.object integerValue]) {
        case 0: {
            XJBaseInformationsTableViewController *informationsController = [[UIStoryboard storyboardWithName:@"Authentication" bundle:nil] instantiateViewControllerWithIdentifier:@"BaseInformations"];
            [self.navigationController pushViewController:informationsController animated:YES];
        }
            break;
        case 3: {
            XJCommonWebViewController *webController = [[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateViewControllerWithIdentifier:@"CommonWeb"];
            webController.urlString = HELPBASEURL;
            webController.title = @"康复综述";
            [self.navigationController pushViewController:webController animated:YES];
        }
            break;
        case 4: {
            XJCommonWebViewController *webController = [[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateViewControllerWithIdentifier:@"CommonWeb"];
            webController.urlString = ABOUTBASEURL;
            webController.title = @"关于心景";
            [self.navigationController pushViewController:webController animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - PrivateMethods
- (void)turnLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateDidChanged" object:nil];
}

#pragma mark - SlideNavigationControllerDelegate
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu {
    return YES;
}

#pragma mark - Table view datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.newsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJNewsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NewsCell" forIndexPath:indexPath];
    XJNewsModel *model = self.newsArray[indexPath.row];
    [cell.coverImageView sd_setImageWithURL:[NSURL URLWithString:model.coverurl] placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.newsThemeLabel.text = [NSString stringWithFormat:@"%@", model.name];
    cell.timeLabel.text = model.releasetime;
    cell.doctorInfoLabel.hidden = YES;
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30.f)];
    headerView.backgroundColor = MAIN_BACKGROUND_COLOR;
    UILabel *headerLabel = [[UILabel alloc] init];
    headerLabel.text = @"新闻资讯";
    headerLabel.textColor = [UIColor blackColor];
    headerLabel.font = XJSystemFont(15);
    [headerView addSubview:headerLabel];
    [headerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(headerView.mas_leading).with.mas_offset(15);
        make.centerY.equalTo(headerView);
    }];
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"more_news"];
    [headerView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView.mas_trailing).with.mas_offset(- 10);
        make.size.mas_offset(CGSizeMake(18, 18));
        make.centerY.equalTo(headerView);
    }];
    
    UILabel *moreLabel = [[UILabel alloc] init];
    moreLabel.font = XJSystemFont(15);
    moreLabel.textColor = [UIColor blackColor];
    moreLabel.text = @"更多";
    [headerView addSubview:moreLabel];
    [moreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(arrowImageView.mas_leading);
        make.centerY.equalTo(headerView);
    }];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton addTarget:self action:@selector(moreNewsAction) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:moreButton];
    [moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(headerView.mas_trailing).with.mas_offset(- 15);
        make.top.bottom.equalTo(headerView);
        make.width.mas_offset(SCREEN_WIDTH / 2.0);
    }];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([SlideNavigationController sharedInstance].isMenuOpen) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:nil];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        XJCommonWebViewController *webController = [[UIStoryboard storyboardWithName:@"More" bundle:nil] instantiateViewControllerWithIdentifier:@"CommonWeb"];
        XJNewsModel *model = self.newsArray[indexPath.row];
        webController.urlString = model.linkurl;
        webController.title = model.name;
        [self.navigationController pushViewController:webController animated:YES];
    }
    
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark - Getters


@end
