//
//  XJAddPlanViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJAddPlanViewController.h"
#import "SceneContentsListViewController.h"
#import "XJAddContentItemCell.h"
#import "XJAddContentCell.h"

#import "ContentModel.h"
#import "XJPlanModel.h"

#import <UIImageView+WebCache.h>

@interface XJAddPlanViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightItem;

@property (strong, nonatomic) NSMutableArray *contentsArray;

@end

@implementation XJAddPlanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.nameTextField.borderStyle = UITextBorderStyleNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)nameChanged:(id)sender {
    [self checkIsCanSubmit];
}
- (IBAction)addAction:(id)sender {
    SceneContentsListViewController *listViewController = [[UIStoryboard storyboardWithName:@"AddUser" bundle:nil] instantiateViewControllerWithIdentifier:@"SceneContentsList"];
    listViewController.viewType = 2;
    listViewController.selectedContents = [self.contentsArray mutableCopy];
    listViewController.isCollectionView = YES;
    listViewController.isAddPlan = YES;
    listViewController.selectedBlock = ^(NSArray *array) {
        self.contentsArray = [array mutableCopy];
        GJCFAsyncMainQueue(^{
            [self checkIsCanSubmit];
            [self.tableView reloadData];
        });
    };
    [self.navigationController pushViewController:listViewController animated:YES];
}
- (IBAction)submitAction:(id)sender {
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    for (ContentModel *tempModel in self.contentsArray) {
        [tempArray addObject:tempModel.id];
    }
    NSString *contentIdsString = [tempArray componentsJoinedByString:@","];
    XLShowHUDWithMessage(nil, XJKeyWindow);
    [XJPlanModel addPlan:self.nameTextField.text contentId:contentIdsString handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(XJKeyWindow, YES, YES, @"添加成功");
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            XLDismissHUD(XJKeyWindow, YES, NO, msg);
        }
    }];
}

#pragma mark - Private methods
- (void)checkIsCanSubmit {
    if (self.nameTextField.text.length > 0 && self.contentsArray.count > 0) {
        self.rightItem.enabled = YES;
    } else {
        self.rightItem.enabled = NO;
    }
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentsArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"AddContentItemCell";
    XJAddContentItemCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ContentModel *tempModel = self.contentsArray[indexPath.row];
    [cell.contentImageView sd_setImageWithURL:[NSURL URLWithString:tempModel.coverPic] placeholderImage:[UIImage imageNamed:@"default_image"]];
    cell.contentNameLabel.text = [NSString stringWithFormat:@"%@", tempModel.name];
    return cell;
}

#pragma mark - Table view delegate
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.contentsArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

#pragma mark - Getters
- (NSMutableArray *)contentsArray {
    if (!_contentsArray) {
        _contentsArray = [[NSMutableArray alloc] init];
    }
    return _contentsArray;
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
