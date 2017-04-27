//
//  CommonsDefines.h
//  DongDong
//
//  Created by 项小盆友 on 16/6/6.
//  Copyright © 2016年 项小盆友. All rights reserved.
//
#import <UIKit/UIKit.h>
//用户相关
extern NSString * const USERTOKEN;
extern NSString * const ROOMID;
extern NSString * const VRROOMNAME;
extern NSString * const SEARCHHISTORY;
extern NSString * const USERNAME;

//常用数值
extern CGFloat const TABBARHEIGHT;
extern CGFloat const NAVIGATIONBARHEIGHT;

//接口
//1.BaseURL
extern NSString * const BASEAPIURL;

#define MAIN_TEXT_COLOR [UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1.0]
#define NAVIGATIONBAR_COLOR [UIColor colorWithRed:82/255.0 green:184/255.0 blue:255/255.0 alpha:1.0]
#define TABBAR_TITLE_COLOR [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0]
#define MAIN_BACKGROUND_COLOR [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0]
#define BREAK_LINE_COLOR [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0]

/**
 *  RGB颜色
 */
#define kRGBColor(r,g,b,a)	[UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

/**
 *  Hex颜色转RGB颜色
 */
#define kHexRGBColorWithAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

/**
 *  系统字体
 */
#define kSystemFont(x) [UIFont systemFontOfSize:x]
#define kBoldSystemFont(x) [UIFont boldSystemFontOfSize:x]








