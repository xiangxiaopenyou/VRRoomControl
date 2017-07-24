//
//  ChangePasswordTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/12.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "ChangePasswordTableViewController.h"

#import "LoginContentCell.h"
#import "UserModel.h"

@interface ChangePasswordTableViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *oldPasswordTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *validatePasswordTextField;

@end

@implementation ChangePasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)submitAction:(id)sender {
    [self.oldPasswordTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.validatePasswordTextField resignFirstResponder];
    if (XLIsNullObject(self.oldPasswordTextField.text)) {
        XLShowThenDismissHUD(NO, @"请输入旧密码", self.view);
    }
    if (XLIsNullObject(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, @"请输入新密码", self.view);
        return;
    }
    if (XLIsNullObject(self.validatePasswordTextField.text)) {
        XLShowThenDismissHUD(NO, @"请再次输入新密码", self.view);
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.validatePasswordTextField.text]) {
        XLShowThenDismissHUD(NO, @"两次密码输入不一致", self.view);
        return;
    }
    XLShowHUDWithMessage(nil, self.view);
    [UserModel changePassword:self.oldPasswordTextField.text password:self.passwordTextField.text hanlder:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(XJKeyWindow, YES, YES, @"修改成功，请重新登录");
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERTOKEN];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:ROOMID];
//            [[NSUserDefaults standardUserDefaults] removeObjectForKey:VRROOMNAME];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self backAction:nil];
            [self performSelector:@selector(turnLogin) withObject:nil afterDelay:0.1];
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (IBAction)backAction:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - private methods
- (void)turnLogin {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginStateDidChanged" object:nil];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.oldPasswordTextField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (textField == self.passwordTextField) {
        [self.validatePasswordTextField becomeFirstResponder];
    } else {
        [self.validatePasswordTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContentCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.iconImageView.image = [UIImage imageNamed:@"password"];
    switch (indexPath.row) {
        case 0:{
            [cell.contentView addSubview:self.oldPasswordTextField];
            [self.oldPasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];

        }
            break;
        case 1:{
            [cell.contentView addSubview:self.passwordTextField];
            [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];

        }
            break;
        case 2:{
            [cell.contentView addSubview:self.validatePasswordTextField];
            [self.validatePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];

        }
            
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - Getters
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        [_passwordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.font = XJSystemFont(14);
        _passwordTextField.textColor = MAIN_TEXT_COLOR;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = @"请输入新密码";
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}
- (UITextField *)oldPasswordTextField {
    if (!_oldPasswordTextField) {
        _oldPasswordTextField = [[UITextField alloc] init];
        [_oldPasswordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _oldPasswordTextField.font = XJSystemFont(14);
        _oldPasswordTextField.textColor = MAIN_TEXT_COLOR;
        _oldPasswordTextField.secureTextEntry = YES;
        _oldPasswordTextField.placeholder = @"请输入旧密码";
        _oldPasswordTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _oldPasswordTextField.delegate = self;
    }
    return _oldPasswordTextField;
}
- (UITextField *)validatePasswordTextField {
    if (!_validatePasswordTextField) {
        _validatePasswordTextField = [[UITextField alloc] init];
        [_validatePasswordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _validatePasswordTextField.font = XJSystemFont(14);
        _validatePasswordTextField.textColor = MAIN_TEXT_COLOR;
        _validatePasswordTextField.secureTextEntry = YES;
        _validatePasswordTextField.placeholder = @"请再次输入新密码";
        _validatePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validatePasswordTextField.returnKeyType = UIReturnKeyDone;
        _validatePasswordTextField.delegate = self;
    }
    return _validatePasswordTextField;
}

@end
