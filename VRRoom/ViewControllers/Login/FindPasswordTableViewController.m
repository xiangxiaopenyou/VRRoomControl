//
//  FindPasswordTableViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "FindPasswordTableViewController.h"
#import "RegisterPhoneCell.h"
#import "LoginContentCell.h"
#import "UserModel.h"


@interface FindPasswordTableViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *phoneNumberTextField;
@property (strong, nonatomic) UITextField *codeTextField;
@property (strong, nonatomic) UITextField *passwordTextField;
@property (strong, nonatomic) UITextField *validatePasswordTextField;
@property (strong, nonatomic) UIButton *fetchCodeButton;

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger countInt;

@end

@implementation FindPasswordTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self resignTextField];
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)submitClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    if (!GJCFStringIsMobilePhone(self.phoneNumberTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputCorrectPhoneNumberTip, self.view);
        return;
    }
    if (XLIsNullObject(self.codeTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputVerificationCodeTip, self.view);
        return;
    }
    if (XLIsNullObject(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputPasswordTip, self.view);
        return;
    }
    if (!XLCheckPassword(self.passwordTextField.text)) {
        XLShowThenDismissHUD(NO, XJPasswordFormatTip, self.view);
        return;
    }
    if (![self.passwordTextField.text isEqualToString:self.validatePasswordTextField.text]) {
        XLShowThenDismissHUD(NO, XJDifferentPasswordTip, self.view);
        return;
    }
    XLShowHUDWithMessage(nil, self.view);
//    [UsersModel findPassword:self.phoneNumberTextField.text password:self.passwordTextField.text code:self.codeTextField.text handler:^(id object, NSString *msg) {
//        if (object) {
//            XLDismissHUD(self.view, YES, YES, @"成功");
//            [self.navigationController popViewControllerAnimated:YES];
//        } else {
//            XLDismissHUD(self.view, YES, NO, msg);
//        }
//    }];
}

- (void)fetchCodeClick {
    if (!GJCFStringIsMobilePhone(self.phoneNumberTextField.text)) {
        XLShowThenDismissHUD(NO, XJInputCorrectPhoneNumberTip, self.view);
        return;
    }
    self.fetchCodeButton.enabled = NO;
    self.countInt = 60;
    [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    [self.fetchCodeButton setTitleColor:BREAK_LINE_COLOR forState:UIControlStateNormal];
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countNumber) userInfo:nil repeats:YES];
    }
//    [UsersModel fetchCode:self.phoneNumberTextField.text handler:^(id object, NSString *msg) {
//        
//    }];
}

#pragma mark - Private methods
- (void)countNumber {
    if (self.countInt == 0) {
        [self.timer invalidate];
        self.timer = nil;
        self.fetchCodeButton.enabled = YES;
        [self.fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
        [self.fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        
    } else {
        self.countInt -= 1;
        [self.fetchCodeButton setTitle:[NSString stringWithFormat:@"%@", @(self.countInt)] forState:UIControlStateNormal];
    }
}

- (void)resignTextField {
    [self.passwordTextField resignFirstResponder];
    [self.phoneNumberTextField resignFirstResponder];
    [self.codeTextField resignFirstResponder];
    [self.validatePasswordTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.passwordTextField) {
        [self.validatePasswordTextField becomeFirstResponder];
    } else if (textField == self.validatePasswordTextField) {
        [self.validatePasswordTextField resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"ContenCell";
    static NSString *phoneCellIdentifier = @"PhoneCell";
    switch (indexPath.row) {
        case 0:{
            RegisterPhoneCell *cell = [tableView dequeueReusableCellWithIdentifier:phoneCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"phone_number"];
            [cell.contentView addSubview:self.phoneNumberTextField];
            [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-112);
                make.height.mas_offset(30);
            }];
            [cell.contentView addSubview:self.fetchCodeButton];
            [self.fetchCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-22);
                make.top.equalTo(cell.contentView.mas_top);
                make.height.mas_offset(44);
                make.width.mas_offset(80);
            }];
            return cell;
        }
            break;
        case 1:{
            LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"Identify_code"];
            [cell.contentView addSubview:self.codeTextField];
            [self.codeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
            return cell;
        }
            break;
        case 2:{
            LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:self.passwordTextField];
            [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
            return cell;
        }
            break;
        case 3:{
            LoginContentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.iconImageView.image = [UIImage imageNamed:@"password"];
            [cell.contentView addSubview:self.validatePasswordTextField];
            [self.validatePasswordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.equalTo(cell.contentView.mas_leading).with.mas_offset(79);
                make.top.equalTo(cell.contentView.mas_top).with.mas_offset(7);
                make.trailing.equalTo(cell.contentView.mas_trailing).with.mas_offset(-37);
                make.height.mas_offset(30);
            }];
            return cell;
        }
            break;
            
        default:
            return nil;
            break;
    }
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

#pragma mark - Set & Get
- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] init];
        [_phoneNumberTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _phoneNumberTextField.font = XJSystemFont(14);
        _phoneNumberTextField.textColor = MAIN_TEXT_COLOR;
        _phoneNumberTextField.placeholder = XJInputPhoneNumber;
        _phoneNumberTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
        _phoneNumberTextField.delegate = self;
    }
    return _phoneNumberTextField;
}
- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = [[UITextField alloc] init];
        [_passwordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.font = XJSystemFont(14);
        _passwordTextField.textColor = MAIN_TEXT_COLOR;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.placeholder = XJInputPassword;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.returnKeyType = UIReturnKeyNext;
        _passwordTextField.delegate = self;
    }
    return _passwordTextField;
}
- (UITextField *)codeTextField {
    if (!_codeTextField) {
        _codeTextField = [[UITextField alloc] init];
        [_codeTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _codeTextField.font = XJSystemFont(14);
        _codeTextField.textColor = MAIN_TEXT_COLOR;
        _codeTextField.placeholder = XJInputVerificationCode;
        _codeTextField.clearButtonMode =  UITextFieldViewModeWhileEditing;
        _codeTextField.keyboardType = UIKeyboardTypeNumberPad;
        _codeTextField.delegate = self;
    }
    return _codeTextField;
}
- (UITextField *)validatePasswordTextField {
    if (!_validatePasswordTextField) {
        _validatePasswordTextField = [[UITextField alloc] init];
        [_validatePasswordTextField setValue:XJHexRGBColorWithAlpha(0xd0d0d0, 1.0) forKeyPath:@"_placeholderLabel.textColor"];
        _validatePasswordTextField.font = XJSystemFont(14);
        _validatePasswordTextField.textColor = MAIN_TEXT_COLOR;
        _validatePasswordTextField.secureTextEntry = YES;
        _validatePasswordTextField.placeholder = XJInputPasswordAgain;
        _validatePasswordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _validatePasswordTextField.returnKeyType = UIReturnKeyDone;
        _validatePasswordTextField.delegate = self;
    }
    return _validatePasswordTextField;
}
- (UIButton *)fetchCodeButton {
    if (!_fetchCodeButton) {
        _fetchCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fetchCodeButton setTitle:XJFetchVerificationCode forState:UIControlStateNormal];
        [_fetchCodeButton setTitleColor:NAVIGATIONBAR_COLOR forState:UIControlStateNormal];
        _fetchCodeButton.titleLabel.font = XJSystemFont(14);
        [_fetchCodeButton addTarget:self action:@selector(fetchCodeClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _fetchCodeButton;
}


@end
