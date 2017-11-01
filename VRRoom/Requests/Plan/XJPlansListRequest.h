//
//  XJPlansListRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/10/31.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface XJPlansListRequest : BaseRequest
@property (copy, nonatomic) NSString *diseaseId;
@property (strong, nonatomic) NSNumber *paging;

@end
