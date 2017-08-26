//
//  UploadImageRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "UploadImageRequest.h"

@implementation UploadImageRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.fileType forKey:@"fileType"];
    NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
    NSData *tempData = UIImageJPEGRepresentation(self.image, 1.0);
    if (tempData.length > 300 * 1024) {
        CGFloat rate = 300.0 * 1024.0 / tempData.length;
        tempData = UIImageJPEGRepresentation(self.image, rate);
    }
    [self.params setObject:tempName forKey:@"filename"];
    [[UploadImageManager sharedInstance] POST:@"imageUpload" parameters:self.params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:tempData name:@"fileData" fileName:tempName mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}


@end
