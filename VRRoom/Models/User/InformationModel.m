//
//  InformationModel.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/5.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "InformationModel.h"
//#import "UploadImageRequest.h"
//#import "UploadImagesRequest.h"
//#import "SubmitInformationsRequest.h"
//#import "FetchInformationsRequest.h"

@implementation InformationModel
//+ (void)uploadCommonImage:(NSString *)name fileType:(NSNumber *)type data:(NSData *)data handler:(RequestResultHandler)handler {
//    [[UploadImageRequest new] request:^BOOL(UploadImageRequest *request) {
//        request.fileName = name;
//        request.fileType = type;
//        request.fileData = data;
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (msg) {
//            !handler ?: handler(nil, msg);
//        } else {
//            !handler ?: handler(object, nil);
//        }
//    }];
//}
//+ (void)uploadAuthenticationImages:(NSArray *)images fileType:(NSNumber *)type handler:(RequestResultHandler)handler {
//    [[UploadImagesRequest new] request:^BOOL(UploadImagesRequest *request) {
//        request.imagesArray = images;
//        request.type = type;
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (msg) {
//            !handler ?: handler(nil, msg);
//        } else {
//            !handler ?: handler(object, nil);
//        }
//    }];
//}
//+ (void)uploadInformations:(InformationModel *)model handler:(RequestResultHandler)handler {
//    [[SubmitInformationsRequest new] request:^BOOL(SubmitInformationsRequest *request) {
//        request.model = model;
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (msg) {
//            !handler ?: handler(nil, msg);
//        } else {
//            !handler ?: handler(object, nil);
//        }
//    }];
//}
//+ (void)fetchInformations:(RequestResultHandler)handler {
//    [[FetchInformationsRequest new] request:^BOOL(id request) {
//        return YES;
//    } result:^(id object, NSString *msg) {
//        if (msg) {
//            !handler ?: handler(nil, msg);
//        } else {
//            InformationModel *tempModel = [InformationModel yy_modelWithDictionary:(NSDictionary *)object];
//            !handler ?: handler(tempModel, nil);
//        }
//    }];
//}

@end
