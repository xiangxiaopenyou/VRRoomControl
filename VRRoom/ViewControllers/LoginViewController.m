//
//  LoginViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginContentCell.h"
#import "CommonsDefines.h"
#import "UtilDefine.h"
#import "UserModel.h"

#import <Masonry.h>

@interface LoginViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneTextField;
@property (strong, nonatomic) UITextField *passwordTextField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([[NSUserDefaults standardUserDefaults] objectForKey:USERNAME]) {
        self.phoneTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:USERNAME];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)helpAction:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"帮助" message:@"账户问题请联系客服处理！\n客服电话 : 4008-0000-0000" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://400800000000"]];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:playAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContenCell";
    LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageView.image = indexPath.row == 0 ? [UIImage imageNamed:@"phone_number"] : [UIImage imageNamed:@"password"];
    if (indexPath.row == 0) {
        [cell.contentView addSubview:self.phoneTextField];
        [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
            make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
            make.height.mas_offset(30);
        }];
    } else {
        [cell.contentView addSubview:self.passwordTextField];
        [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
            make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
            make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
            make.height.mas_offset(30);
        }];
    }
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)loginAction:(id)sender {
    [self.phoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    if (XLIsNullObject(self.phoneTextField.text)) {
        XLShowThenDismissHUD(NO, @"请先输入用户名", self.view);
        return;
    }
    if (XLIsNullObject(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, @"请先输入密码", self.view);
        return;
    }
    XLShowHUDWithMessage(@"正在登录", self.view);
    [UserModel userLogin:self.phoneTextField.text password:self.passwordTextField.text hanlder:^(id object, NSString *msg) {
        if (object) {
            UserModel *model = object;
            [[NSUserDefaults standardUserDefaults] setObject:model.token forKey:USERTOKEN];
            [[NSUserDefaults standardUserDefaults] setObject:model.vrRoomId forKey:ROOMID];
            [[NSUserDefaults standardUserDefaults] setObject:model.vrRoomName forKey:VRROOMNAME];
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneTextField.text forKey:USERNAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - Getters
- (UITextField *)phoneTextField {
    if (!_phoneTextField) {
        _phoneTextField = [[UITextField alloc] init];
        [_phoneTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneTextField.font = [UIFont systemFontOfSize:14];
        _phoneTextField.textColor = MAIN_TEXT_COLOR;
        _phoneTextField.placeholder = @"请输入您的账号";
        _phoneTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _phoneTextField.delegate = self;
    }
    return _phoneTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        [_passwordTextField setValue:kHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        _passwordTextField.textColor = MAIN_TEXT_COLOR;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = @"请输入您的密码";
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyDone;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}

@end
