//
// From the book Pro Core Data for iOS, 2nd Edition
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

#pragma mark - Utility methods

+ (NSString *)makeUUID {    
  CFUUIDRef uuidRef = CFUUIDCreate(NULL);
  CFStringRef uuidStringRef = CFUUIDCreateString(NULL, uuidRef);
  CFRelease(uuidRef);
  NSString* uuid = [NSString stringWithString:(__bridge NSString *)uuidStringRef];
  CFRelease(uuidStringRef);
  return uuid;
}

+ (void)writeMetadata:(NSDictionary*)metadata toURL:(NSURL*)url {
  NSString *path = [[url relativePath] stringByAppendingString:@".plist"];
  [metadata writeToFile:path atomically:YES];
}

- (NSAtomicStoreCacheNode *)nodeForReferenceObject:(id)reference andObjectID:(NSManagedObjectID *)oid {
  NSAtomicStoreCacheNode *node = [nodeCacheRef objectForKey:reference];
  if (node == nil) {
    node = [[NSAtomicStoreCacheNode alloc] initWithObjectID:oid];    
    [nodeCacheRef setObject:node forKey:reference];
  }
  return node;
}

#pragma mark - NSPersistentStore

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
  nodeCacheRef = [NSMutableDictionary dictionary];
  return self;
}

+ (NSDictionary *)metadataForPersistentStoreWithURL:(NSURL *)url error:(NSError **)error {
  // Determine the filename for the metadata file
  NSString *path = [[url relativePath] stringByAppendingString:@".plist"];
  
  // If the metadata file doesn't exist, create it
  if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    // Create a dictionary and store the store type key (CustomStore)
    // and the UUID key
    NSMutableDictionary *metadata = [NSMutableDictionary dictionary];
    [metadata setValue:@"CustomStore" forKey:NSStoreTypeKey];
    [metadata setValue:[CustomStore makeUUID] forKey:NSStoreUUIDKey];
    
    // Write the metadata to the .plist file 
    [CustomStore writeMetadata:metadata toURL:url];
    
    // Write an empty data file
    [@"" writeToURL:url atomically:YES encoding:[NSString defaultCStringEncoding] error:nil];
    
    NSLog(@"Created new store at %@", path);    
  }
  return [NSDictionary dictionaryWithContentsOfFile:path];
}

#pragma mark - NSAtomicStore

