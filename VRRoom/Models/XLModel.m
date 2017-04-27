//
//  XLModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/26.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "XLModel.h"

@implementation XLModel
+ (NSArray *)setupWithArray:(NSArray *)array {
    NSMutableArray *resultArray = [NSMutableArray array];
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        XLModel *model = [self yy_modelWithDictionary:obj];
        [resultArray addObject:model];
    }];
    return resultArray;
}
@end
