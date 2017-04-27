//
//  ManagerModel.m
//  VRRoom
//
//  Created by 项小盆友 on 2017/4/17.
//  Copyright © 2017年 InHeart. All rights reserved.
//

#import "ManagerModel.h"
#import "FetchDevicesRequest.h"
#import "AddTaskRequest.h"

@implementation ManagerModel
+ (void)fetchManagers:(NSString *)roomId handler:(RequestResultHandler)handler {
    [[FetchDevicesRequest new] request:^BOOL(FetchDevicesRequest *request) {
        request.vrRoomId = roomId;
        return YES;
    } result:^(id object, NSString *msg) {
        if (msg) {
            !handler ?: handler(nil, msg);
        } else {
            NSArray *tempArray = [ManagerModel setupWithArray:object];
            !handler ?: handler(tempArray, nil);
        }
    }];
}
+ (void)addTask:(NSString *)contentId prescriptionContent:(NSString *)prescriptionContentId type:(NSNumber *)type userId:(NSString *)userId handler:(RequestResultHandler)handler {
    [[AddTaskRequest new] request:^BOOL(AddTaskRequest *request) {
        request.content = contentId;
        request.prescriptionContentId = prescriptionContentId;
        request.type = type;
        request.userId = userId;
        return YES;
    } result:handler];
}

@end
