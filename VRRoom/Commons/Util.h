//
//  Util.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Util : NSObject

+ (BOOL)isNullObject:(id)anObject;
+ (CGSize)sizeOfText:(NSString *)text width:(CGFloat)width font:(UIFont *)font;
+ (void)showHUDWithMessage:(NSString *)message view:(UIView *)view;
+ (void)dismissHUD:(UIView *)view showTip:(BOOL)isShow success:(BOOL)isSuccess message:(NSString *)message;
+ (void)showThenDismissHud:(BOOL)success message:(NSString *)message view:(UIView *)view;
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)checkPassword:(NSString *)password;
@end
