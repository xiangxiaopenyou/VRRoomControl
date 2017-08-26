//
//  UploadImagesRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "UploadImagesRequest.h"

@implementation UploadImagesRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.type forKey:@"fileType"];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.imagesArray.count; i ++) {
        if ([self.imagesArray[i] isKindOfClass:[UIImage class]]) {
            UIImage *image = self.imagesArray[i];
            NSString *tempName = @(ceil([[NSDate date] timeIntervalSince1970])).stringValue;
            NSData *tempData = UIImageJPEGRepresentation(image, 1.0);
            if (tempData.length > 300 * 1024) {
                CGFloat rate = 300.0 * 1024.0 / tempData.length;
                tempData = UIImageJPEGRepresentation(image, rate);
            }
            [self.params setObject:tempName forKey:@"filename"];
            [[UploadImageManager sharedInstance] POST:@"imageUpload" parameters:self.params  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                [formData appendPartWithFileData:tempData name:@"fileData" fileName:tempName mimeType:@"image/jpeg"];
            } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    [resultArray addObject:responseObject[@"data"][@"imageUrl"]];
                    if (resultArray.count == self.imagesArray.count) {
                        !resultHandler ?: resultHandler(resultArray, nil);
                    }
                } else {
                    !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                !resultHandler ?: resultHandler(nil, XJNetworkError);
            }];
        } else {
            [resultArray addObject:self.imagesArray[i]];
            if (resultArray.count == self.imagesArray.count) {
                !resultHandler ?: resultHandler(resultArray, nil);
            }
        }
        
    }
}

@end
