//
//  ActiveRecordHelpers.h
//  DocBook
//
//  Created by Saul Mora on 3/11/10.
//  Copyright 2010 Willow Tree Mobile, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define kActiveRecordDefaultStoreFileName @"CoreDataStore.sqlite"
#define kActiveRecordDefaultBatchSize 6

@interface ActiveRecordHelpers : NSObject {

}

+ (void) handleErrors:(NSError *)error;
- (void) handleErrors:(NSError *)error;

+ (void) setupDefaultCoreDataStack;
+ (void) setupDefaultCoreDataStackWithStoreNamed:(NSString *)storeName;
+ (void) setupCoreDataStackWithInMemoryStore;

+ (void) cleanUp;

@end
