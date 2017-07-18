//
//  XJDataBase.h
//  InHeart
//
//  Created by 项小盆友 on 2017/7/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PatientModel;

@interface XJDataBase : NSObject
@property (strong, readonly, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, readonly, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, readonly, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (XJDataBase *)sharedDataBase;
- (void)saveContent;
- (NSURL *)applicationDocumentsDirectory;

//插入数据
- (void)insertUser:(PatientModel *)user;
//查询
- (NSMutableArray *)selectUser:(NSString *)userId;
//修改
- (void)updatePatientData:(PatientModel *)user;

@end
