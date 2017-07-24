//
//  DetailNavigationController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/24.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "DetailNavigationController.h"
#import "ContentDetailViewController.h"
#import "ContentModel.h"

#import <UIImage-Helpers.h>

@interface DetailNavigationController ()<UINavigationControllerDelegate>

@end

@implementation DetailNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"content_detail_header"] forBarMetrics:UIBarMetricsDefault];
    self.delegate = self;
    //[self.navigationBar setShadowImage:[UIImage new]];
}
//- (BOOL)shouldAutorotate {
//    return [self.contentModel.type integerValue] == 1 ? YES : NO;
//}
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.contentModel.type integerValue] == 1 ? UIInterfaceOrientationMaskAllButUpsideDown : UIInterfaceOrientationMaskPortrait;

//}
- (void)closeAction {
    [self popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[ContentDetailViewController class]]) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"content_detail_header"] forBarMetrics:UIBarMetricsDefault];
    } else {
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forBarMetrics:UIBarMetricsDefault];
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
