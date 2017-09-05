//
//  UtilDefine.h
//  DongDong
//
//  Created by 项小盆友 on 16/7/15.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import "Util.h"

/**
 *  屏幕宽和高
 */
#define SCREEN_WIDTH CGRectGetWidth(UIScreen.mainScreen.bounds)
#define SCREEN_HEIGHT CGRectGetHeight(UIScreen.mainScreen.bounds)

//推荐内容高度和宽度
#define kCollectionCellItemWidth (SCREEN_WIDTH - 5) / 2.0
#define kCollectionCellItemHeight kCollectionCellItemWidth * 30.0 / 37.0

/**
 *  判空
 */
#define XLIsNullObject(object) [Util isNullObject:object]
/**
 *  计算文字大小
 */
#define XLSizeOfText(aText, aWidth, aFont) [Util sizeOfText:aText width:aWidth font:aFont]

//提示
#define XLShowHUDWithMessage(aMessage, aView) [Util showHUDWithMessage:aMessage view:aView]

#define XLDismissHUD(aView, aShow, aSuccess, aMessage) [Util dismissHUD:aView showTip:aShow success:aSuccess message:aMessage]

#define XLShowThenDismissHUD(aSuccess, aMessage, aView) [Util showThenDismissHud:aSuccess message:aMessage view:aView]

//手机号验证
#define XLIsMobileNumber(aString) [Util isMobileNumber:aString]

//字符串是否含表情符
#define XLStringContainsEmoji(aString) [Util stringContainsEmoji:aString]

/**
 *验证密码格式
 */
#define XLCheckPassword(aString) [Util checkPassword:aString]

//用户注销
#define XLUserLogout [Util userLogout]



