//
//  ContentModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "ContentModel.h"
//#import "SearchContentsRequest.h"

@implementation ContentModel
+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper {
    return @{@"contentDescription" : @"description"};
}
+ (void)searchContents:(NSString *)diseaseId
               therapy:(NSString *)therapyId
               keyword:(NSString *)keyword
                  page:(NSNumber *)paging
              sortName:(NSString *)sortName
             sortOrder:(NSString *)sortOrder
               handler:(RequestResultHandler)handler {
//    [[SearchContentsRequest new] request:^BOOL(SearchContentsRequest *request) {
//        request.diseaseId = diseaseId;
//        request.therapyId = therapyId;
//        request.keyword = keyword;
//        request.paging = paging;
//        request.sortOrder = sortOrder;
//        request.sortName = sortName;
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (msg) {
//            !handler ?: handler(nil, msg);
//        } else {
//            NSArray *tempArray = [ContentModel setupWithArray:(NSArray *)object];
//            !handler ?: handler(tempArray, nil);
//        }
//    }];
}

@end
