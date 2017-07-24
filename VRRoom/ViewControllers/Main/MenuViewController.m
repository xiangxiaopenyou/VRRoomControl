//
//  MenuViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/25.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "MenuViewController.h"
#import "ChangePasswordTableViewController.h"
#import "UserModel.h"
#import <UIImage-Helpers.h>

#define ROOTCONTROLLER [UIApplication sharedApplication].keyWindow.rootViewController

@interface MenuViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *serviceButton;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.serviceButton.layer.borderWidth = 0.5;
    self.serviceButton.layer.borderColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1].CGColor;
    [self.serviceButton setBackgroundImage:[UIImage imageWithColor:BREAK_LINE_COLOR] forState:UIControlStateHighlighted];
    NSString *nameString = [[NSUserDefaults standardUserDefaults] stringForKey:REALNAME];
    NSString *hospitalString = [[NSUserDefaults standardUserDefaults] stringForKey:USERHOSPITAL];
    self.usernameLabel.text = nameString;
    self.roomNameLabel.text = hospitalString;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)serviceAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4001667866"]];
}

- (void)turnLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateDidChanged" object:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CommonCell"];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"menu%@", @(indexPath.row + 1)]];
    NSString *title;
    switch (indexPath.row) {
        case 0:
            title = @"修改密码";
            break;
        case 1:
            title = @"版本升级";
            break;
        case 2:
            title = @"注销";
            break;
        default:
            break;
    }
    cell.textLabel.text = title;
    cell.textLabel.font = XJSystemFont(16);
    cell.textLabel.textColor = MAIN_TEXT_COLOR;
    UIImageView *line = [[UIImageView alloc] init];
    line.backgroundColor = XJHexRGBColorWithAlpha(0xe5e5e5, 1);
    [cell.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.bottom.equalTo(cell.contentView);
        make.height.mas_offset(0.5);
    }];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:{
            ChangePasswordTableViewController *changePasswordController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ChangePassword"];
            UINavigationController *tempNavigation = [[UINavigationController alloc] initWithRootViewController:changePasswordController];
            [ROOTCONTROLLER presentViewController:tempNavigation animated:YES completion:nil];
        }
            break;
        case 1:{
            XLShowHUDWithMessage(@"正在检查版本...", XJKeyWindow);
            [UserModel versionInformations:^(id object, NSString *msg) {
                if (object) {
                    XLDismissHUD(XJKeyWindow, NO, YES, nil);
                } else {
                    XLDismissHUD(XJKeyWindow, YES, NO, msg);
                }
            }];
//            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"已经是最新版本了！" preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:nil];
//            [alertController addAction:cancelAction];
//            [ROOTCONTROLLER presentViewController:alertController animated:YES completion:nil];
        }
            break;
        case 2:{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要注销吗？" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self performSelector:@selector(turnLogin) withObject:nil afterDelay:0.1];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:playAction];
            [ROOTCONTROLLER presentViewController:alertController animated:YES completion:nil];
        }
            break;
            
        default:
            break;
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

@end
