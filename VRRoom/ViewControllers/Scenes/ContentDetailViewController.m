//
//  ContentDetailViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/17.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ContentDetailViewController.h"
//#import "XJContentWebViewController.h"
//#import "DetailContentCell.h"
//#import "AudioPlayerView.h"
#import "XLBlockAlertView.h"

#import "ContentModel.h"
//#import "ContentsMediaModel.h"

#import <UIImageView+WebCache.h>
#import <UIImage-Helpers.h>

//#import <UtoVRPlayer/UtoVRPlayer.h>
//#import <SDCycleScrollView.h>

static NSString * const XJContentUrl = @"http://support.med-vision.cn/";

@interface ContentDetailViewController ()</*UVPlayerDelegate,UITableViewDelegate, UITableViewDataSource, SDCycleScrollViewDelegate,*/ UIWebViewDelegate>
//@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *collectButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic) NSInteger isAdded;

@end

@implementation ContentDetailViewController

#pragma mark - UIViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStyleDone target:self action:@selector(closeAction)]];
    XLShowHUDWithMessage(nil, self.view);
    [self.collectButton setBackgroundImage:[UIImage imageWithColor:NAVIGATIONBAR_COLOR] forState:UIControlStateSelected];
    [self.collectButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithWhite:0.9 alpha:1]] forState:UIControlStateNormal];
    [self refreshBottomButtonState];
    _isAdded = self.contentModel.isAdded.integerValue;
    [self fetchDetails:self.contentModel.id];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//设置底部按钮
- (void)refreshBottomButtonState {
    if (self.viewType == 1) {
        [self.collectButton setTitle:@"收藏" forState:UIControlStateNormal];
        [self.collectButton setTitle:@"已收藏" forState:UIControlStateSelected];
        self.collectButton.selected = [self.contentModel.isCollected integerValue] == 0 ? NO : YES;
    } else {
        [self.collectButton setTitle:@"选择" forState:UIControlStateNormal];
//        [self.collectButton setTitle:@"已选择" forState:UIControlStateSelected];
//        self.collectButton.selected = [self.contentModel.isAdded integerValue] == 0 ? NO : YES;
    }
}

#pragma mark - Requests
- (void)fetchDetails:(NSString *)contentId {
    [ContentModel fetchContentDetail:contentId handler:^(id object, NSString *msg) {
        if (object) {
            XLDismissHUD(self.view, NO, YES, nil);
            self.contentModel = object;
            GJCFAsyncMainQueue((^{
                NSString *urlString = [NSString stringWithFormat:@"%@%@", XJContentUrl, self.contentModel.contentDescription];
                urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *requestUrl = [NSURL URLWithString:urlString];
                [self.webView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
                [self refreshBottomButtonState];
            }));
        } else {
            XLDismissHUD(self.view, YES, NO, msg);
        }
    }];
}

#pragma mark - IBAction & Selector
- (void)closeAction {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
- (IBAction)collectAction:(id)sender {
    if (self.viewType == 1) {
        if (self.contentModel.isCollected.integerValue == 0) {
            self.contentModel.isCollected = @(1);
            [ContentModel collectContent:self.contentModel.id handler:nil];
            XLDismissHUD(self.view, YES, YES, @"收藏成功");
        } else {
            self.contentModel.isCollected = @(0);
            [ContentModel cancelCollectContent:self.contentModel.id handler:nil];
            XLDismissHUD(self.view, YES, YES, @"取消收藏成功");
        }
        [self refreshBottomButtonState];
    } else {
        //self.contentModel.isAdded = self.contentModel.isAdded.integerValue == 0 ? @(1) : @(0);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.collectBlock) {
        self.collectBlock(self.contentModel);
    }
}

#pragma mark - Webview delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    XLDismissHUD(self.view, NO, YES, nil);
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    XLDismissHUD(self.view, YES, NO, @"加载失败");
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
