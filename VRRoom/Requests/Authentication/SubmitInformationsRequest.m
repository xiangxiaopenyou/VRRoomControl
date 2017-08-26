//
//  SubmitInformationsRequest.m
//  InHeart-Doctors
//
//  Created by 项小盆友 on 2017/4/6.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "SubmitInformationsRequest.h"
#import "InformationModel.h"

@implementation SubmitInformationsRequest
- (void)request:(ParamsBlock)paramsBlock result:(RequestResultHandler)resultHandler {
    if (!paramsBlock(self)) {
        return;
    }
    [self.params setObject:self.model.realname forKey:@"realname"];
    [self.params setObject:self.model.gender forKey:@"gender"];
    [self.params setObject:self.model.region forKey:@"region"];
    [self.params setObject:self.model.professionalTitleId forKey:@"professionalTitleId"];
    [self.params setObject:self.model.workplaceType forKey:@"workplaceType"];
    [self.params setObject:self.model.hospital forKey:@"hospital"];
    if ([self.model.workplaceType integerValue] == 1) {
        [self.params setObject:self.model.department forKey:@"department"];
    } else {
        [self.params setObject:self.model.position forKey:@"position"];
    }
    [self.params setObject:self.model.headPictureUrl forKey:@"headPictureUrl"];
    if (self.model.introduction) {
        [self.params setObject:self.model.introduction forKey:@"introduction"];
    }
    if (self.model.expertise) {
        [self.params setObject:self.model.expertise forKey:@"expertise"];
    }
    if ([self.model.professionalTitleId integerValue] == 5 || [self.model.professionalTitleId integerValue] == 6) {
        [self.params setObject:self.model.psychologicalConsultantImageUrl forKey:@"psychologicalConsultantImageUrl"];
        [self.params setObject:self.model.employeeImageUrl forKey:@"employeeImageUrl"];
    } else {
        [self.params setObject:self.model.doctorProfessionImageUrl forKey:@"doctorProfessionImageUrl"];
        [self.params setObject:self.model.professionalQualificationImageUrl forKey:@"professionalQualificationImageUrl"];
    }
    [[RequestManager sharedInstance] POST:@"auth" parameters:self.params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([responseObject[@"success"] boolValue]) {
            !resultHandler ?: resultHandler(responseObject, nil);
        } else {
            !resultHandler ?: resultHandler(nil, responseObject[@"message"]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !resultHandler ?: resultHandler(nil, XJNetworkError);
    }];
}

@end
