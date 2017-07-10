//
//  XJFetchPatientsContentsRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/7/10.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface XJFetchPatientsContentsRequest : BaseRequest
@property (copy, nonatomic) NSString *userId;
@property (strong, nonatomic) NSNumber *paging;

@end
