//
//  ProvincesModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/12/29.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "ProvincesModel.h"
#import "FetchCitiesRequest.h"

@implementation ProvincesModel

+ (void)fetchAreas:(RequestResultHandler)handler {
    [[FetchCitiesRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [ProvincesModel setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}

@end
