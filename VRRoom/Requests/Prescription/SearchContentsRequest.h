//
//  SearchContentsRequest.h
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/18.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "BaseRequest.h"

@interface SearchContentsRequest : BaseRequest

@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *therapyId;
@property (copy, nonatomic) NSString *keyword;
@property (strong, nonatomic) NSNumber *paging;
@property (copy, nonatomic) NSString *sortName;
@property (copy, nonatomic) NSString *sortOrder;

@end
