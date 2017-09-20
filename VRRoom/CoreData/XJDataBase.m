//
//  XJDataBase.m
//  InHeart
//
//  Created by 项小盆友 on 2017/7/1.
//  Copyright © 2017年 项小盆友. All rights reserved.
//

#import "XJDataBase.h"
#import "Patient+CoreDataClass.h"
#import "PatientModel.h"

@implementation XJDataBase
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
+ (XJDataBase *)sharedDataBase {
    static XJDataBase *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[XJDataBase alloc] init];
    });
    return instance;
}
- (void)saveContent {
    NSError *error = nil;
    NSManagedObjectContext *context = self.managedObjectContext;
    if (!context) {
        if ([context hasChanges] && ![context save:&error]) {
            abort();
        }
    }
}
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}
- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel) {
        return _managedObjectModel;
    }
    NSURL *modelUrl = [[NSBundle mainBundle] URLForResource:@"Patients" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelUrl];
    return _managedObjectModel;
}
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator) {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"XJPatients.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)insertUser:(PatientModel *)user {
    NSManagedObjectContext *context = [self managedObjectContext];
    Patient *userInfo = [NSEntityDescription insertNewObjectForEntityForName:@"Patient" inManagedObjectContext:context];
    userInfo.id = user.id;
    userInfo.name = user.name;
    userInfo.remark = user.remark;
    userInfo.clinichistoryNo = user.clinichistoryNo;
    userInfo.birthday = user.birthday;
    userInfo.age = user.age.integerValue;
    userInfo.sex = user.sex.integerValue;
    userInfo.phone = user.phone;
    userInfo.maritalStatus = user.maritalStatus.integerValue;
    userInfo.educationDegree = user.educationDegree.integerValue;
    userInfo.medicalInsuranceCardNo = user.medicalInsuranceCardNo;
    userInfo.diseaseId = user.diseaseId;
    userInfo.disease = user.disease;
    userInfo.canModify = user.canModify.integerValue;
    userInfo.ts = user.ts;
    NSError *error = nil;
    if (context.hasChanges) {
        [context save:&error];
    }
    if (error) {
        //失败
    }
}
- (NSMutableArray *)selectUser:(NSString *)userId {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", userId];
    request.predicate = predicate;
    request.entity = entity;
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    for (Patient *user in fetchedObjects) {
        PatientModel *userInfo = [[PatientModel alloc] init];
        userInfo.id = user.id;
        userInfo.name = user.name;
        userInfo.remark = user.remark;
        userInfo.clinichistoryNo = user.clinichistoryNo;
        userInfo.birthday = user.birthday;
        userInfo.age = @(user.age);
        userInfo.sex = @(user.sex);
        userInfo.phone = user.phone;
        userInfo.maritalStatus = @(user.maritalStatus);
        userInfo.educationDegree = @(user.educationDegree);
        userInfo.medicalInsuranceCardNo = user.medicalInsuranceCardNo;
        userInfo.diseaseId = user.diseaseId;
        userInfo.disease = user.disease;
        userInfo.canModify = @(user.canModify);
        userInfo.ts = user.ts;
        [resultArray addObject:userInfo];
    }
    return resultArray;
}
- (void)updatePatientData:(PatientModel *)user {
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Patient" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"id = %@", user.id];
    request.predicate = predicate;
    request.entity = entity;
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:request error:&error];
    for (Patient *userInfo in fetchedObjects) {
        userInfo.id = user.id;
        userInfo.name = user.name;
        userInfo.remark = user.remark;
        userInfo.clinichistoryNo = user.clinichistoryNo;
        userInfo.birthday = user.birthday;
        userInfo.age = user.age.integerValue;
        userInfo.sex = user.sex.integerValue;
        userInfo.phone = user.phone;
        userInfo.maritalStatus = user.maritalStatus.integerValue;
        userInfo.educationDegree = user.educationDegree.integerValue;
        userInfo.medicalInsuranceCardNo = user.medicalInsuranceCardNo;
        userInfo.diseaseId = user.diseaseId;
        userInfo.disease = user.disease;
        userInfo.canModify = user.canModify.integerValue;
        userInfo.ts = user.ts;
    }
    if ([context save:&error]) {
        //更新成功
        NSLog(@"更新成功");
    }
}

@end
