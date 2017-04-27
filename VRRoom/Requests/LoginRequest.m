//
//  LoginRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/9/27.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import "LoginRequest.h"
#import "sys/utsname.h"

#define XLAppVersion [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"]
#define XLSystemVersion [UIDevice currentDevice].systemVersion
#define XLIDFVString [[[UIDevice currentDevice] identifierForVendor] UUIDString]

@implementation LoginRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    NSMutableDictionary *param = [@{@"username" : self.username,
                                    @"password" : self.password,
                                    @"deviceModel" : [self mobileModel],
                                    @"appVersion" : XLAppVersion,
                                    @"deviceSystem" : @"iOS",
                                    @"deviceVersion" : XLSystemVersion,
                                    @"appId" : XLIDFVString,
                                    @"channel" : @"AppStore"} mutableCopy];
    [[RequestManager sharedInstance] POST:@"appControlVrRoom/login" parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject[@"data"], nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, error.description);
    }];
}
- (NSString *)mobileModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    return deviceString;
}
@end
