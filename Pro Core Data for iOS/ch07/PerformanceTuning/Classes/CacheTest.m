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

#import "CacheTest.h"
#import "Actor.h"

@implementation CacheTest

- (NSString *)name {
  return @"Cache Test";
}

- (void)loadDataFromContext :(NSManagedObjectContext *)context {
  // Fetch all the movies and all actors
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  [request release];
  
  // Fetch all the actors
  for(NSManagedObject *movie in results) {    
    NSSet *actors = [movie valueForKey:@"actors"];
    for(Actor *actor in actors) {
      [actor valueForKey:@"name"];
    }
  }  
}

// Pull all the movies and verify that each of their actor objects are pointing to the same actors
- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSMutableString *result = [NSMutableString string];
  
  [context reset];  // Clear all potentially cached objects
  
  NSDate *startTest1 = [NSDate date];  
  [self loadDataFromContext: context];
  NSDate *endTest1 = [NSDate date];
  
  NSTimeInterval test1 = [endTest1 timeIntervalSinceDate:startTest1];
  [result appendFormat:@"Without cache: %.2f s\n", test1];
  
  NSDate *startTest2 = [NSDate date];  
  [self loadDataFromContext: context];  
  NSDate *endTest2 = [NSDate date];
  
  NSTimeInterval test2 = [endTest2 timeIntervalSinceDate:startTest2];
  [result appendFormat:@"With cache: %.2f s\n", test2];
  
  return result;
}

@end
