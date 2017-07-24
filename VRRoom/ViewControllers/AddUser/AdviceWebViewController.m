//
//  AdviceWebViewController.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/4.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "AdviceWebViewController.h"
#import "CommonsDefines.h"
#import "UtilDefine.h"

@interface AdviceWebViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AdviceWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *urlString = ADVICEBASEURL;
    switch (self.adviceType) {
        case XJAdviceTypeAll:
            urlString = ADVICEBASEURL;
            break;
        case XJAdviceTypeDisease:{
            urlString = [NSString stringWithFormat:@"%@disease?id=%@", ADVICEBASEURL, self.resultId];
        }
            break;
        case XJAdviceTypeTherapy:{
            urlString = [NSString stringWithFormat:@"%@therapy?id=%@", ADVICEBASEURL, self.resultId];
        }
        default:
            break;
    }
    NSURL *requestUrl = [NSURL URLWithString:urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:requestUrl]];
    XLShowHUDWithMessage(@"正在加载", self.view);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backAction:(id)sender {
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - UIWebViewDelegate
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
