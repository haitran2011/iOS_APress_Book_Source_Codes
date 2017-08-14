//
// From the book Pro Core Data for iOS
// Michael Privat and Rob Warner
// Published by Apress, 2011
// Source released under the Eclipse Public License
// http://www.eclipse.org/legal/epl-v10.html
// 
// Contact information:
// Michael: @michaelprivat -- http://michaelprivat.com -- mprivat@mac.com
// Rob: @hoop33 -- http://grailbox.com -- rwarner@grailbox.com
//

#import "CustomStore.h"

@interface CustomStore (private)

+ (void)writeMetadata:(NSDictionary*)metadata toURL:(NSURL*)url;
+ (NSString *)makeUUID;
- (NSAtomicStoreCacheNode*)nodeForReferenceObject:(id)reference andObjectID:(NSManagedObjectID*)oid;
@end

@implementation CustomStore

+ (NSString *)makeUUID {    
  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
  CFRelease(uuidRef);
  NSString* uuid = [NSString stringWithString:(NSString *)uuidStringRef];
  CFRelease(uuidStringRef);
  return uuid;
}

+ (void)writeMetadata:(NSDictionary*)metadata toURL:(NSURL*)url {
  NSString *path = [[url relativePath] stringByAppendingString:@".plist"];
  [metadata writeToFile:path atomically:YES];
}

#pragma mark -
#pragma mark NSPersistentStore

- (NSString *)type {
  return [[self metadata] objectForKey:NSStoreTypeKey];
}

- (NSString *)identifier {
  return [[self metadata] objectForKey:NSStoreUUIDKey];
}

- (id)initWithPersistentStoreCoordinator:(NSPersistentStoreCoordinator *)coordinator configurationName:(NSString *)configurationName URL:(NSURL *)url options:(NSDictionary *)options {
  self = [super initWithPersistentStoreCoordinator:coordinator configurationName:configurationName URL:url options:options];
  NSDictionary *metadata = [CustomStore metadataForPersistentStoreWithURL:[self URL] error:nil];
  [self setMetadata:metadata];
  nodeCacheRef = [[NSMutableDictionary dictionary] retain];
  return self;
}

#pragma mark -
#pragma mark NSAtomicStore

+ (NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError **)error {
  NSString *path = [[url relativePath] stringByAppendingString:@".plist"];
  
  if(! [[NSFileManager defaultManager] fileExistsAtPath:path]) {
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    [metadata setValue:@"CustomStore" forKey:NSStoreTypeKey];
    [metadata setValue:[CustomStore makeUUID] forKey:NSStoreUUIDKey];
    [CustomStore writeMetadata:metadata toURL:url];
    [@"" writeToURL:url atomically:YES encoding:[NSString defaultCStringEncoding] error:nil];
    
    NSLog(@"Created new store at %@", path);    
  }
  
  return [NSDictionary dictionaryWithContentsOfFile:path];
}

- (id)newReferenceObjectForManagedObject:(NSManagedObject *)managedObject {
  NSString *uuid = [CustomStore makeUUID];
  [uuid retain];
  return uuid;
}

- (NSAtomicStoreCacheNode *)newCacheNodeForManagedObject:(NSManagedObject *)managedObject {
  NSManagedObjectID *oid = [managedObject objectID];  
  id referenceID = [self referenceObjectForObjectID:oid];  
  
  NSAtomicStoreCacheNode* node = [self nodeForReferenceObject:referenceID andObjectID:oid];
  [self updateCacheNode:node fromManagedObject:managedObject];
  return node;
}

