//
//  TitlesModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "TitlesModel.h"
#import "FetchProfessionalTitlesRequest.h"

@implementation TitlesModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"titleId" : @"id"};
}
+ (void)professionalTitles:(RequestResultHandler)handler {
    [[FetchProfessionalTitlesRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [TitlesModel setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}


@end
