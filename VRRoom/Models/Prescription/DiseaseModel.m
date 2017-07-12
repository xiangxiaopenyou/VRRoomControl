//
//  DiseaseModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/13.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "DiseaseModel.h"
#import "TherapyModel.h"
#import "XJFetchDiseasesRequest.h"
//#import "FetchDiseaseAndTherapiesRequest.h"

@implementation DiseaseModel
+ (void)fetchDiseasesList:(RequestResultHandler)handler {
    [[XJFetchDiseasesRequest new] request:^BOOL(id request) {
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *resultArray = [DiseaseModel setupWithArray:(NSArray *)object];
            !handler ?: handler(resultArray, nil);
        }
    }];
}
+ (void)fetchDiseasesAndTherapies:(RequestResultHandler)handler {
//    [[FetchDiseaseAndTherapiesRequest new] request:^BOOL(id request) {
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (msg) {
//            !handler ?: handler(nil, msg);
//        } else {
//            if ([object isKindOfClass:[NSArray class]]) {
//                NSArray *tempArray = [DiseaseModel setupWithArray:(NSArray *)object];
//                NSMutableArray *resultArray = [[NSMutableArray alloc] init];
//                [tempArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    DiseaseModel *tempModel = (DiseaseModel *)obj;
//                    NSArray *array = [TherapyModel setupWithArray:tempModel.therapiesArray];
//                    tempModel.therapiesArray = array;
//                    [resultArray addObject:tempModel];
//                    if (resultArray.count == tempArray.count) {
//                        !handler ?: handler(resultArray, nil);
//                    }
//                }];
//            } else {
//                !handler ?: handler(nil, XJNetworkError);
//            }
//        }
//    }];
}

@end
