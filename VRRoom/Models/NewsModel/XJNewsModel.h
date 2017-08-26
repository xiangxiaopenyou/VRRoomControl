//
//  XJNewsModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface XJNewsModel : XLModel
@property (copy, nonatomic) NSString *releasetime;
@property (copy, nonatomic) NSString *coverurl;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *linkurl;
+ (void)newsList:(RequestResultHandler)handler;

@end
