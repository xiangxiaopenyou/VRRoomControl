//
//  PrescriptionContentsTableViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "PrescriptionContentsTableViewController.h"
#import "PrescriptionContentCell.h"
#import "TitlesPickerView.h"

#import "PrescriptionContentModel.h"
#import "ManagerModel.h"

#import "CommonsDefines.h"
#import "UtilDefine.h"

#import <UIImageView+AFNetworking.h>
@interface PrescriptionContentsTableViewController ()
@property (strong, nonatomic) TitlesPickerView *titlesPickerView;

@property (copy, nonatomic) NSArray *contentsArray;
@property (copy, nonatomic) NSArray *devicesArray;
@property (strong, nonatomic) ManagerModel *selectedManagerModel;
@property (strong, nonatomic) PrescriptionContentModel *operationModel;

@end

@implementation PrescriptionContentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.tableFooterView = [UIView new];
    [self fetchContents];
    [self fetchDevices];
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.view addSubview:self.titlesPickerView];
    __weak typeof (self) weakSelf = self;
    self.titlesPickerView.block = ^(ManagerModel *model) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (model) {
            strongSelf.selectedManagerModel = model;
            [strongSelf alertTip];
        }
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertTip {
    NSString *tipMessage = [NSString stringWithFormat:@"请检查%@眼镜是否正在使用", self.selectedManagerModel.user_username];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意事项" message:tipMessage preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
         [self addTask];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:playAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - IBAction
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Request
- (void)fetchContents {
    [PrescriptionContentModel fetchContents:self.prescriptionId handler:^(id object, NSString *msg) {
        if (object) {
            self.contentsArray = [(NSArray *)object copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}
- (void)fetchDevices {
    NSString *roomId = [[NSUserDefaults standardUserDefaults] stringForKey:ROOMID];
    [ManagerModel fetchManagers:roomId handler:^(id object, NSString *msg) {
        self.devicesArray = [(NSArray *)object copy];
        if (self.devicesArray.count > 0) {
            self.selectedManagerModel = self.devicesArray[0];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.titlesPickerView resetContents:self.devicesArray selected:self.selectedManagerModel];
        });
    }];
}
- (void)addTask {
    XLShowHUDWithMessage(nil, self.view);
    [ManagerModel addTask:self.operationModel.contentId prescriptionContent:self.operationModel.id type:self.operationModel.content_type userId:self.selectedManagerModel.userId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, YES, YES, @"成功");
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

//- (void)operationAction:(UIButton *)button {
//    PrescriptionContentModel *tempModel = self.contentsArray[button.tag - 1000];
//    self.operationModel = tempModel;
//    [self.titlesPickerView resetContents:self.devicesArray selected:self.selectedManagerModel];
//    [self.titlesPickerView show];
//}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count * 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row % 2 == 0 ? 10 : 108.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row % 2 == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SeparatorCell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        PrescriptionContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PrescriptionContentCell" forIndexPath:indexPath];
        PrescriptionContentModel *tempModel = self.contentsArray[indexPath.row / 2];
        [cell.contentImageView setImageWithURL:[NSURL URLWithString:tempModel.content_coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", tempModel.content_name];
        //    if ([tempModel.content_type integerValue] == 1) {
        //        cell.typeLabel.text = @"类型：视频";
        //    } else if ([tempModel.content_type integerValue] == 2) {
        //        cell.typeLabel.text = @"类型：音频";
        //    }
        NSString *unit;
        if ([tempModel.periodUnit integerValue] == 1) {
            unit = @"日";
        } else if ([tempModel.periodUnit integerValue] == 2) {
            unit = @"周";
        } else {
            unit = @"月";
        }
        cell.timesLabel.text = [NSString stringWithFormat:@"%@次/%@-共%@%@-合计%@次 已使用%@次", @([tempModel.frequency integerValue]), unit, @([tempModel.period integerValue]), unit, @([tempModel.times integerValue]), @([tempModel.useTimes integerValue])];
        cell.dateLabel.text = [NSString stringWithFormat:@"上次使用时间 : %@", tempModel.lastUseAt];
        if (XLIsNullObject(tempModel.lastUseAt)) {
            cell.dateLabel.hidden = YES;
        } else {
            cell.dateLabel.hidden = NO;
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row % 2 == 1) {
        PrescriptionContentModel *tempModel = self.contentsArray[indexPath.row / 2];
        self.operationModel = tempModel;
        [self.titlesPickerView resetContents:self.devicesArray selected:self.selectedManagerModel];
        [self.titlesPickerView show];
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
- (TitlesPickerView *)titlesPickerView {
    if (!_titlesPickerView) {
        _titlesPickerView = [[TitlesPickerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _titlesPickerView;
}

@end