- (void)updateCacheNode:(NSAtomicStoreCacheNode *)node fromManagedObject:(NSManagedObject *)managedObject {
  NSEntityDescription *entity = managedObject.entity;
  
  NSDictionary *attributes = [entity attributesByName];
  for(NSString *name in [attributes allKeys]) {
    [node setValue:[managedObject valueForKey:name] forKey:name];
  }
  
  NSDictionary *relationships = [entity relationshipsByName];
  for(NSString *name in [relationships allKeys]) {
    id value = [managedObject valueForKey:name];
    if([[relationships objectForKey:name] isToMany]) {
      NSSet *set = (NSSet*)value;
      NSMutableSet *data = [NSMutableSet set];
      for(NSManagedObject *managedObject in set) {
        NSManagedObjectID *oid = [managedObject objectID];  
        id referenceID = [self referenceObjectForObjectID:oid];              
        NSAtomicStoreCacheNode* n = [self nodeForReferenceObject:referenceID andObjectID:oid];
        [data addObject:n];
      }
      [node setValue:data forKey:name];            
    }
    else {
      NSManagedObject *managedObject = (NSManagedObject*)value;
      NSManagedObjectID *oid = [managedObject objectID];  
      id referenceID = [self referenceObjectForObjectID:oid];              
      NSAtomicStoreCacheNode* n = [self nodeForReferenceObject:referenceID andObjectID:oid];            
      [node setValue:n forKey:name];
    }
  }
}

- (NSAtomicStoreCacheNode *)nodeForReferenceObject:(id)reference andObjectID:(NSManagedObjectID *)oid {
  NSAtomicStoreCacheNode *node = [nodeCacheRef objectForKey:reference];
  if(node == nil) {
    node = [[[NSAtomicStoreCacheNode alloc] initWithObjectID:oid] autorelease];    
    [nodeCacheRef setObject:node forKey:reference];
  }
  return node;
}

- (BOOL)save:(NSError **)error {
  NSURL *url = [self URL];
  
  // First update the metadata
  [CustomStore writeMetadata:[self metadata] toURL:url];
  
  NSString* dataFile = @"";
  // Then write the actual data
  NSSet *nodes = [self cacheNodes];
  NSAtomicStoreCacheNode *node;
  NSEnumerator *enumerator = [nodes objectEnumerator];
  while((node = [enumerator nextObject]) != nil) {
    NSManagedObjectID *oid = [node objectID];
    id referenceID = [self referenceObjectForObjectID:oid];
    
    NSEntityDescription *entity = [oid entity];
    dataFile = [dataFile stringByAppendingFormat:@"%@|%@", entity.name, referenceID];
    
    {   // Attributes
      NSDictionary *attributes = [entity attributesByName];
      NSAttributeDescription *key = nil;
      NSEnumerator *enumerator = [attributes objectEnumerator];
      while((key = [enumerator nextObject]) != nil) {
        NSString *value = [node valueForKey:key.name];
        if(value == nil) value = @"(null)";
        dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, value];      
      }
    }
    
    {   // Relationships
      NSDictionary *relationships = [entity relationshipsByName];
      NSRelationshipDescription *key = nil;
      NSEnumerator *enumerator = [relationships objectEnumerator];
      while((key = [enumerator nextObject]) != nil) {
        id value = [node valueForKey:key.name];
        if(value == nil) {
          dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, @"(null)"];
        }
        else if(![key isToMany]) {  // One-to-One
          NSManagedObjectID *oid = [(NSAtomicStoreCacheNode*)value objectID];
          id referenceID = [self referenceObjectForObjectID:oid];
          dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, referenceID];
        }
        else {  // One-to-Many
          NSSet* set = (NSSet*)value;
          if([set count] == 0) {
            dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, @"(null)"];
          }
          else {
            NSString *list = @"";
            for(NSAtomicStoreCacheNode *item in set) {
              id referenceID = [self referenceObjectForObjectID:[item objectID]];
              list = [list stringByAppendingFormat:@"%@,", referenceID];
            }
            list = [list substringToIndex:[list length]-1];
            dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, list];
          }
        }
      }
    }
    dataFile = [dataFile stringByAppendingString:@"\n"];
  }
  NSString *path = [url relativePath];
  [dataFile writeToFile:path atomically:YES encoding:[NSString defaultCStringEncoding] error:error];
  return YES;
}

