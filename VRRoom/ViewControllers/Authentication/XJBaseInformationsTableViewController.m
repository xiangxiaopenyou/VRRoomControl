//
//  XJBaseInformationsTableViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/28.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJBaseInformationsTableViewController.h"
#import "XJBaseInformationCell.h"

#import "InformationModel.h"

#import <UIImageView+WebCache.h>

@interface XJBaseInformationsTableViewController ()
@property (copy, nonatomic) NSArray *headTitleArray;
@property (strong, nonatomic) InformationModel *model;

@end

@implementation XJBaseInformationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    XLShowHUDWithMessage(nil, XJKeyWindow);
    [self fetchInformations];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Request
//获取认证消息
- (void)fetchInformations {
    [InformationModel fetchInformations:^(id object, NSString *msg) {
        if (msg) {
            XLDismissHUD(XJKeyWindow, YES, NO, msg);
        } else {
            XLDismissHUD(XJKeyWindow, NO, YES, nil);
            self.model = (InformationModel *)object;
            if (self.model.workplaceType.integerValue == 1) {
                self.headTitleArray = @[@"头像", @"姓  名", @"性  别", @"医  院", @"科  室", @"职  称", @"城  市"];
            } else {
                self.headTitleArray = @[@"头像", @"姓  名", @"性  别", @"诊  所", @"职  位", @"职  称", @"城  市"];
            }
            if (![[NSUserDefaults standardUserDefaults] stringForKey:USER_PORTRAIT]) {
                [[NSUserDefaults standardUserDefaults] setObject:self.model.headPictureUrl forKey:USER_PORTRAIT];
                [[NSUserDefaults standardUserDefaults] setObject:self.model.realname forKey:REALNAME];
                [[NSUserDefaults standardUserDefaults] setObject:self.model.hospital forKey:USERHOSPITAL];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"XJUserStatusDidChange" object:nil];
            }
            GJCFAsyncMainQueue(^{
                [self.tableView reloadData];
            });
        }
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.headTitleArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == 0 ? 80.f : 58.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJBaseInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaseInformationCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.headLabel.text = self.headTitleArray[indexPath.row];
    cell.avatarImageView.hidden = indexPath.row == 0 ? NO : YES;
    NSString *detailString = nil;
    switch (indexPath.row) {
        case 0: {
            [cell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:self.model.headPictureUrl] placeholderImage:nil];
        }
            break;
        case 1: {
            detailString = self.model.realname;
        }
            break;
        case 2: {
            detailString = self.model.gender.integerValue == 1 ? @"男" : @"女";
        }
            break;
        case 3: {
            detailString = self.model.hospital;
        }
            break;
        case 4: {
            detailString = self.model.workplaceType.integerValue == 1 ? self.model.department : self.model.position;
        }
            break;
        case 5: {
            detailString = self.model.professionalTitle;
        }
            break;
        case 6: {
            detailString = self.model.regionFullName;
        }
            break;
        default:
            break;
    }
    cell.rightLabel.text = detailString;
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

@end