- (BOOL)load:(NSError **)error {
  // Find the file to load from
  NSURL* url = [self URL];  
  NSMutableSet *nodes = [NSMutableSet set];
  NSString *path = [url relativePath];
  if(![[NSFileManager defaultManager] fileExistsAtPath:path]) {
    // File doesn't exist, so add an empty set and bail
    [self addCacheNodes:nodes];
    return YES;
  }
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  
  // Load the entire file into an array, with each element
  // containing one line from the file. Each element is then one
  // node
  NSString *fileString = [NSString stringWithContentsOfFile:path encoding:[NSString defaultCStringEncoding] error:error];
  NSArray *lines = [fileString componentsSeparatedByString:@"\n"];
  NSString *line;
  
  // Enumerate through each line from the file
  NSEnumerator *enumerator = [lines objectEnumerator];
  while ((line = [enumerator nextObject]) != nil) {
    // Split the fields into an array
    NSArray *components = [line componentsSeparatedByString:@"|"];
    
    // If we don't have at least an entity name and a reference ID,
    // ignore this line
    if ([components count] < 2) continue;
    NSString *entityName = [components objectAtIndex:0];
    NSString *pkey = [components objectAtIndex:1];
    
    // Make the node
    NSEntityDescription *entity = [[[coordinator managedObjectModel] entitiesByName] valueForKeyPath:entityName];
    if (entity != nil) {
      NSManagedObjectID *oid = [self objectIDForEntity:entity referenceObject:pkey];
      NSAtomicStoreCacheNode *node = [self nodeForReferenceObject:pkey andObjectID:oid];
      
      // Get the attributes and relationships from the model
      NSDictionary *attributes = [entity attributesByName];
      NSDictionary *relationships = [entity relationshipsByName];
      
      // Go through the rest of the fields
      for (int i = 2; i < [components count]; i++) {
        // Each field is a name/value pair, separated by an equals
        // sign. Parse name and value
        NSArray *entry = [[components objectAtIndex:i] componentsSeparatedByString:@"="];
        NSString *key = [entry objectAtIndex:0];
        if([attributes objectForKey:key] != nil) {
          // Get the type of the attribute from the model
          NSAttributeDescription *attributeDescription = [attributes objectForKey:key];
          NSAttributeType type = [attributeDescription attributeType];
          
          // Default value to type string
          id dataValue = [entry objectAtIndex:1];
          if ([(NSString*)dataValue compare:@"(null)"] == NSOrderedSame) {
            continue; 
          }
          // Convert the value to the proper data type
          if ((type == NSInteger16AttributeType) || (type == NSInteger32AttributeType) || (type == NSInteger64AttributeType)) {
            dataValue = [NSNumber numberWithInteger:[dataValue integerValue]];
          } else if (type == NSDecimalAttributeType) {
            dataValue = [NSDecimalNumber decimalNumberWithString:dataValue];
          } else if (type == NSDoubleAttributeType) {
            dataValue = [NSNumber numberWithDouble:[dataValue doubleValue]];
          } else if (type == NSFloatAttributeType) {
            dataValue = [NSNumber numberWithFloat:[dataValue floatValue]];
          } else if (type == NSBooleanAttributeType) {
            dataValue = [NSNumber numberWithBool:[dataValue intValue]];
          } else if (type == NSDateAttributeType) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZ"];
            dataValue = [formatter dateFromString:dataValue];
          } else if (type == NSBinaryDataAttributeType) {
            // This implementation doesn't support binary data
            // You could enhance this code to base64 encode and
            // decode binary data to be able to support binary
            // types.
            NSLog(@"Binary type not supported");
          }
          // Set the converted value into the node
          [node setValue:dataValue forKey:key];
        } else if ([relationships objectForKey:key] != nil) {  // See if it's a relationship
          // Destination objects are comma-separated
          NSArray *ids = [[entry objectAtIndex:1] componentsSeparatedByString:@","];
          NSRelationshipDescription *relationship = [relationships objectForKey:key];
          // If it's a to-many relationship . . .
          if ([relationship isToMany]) {
            // . . . get the set of destination objects and
            // iterate through them
            NSMutableSet* set = [NSMutableSet set];
            for (NSString *fKey in ids) {
              if (fKey != nil && [fKey compare:@"(null)"] != NSOrderedSame) {
                // Create the node for the destination object
                NSManagedObjectID *oid = [self objectIDForEntity:[relationship destinationEntity] referenceObject:fKey];
                NSAtomicStoreCacheNode *destinationNode = [self nodeForReferenceObject:fKey andObjectID:oid];
                [set addObject:destinationNode];
              }                            
            }
            // Store the set into the node
            [node setValue:set forKey:key];
          } else {
            // This is a to-one relationship; check whether there's
            // a destination object
            NSString* fKey = [ids count] > 0 ? [ids objectAtIndex:0] : nil;
            if (fKey != nil && [fKey compare:@"(null)"] != NSOrderedSame) {
              // Set the destination into the node
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

- (id)newReferenceObjectForManagedObject:(NSManagedObject *)managedObject {
  NSString *uuid = [CustomStore makeUUID];
  return uuid;
}

- (NSAtomicStoreCacheNode *)newCacheNodeForManagedObject:(NSManagedObject *)managedObject {
  NSManagedObjectID *oid = [managedObject objectID];  
  id referenceID = [self referenceObjectForObjectID:oid];  
  
  NSAtomicStoreCacheNode* node = [self nodeForReferenceObject:referenceID andObjectID:oid];
  [self updateCacheNode:node fromManagedObject:managedObject];
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
  
  // Enumerate through all the nodes
  while ((node = [enumerator nextObject]) != nil) {
    // Get the object ID and reference ID for each node
    NSManagedObjectID *oid = [node objectID];
    id referenceID = [self referenceObjectForObjectID:oid];
    
    // Write the entity name and reference ID as the first two 
    // values in the row
    NSEntityDescription *entity = [oid entity];
    dataFile = [dataFile stringByAppendingFormat:@"%@|%@", entity.name, referenceID];
    
    {   // Write all the attributes
      NSDictionary *attributes = [entity attributesByName];
      NSAttributeDescription *key = nil;
      NSEnumerator *enumerator = [attributes objectEnumerator];
      while ((key = [enumerator nextObject]) != nil) {
        NSString *value = [node valueForKey:key.name];
        if (value == nil) value = @"(null)";
        dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, value];      
      }
    }
    
    {   // Write all the relationships
      NSDictionary *relationships = [entity relationshipsByName];
      NSRelationshipDescription *key = nil;
      NSEnumerator *enumerator = [relationships objectEnumerator];
      while ((key = [enumerator nextObject]) != nil) {
        id value = [node valueForKey:key.name];
        if (value == nil) {
          dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, @"(null)"];
        } else if (![key isToMany]) {  // One-to-One
          NSManagedObjectID *oid = [(NSAtomicStoreCacheNode*)value objectID];
          id referenceID = [self referenceObjectForObjectID:oid];
          dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, referenceID];
        } else {  // One-to-Many
          NSSet* set = (NSSet*)value;
          if ([set count] == 0) {
            dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, @"(null)"];
          } else {
            NSString *list = @"";
            for (NSAtomicStoreCacheNode *item in set) {
              id referenceID = [self referenceObjectForObjectID:[item objectID]];
              list = [list stringByAppendingFormat:@"%@,", referenceID];
            }
            list = [list substringToIndex:[list length]-1];
            dataFile = [dataFile stringByAppendingFormat:@"|%@=%@", key.name, list];
          }
        }
      }
    }
    // Add a new line to go to the next row for the next node
    dataFile = [dataFile stringByAppendingString:@"\n"];
  }
  // Write the file
  NSString *path = [url relativePath];
  [dataFile writeToFile:path atomically:YES encoding:[NSString defaultCStringEncoding] error:error];   
  return YES;
}

- (void)updateCacheNode:(NSAtomicStoreCacheNode *)node fromManagedObject:(NSManagedObject *)managedObject {
  // Determine the entity for the managed object
  NSEntityDescription *entity = managedObject.entity;
  
  // Walk through all the attributes in the entity
  NSDictionary *attributes = [entity attributesByName];
  for (NSString *name in [attributes allKeys]) {
    // For each attribute, set the managed object's value into the node
    [node setValue:[managedObject valueForKey:name] forKey:name];
  }
  
  // Walk through all the relationships in the entity
  NSDictionary *relationships = [entity relationshipsByName];
  for (NSString *name in [relationships allKeys]) {
    id value = [managedObject valueForKey:name];
    // If this is a to-many relationship . . .
    if ([[relationships objectForKey:name] isToMany]) {
      // . . . get all the destination objects
      NSSet *set = (NSSet*)value;
      NSMutableSet *data = [NSMutableSet set];
      for (NSManagedObject *managedObject in set) {
        // For each destination object in the relationship,
        // add the cache node to the set
        NSManagedObjectID *oid = [managedObject objectID];  
        id referenceID = [self referenceObjectForObjectID:oid];              
        NSAtomicStoreCacheNode* n = [self nodeForReferenceObject:referenceID andObjectID:oid];
        [data addObject:n];
      }
      [node setValue:data forKey:name];            
    } else {
      // This is a to-one relationship, so just get the single
      // destination node for the relationship
      NSManagedObject *managedObject = (NSManagedObject*)value;
      NSManagedObjectID *oid = [managedObject objectID];  
      id referenceID = [self referenceObjectForObjectID:oid];              
      NSAtomicStoreCacheNode* n = [self nodeForReferenceObject:referenceID andObjectID:oid];            
      [node setValue:n forKey:name];
    }
  }
}

@end
