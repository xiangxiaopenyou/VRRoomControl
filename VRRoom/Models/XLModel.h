//
//  XLModel.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>
#import "BaseRequest.h"

@interface XLModel : NSObject<YYModel>
+ (NSArray *)setupWithArray:(NSArray *)array;

@end
