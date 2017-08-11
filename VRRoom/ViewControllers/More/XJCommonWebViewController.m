//
//  XJCommonWebViewController.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/4.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJCommonWebViewController.h"

@interface XJCommonWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XJCommonWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    NSURL *requestUrl = [NSURL URLWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
    XLShowHUDWithMessage(@"正在加载", self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void)backAction {
    if (self.webView.canGoBack) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)closeAction {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Web view delegate
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (webView.isLoading) {
        return;
    }
    XLDismissHUD(self.view, NO, YES, nil);
    if (webView.canGoBack) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_cycle"] style:UIBarButtonItemStylePlain target:self action:@selector(closeAction)];
        self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
    } else {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    }
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