- (BOOL)load:(NSError **)error {
  NSURL* url = [self URL];  
  NSMutableSet *nodes = [NSMutableSet set];
  NSString *path = [url relativePath];
  if(! [[NSFileManager defaultManager] fileExistsAtPath:path]) {
    [self addCacheNodes:nodes];
    return YES;
  }  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  NSString *fileString = [NSString stringWithContentsOfFile:path encoding:[NSString defaultCStringEncoding] error:error];
  NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
  NSString *line;
  NSEnumerator *enumerator = [lines objectEnumerator];
  while( (line = [enumerator nextObject]) != nil) {
    NSArray *components = [line componentsSeparatedByString:@"|"];
    if([components count] < 2) continue;
    NSString *entityName = [components objectAtIndex:0];
    NSString *pkey = [components objectAtIndex:1];
    
    // Make the node
    NSEntityDescription *entity = [[[coordinator managedObjectModel] entitiesByName] valueForKeyPath:entityName];
    if (entity != nil) {
      NSManagedObjectID *oid = [self objectIDForEntity:entity referenceObject:pkey];
      NSAtomicStoreCacheNode *node = [self nodeForReferenceObject:pkey andObjectID:oid];
      NSDictionary *attributes = [entity attributesByName];
      NSDictionary *relationships = [entity relationshipsByName];
      
      for(int i=2; i<[components count]; i++) {
        NSArray *entry = [[components objectAtIndex:i] componentsSeparatedByString:@"="];
        NSString *key = [entry objectAtIndex:0];
        if([attributes objectForKey:key] != nil) {
          NSAttributeDescription *attributeDescription = [attributes objectForKey:key];
          NSAttributeType type = [attributeDescription attributeType];
          
          // Default value to type string
          id dataValue = [entry objectAtIndex:1];
          if([(NSString*)dataValue compare:@"(null)"] == NSOrderedSame) {
            continue; 
          }
          
          if ((type == NSInteger16AttributeType) || (type == NSInteger32AttributeType) || (type == NSInteger64AttributeType)) {
            dataValue = [NSNumber numberWithInteger:[dataValue integerValue]];
          }
          else if (type == NSDecimalAttributeType) {
            dataValue = [NSDecimalNumber decimalNumberWithString:dataValue];
          }
          else if (type == NSDoubleAttributeType) {
            dataValue = [NSNumber numberWithDouble:[dataValue doubleValue]];
          }
          else if (type == NSFloatAttributeType) {
            dataValue = [NSNumber numberWithFloat:[dataValue floatValue]];
          }
          else if (type == NSBooleanAttributeType) {
            dataValue = [NSNumber numberWithBool:[dataValue intValue]];
          }
          else if (type == NSDateAttributeType) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
            dataValue = [formatter dateFromString:dataValue];
            [formatter release];            
          }
          else if (type == NSBinaryDataAttributeType) {
            NSLog(@"Binary type not supported");
          }
          [node setValue:dataValue forKey:key];
        }
        else if([relationships objectForKey:key] != nil) {  // See if it's a relationship
          NSArray *ids = [[entry objectAtIndex:1] componentsSeparatedByString:@","];
          NSRelationshipDescription *relationship = [relationships objectForKey:key];
          if([relationship isToMany]) {
            NSMutableSet* set = [NSMutableSet set];
            for(NSString *fKey in ids) {
              if(fKey != nil && [fKey compare:@"(null)"] != NSOrderedSame) {
                NSManagedObjectID *oid = [self objectIDForEntity:[relationship destinationEntity] referenceObject:fKey];
                NSAtomicStoreCacheNode *destinationNode = [self nodeForReferenceObject:fKey andObjectID:oid];
                [set addObject:destinationNode];
              }                            
            }
            [node setValue:set forKey:key];
          }
          else {
            NSString* fKey = [ids count] > 0 ? [ids objectAtIndex:0] : nil;
            if(fKey != nil && [fKey compare:@"(null)"] != NSOrderedSame) {
              NSManagedObjectID *oid = [self objectIDForEntity:[relationship destinationEntity] referenceObject:fKey];
              NSAtomicStoreCacheNode *destinationNode = [self nodeForReferenceObject:fKey andObjectID:oid];
              [node setValue:destinationNode forKey:key];
            }
          }
        }
      }
      // Remember this node
      [nodes addObject:node];
    }        
  }
  // Register all the nodes
  [self addCacheNodes:nodes];
  return YES;
}

@end

