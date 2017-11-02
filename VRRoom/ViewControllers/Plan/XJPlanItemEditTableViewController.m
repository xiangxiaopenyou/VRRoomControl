//
//  XJPlanItemEditTableViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/1.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJPlanItemEditTableViewController.h"
#import "XJPlanItemEditCell.h"


@interface XJPlanItemEditTableViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *finishItem;

@end

@implementation XJPlanItemEditTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    if (self.itemType == XJPlanEditItemName) {
        self.title = @"编辑方案名";
    } else {
        self.title = @"编辑方案说明";
    }
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.itemType == XJPlanEditItemName) {
        UITextField *textField = (UITextField *)[self.tableView viewWithTag:10000];
        [textField becomeFirstResponder];
    } else {
        UITextView *textView = (UITextView *)[self.tableView viewWithTag:10001];
        [textView becomeFirstResponder];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - IBAction
- (IBAction)closeAction:(id)sender {
    UITextField *textField = (UITextField *)[self.tableView viewWithTag:10000];
    [textField resignFirstResponder];
    UITextView *textView = (UITextView *)[self.tableView viewWithTag:10001];
    [textView resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)finishAction:(id)sender {
    if (self.finishBlock) {
        self.finishBlock(self.editString);
    }
    [self closeAction:nil];
}
- (void)textFieldEditingChanged:(UITextField *)textField {
    self.editString = textField.text;
    self.finishItem.enabled = textField.text.length == 0 ? NO : YES;
}


#pragma mark - Text view delegate
- (void)textViewDidChange:(UITextView *)textView {
    self.editString = textView.text;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.itemType == XJPlanEditItemName ? 60.f : 120.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XJPlanItemEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlanItemEditCell" forIndexPath:indexPath];
    if (self.itemType == XJPlanEditItemName) {
        cell.textField.text = self.editString;
        cell.textView.hidden = YES;
        [cell.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    } else {
        cell.textView.text = self.editString;
        cell.textField.hidden = YES;
        cell.textView.delegate = self;
    }
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [UIView new];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
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
