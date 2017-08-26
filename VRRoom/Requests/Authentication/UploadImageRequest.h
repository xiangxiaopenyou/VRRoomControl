//
//  UploadImageRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadImageRequest : BaseRequest
@property (strong, nonatomic) NSNumber *fileType;
@property (strong, nonatomic) UIImage *image;

@end
