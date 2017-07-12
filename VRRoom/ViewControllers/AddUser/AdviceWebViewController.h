//
//  AdviceWebViewController.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/5/4.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonsDefines.h"

@interface AdviceWebViewController : UIViewController
@property (assign, nonatomic) XJAdviceType adviceType;
@property (copy, nonatomic) NSString *resultId;
@end
