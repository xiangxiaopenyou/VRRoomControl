//
//  UploadImageManager.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 16/10/11.
//  Copyright © 2016年 项小盆友. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface UploadImageManager : AFHTTPSessionManager
+ (instancetype)sharedInstance;

@end
