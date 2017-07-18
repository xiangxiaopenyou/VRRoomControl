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

//视频通话
#define DEMO_CALL 1

/**
 *  常用颜色
 */
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:82/255.0 green:184/255.0 blue:255/255.0 alpha:1.0]
#define TABBAR_TITLE_COLOR [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]
#define MAIN_BACKGROUND_COLOR [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
#define BREAK_LINE_COLOR [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0]
#define MAIN_TEXT_COLOR [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]

///**
// *  RGB颜色
// */
//#define kRGBColor(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//
///**
// *  Hex颜色转RGB颜色
// */
//#define kHexRGBColorWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]
//
///**
// *  系统字体
// */
//#define kSystemFont(x) [UIFont systemFontOfSize:x]
//#define kBoldSystemFont(x) [UIFont boldSystemFontOfSize:x]
/**
 *  判空
 */
#define XLIsNullObject(object) [Util isNullObject:object]


//提示
#define XLShowHUDWithMessage(aMessage, aView) [Util showHUDWithMessage:aMessage view:aView]

#define XLDismissHUD(aView, aShow, aSuccess, aMessage) [Util dismissHUD:aView showTip:aShow success:aSuccess message:aMessage]

#define XLShowThenDismissHUD(aSuccess, aMessage, aView) [Util showThenDismissHud:aSuccess message:aMessage view:aView]



