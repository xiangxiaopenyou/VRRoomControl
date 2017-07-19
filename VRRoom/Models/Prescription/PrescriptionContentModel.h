//
//  PrescriptionContentModel.h
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/14.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "XLModel.h"

@interface PrescriptionContentModel : XLModel
@property (strong, nonatomic) NSNumber *unitPrice;
@property (copy, nonatomic) NSString *content_name;
@property (copy, nonatomic) NSString *id;
@property (copy, nonatomic) NSString *contentId;
@property (copy, nonatomic) NSString *prescriptionId;
@property (strong, nonatomic) NSNumber *content_type;
@property (strong, nonatomic) NSNumber *times;
@property (strong, nonatomic) NSNumber *useTimes;
@property (copy, nonatomic) NSString *createdAt;
@property (copy, nonatomic) NSString *updatedAt;
@property (copy, nonatomic) NSString *lastUseAt;
@property (strong, nonatomic) NSNumber *frequency;
@property (strong, nonatomic) NSNumber *period;
@property (strong, nonatomic) NSNumber *periodUnit;
@property (copy, nonatomic) NSString *content_coverPic;

+ (void)fetchContents:(NSString *)prescriptionId handler:(RequestResultHandler)handler;
+ (void)fetchUsersContents:(NSString *)userId paging:(NSNumber *)paging handler:(RequestResultHandler)handler;

@end
