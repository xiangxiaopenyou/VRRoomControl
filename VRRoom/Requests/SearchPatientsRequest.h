//
//  SearchPatientsRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchPatientsRequest : BaseRequest
@property (copy, nonatomic) NSString *keyword;

@end
