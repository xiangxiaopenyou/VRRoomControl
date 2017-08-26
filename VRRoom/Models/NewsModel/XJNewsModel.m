//
//  XJNewsModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/8/23.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XJNewsModel.h"
#import "XJFetchNewsListRequest.h"

@implementation XJNewsModel
+ (void)newsList:(RequestResultHandler)handler {
    [[XJFetchNewsListRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler (nil, msg);
        } else {
            NSArray *tempArray = [XJNewsModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
