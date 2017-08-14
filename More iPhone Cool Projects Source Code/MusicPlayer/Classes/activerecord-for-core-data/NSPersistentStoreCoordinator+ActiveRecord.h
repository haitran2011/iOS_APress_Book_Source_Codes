//
//  NSPersistentStoreCoordinator+ActiveRecord.h
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import "ActiveRecordHelpers.h"


@interface NSPersistentStoreCoordinator (ActiveRecord)

+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator;
+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator;

+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator;

+ (NSPersistentStoreCoordinator *) newCoordinatorWithInMemoryStore;
+ (NSPersistentStoreCoordinator *) newCoordinatorWithSqliteStoreNamed:(NSString *)storeFileName;

@end
