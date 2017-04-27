//
//  Util.m
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "Util.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MBProgressHUD+Add.h"

@implementation Util

+ (BOOL)isNullObject:(id)anObject {
    if (!anObject || [anObject isEqual:@""] || [anObject isEqual:[NSNull null]] || [anObject isKindOfClass:[NSNull class]]) {
        return YES;
    } else {
        return NO;
    }
}

+ (void)showHUDWithMessage:(NSString *)message view:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.square = YES;
    if (message) {
        hud.labelText = message;
    }
}
+ (void)dismissHUD:(UIView *)view showTip:(BOOL)isShow success:(BOOL)isSuccess message:(NSString *)message {
    [MBProgressHUD hideHUDForView:view animated:YES];
    if (isShow) {
        [self showThenDismissHud:isSuccess message:message view:view];
    }
}
+ (void)showThenDismissHud:(BOOL)success message:(NSString *)message view:(UIView *)view {
    if (success) {
        [MBProgressHUD showSuccess:message toView:view];
    } else {
        [MBProgressHUD showError:message toView:view];
    }
}

@end
