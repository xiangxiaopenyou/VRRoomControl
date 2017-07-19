//
//  AddTaskRequest.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/17.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "BaseRequest.h"

@interface AddTaskRequest : BaseRequest
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *prescriptionContentId;
@property (strong, nonatomic) NSNumber *type;
@property (copy, nonatomic) NSString *userId;

@end
