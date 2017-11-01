//
//  XJCollectOparetionRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/31.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface XJCollectOparetionRequest : BaseRequest
@property (assign, nonatomic) BOOL isCancel;
@property (copy, nonatomic) NSString *planId;
@end
