//
//  UploadImageManager.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "UploadImageManager.h"

@implementation UploadImageManager
+ (instancetype)sharedInstance {
    static UploadImageManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UploadImageManager alloc] initWithBaseURL:[NSURL URLWithString:BASEAPIURL]];
        AFJSONRequestSerializer *requestSerializer = [AFJSONRequestSerializer serializer];
        [requestSerializer setHTTPShouldHandleCookies:YES];
        AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
        NSMutableSet *types = [[serializer acceptableContentTypes] mutableCopy];
        [types addObjectsFromArray:@[@"text/plain", @"text/html"]];
        serializer.acceptableContentTypes = types;
        instance.requestSerializer = requestSerializer;
        instance.responseSerializer = serializer;
        [NSURLSessionConfiguration defaultSessionConfiguration].HTTPMaximumConnectionsPerHost = 1;
    });
    return instance;
}

@end
