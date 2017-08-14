//
//  NSPersistentStoreCoordinator+ActiveRecord.m
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import "NSPersistentStoreCoordinator+ActiveRecord.h"
#import "NSManagedObjectModel+ActiveRecord.h"
#import "NSPersistentStore+ActiveRecord.h"

static NSPersistentStoreCoordinator *defaultCoordinator = nil;

@implementation NSPersistentStoreCoordinator (ActiveRecord)

+ (NSPersistentStoreCoordinator *) defaultStoreCoordinator
{
	if (defaultCoordinator == nil)
	{
		defaultCoordinator = [self newPersistentStoreCoordinator];
	}
	return defaultCoordinator;
}

+ (void) setDefaultStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator
{
	[defaultCoordinator release];
	defaultCoordinator = [coordinator retain];
}

+ (NSPersistentStoreCoordinator *) newCoordinatorWithSqliteStoreNamed:(NSString *)storeFileName
{
	NSError *error = nil;
	NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	NSString *fileWithPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:storeFileName];
	NSURL *storeUrl = [NSURL fileURLWithPath:fileWithPath];
	
	NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType 
												 configuration:nil
														   URL:storeUrl 
													   options:nil
														 error:&error];
    if (!store)
	{
		[ActiveRecordHelpers handleErrors:error];
    }    
	return psc;
}

+ (NSPersistentStoreCoordinator *) newCoordinatorWithInMemoryStore
{
	NSError *error = nil;
	NSManagedObjectModel *model = [NSManagedObjectModel defaultManagedObjectModel];
	NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
	
	NSPersistentStore *store = [psc addPersistentStoreWithType:NSInMemoryStoreType 
												 configuration:nil
														   URL:nil
													   options:nil
														 error:&error];
	if (!store)
	{
		[ActiveRecordHelpers handleErrors:error];
	}
	return psc;
}

+ (NSPersistentStoreCoordinator *) coordinatorWithInMemoryStore
{
	return [[self newCoordinatorWithInMemoryStore] autorelease];
}

+ (NSPersistentStoreCoordinator *)newPersistentStoreCoordinator
{
	return [[self newCoordinatorWithSqliteStoreNamed:kActiveRecordDefaultStoreFileName] retain];
}

@end
