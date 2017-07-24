//
//  ContentModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "ContentModel.h"
#import "SearchContentsRequest.h"
#import "FetchContentDetailRequest.h"
#import "CollectRequest.h"
#import "CancelCollectRequest.h"
#import "FetchCollectionsListRequest.h"

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
    [[SearchContentsRequest new] request:^BOOL(SearchContentsRequest *request) {
        request.diseaseId = diseaseId;
        request.therapyId = therapyId;
        request.keyword = keyword;
        request.paging = paging;
        request.sortOrder = sortOrder;
        request.sortName = sortName;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [ContentModel setupWithArray:(NSArray *)object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchCollectionsList:(NSNumber *)paging handler:(RequestResultHandler)handler {
    [[FetchCollectionsListRequest new] request:^BOOL(FetchCollectionsListRequest *request) {
        request.paging = paging;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [ContentModel setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)fetchContentDetail:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[FetchContentDetailRequest new] request:^BOOL(FetchContentDetailRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            ContentModel *tempModel = [ContentModel yy_modelWithDictionary:object];
            !handler ?: handler(tempModel, nil);
        }
    }];
}
+ (void)collectContent:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[CollectRequest new] request:^BOOL(CollectRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:handler];
}
+ (void)cancelCollectContent:(NSString *)contentId handler:(RequestResultHandler)handler {
    [[CancelCollectRequest new] request:^BOOL(CancelCollectRequest *request) {
        request.contentId = contentId;
        return YES;
    } result:handler];
}

@end
