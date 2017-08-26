//
//  UploadImagesRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface UploadImagesRequest : BaseRequest
@property (copy, nonatomic) NSArray *imagesArray;
@property (strong, nonatomic) NSNumber *type;

@end
