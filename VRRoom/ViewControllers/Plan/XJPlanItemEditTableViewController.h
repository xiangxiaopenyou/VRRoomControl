//
//  XJPlanItemEditTableViewController.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/11/1.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XJPlanItemEditTableViewController : UITableViewController
@property (assign, nonatomic) XJPlanEditItem itemType;
@property (copy, nonatomic) NSString *editString;
@property (copy, nonatomic) void (^finishBlock)(NSString *resultString);

@end
