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

#import <CoreData/CoreData.h>
#import "SinglyFiringFaultTest.h"

@implementation SinglyFiringFaultTest

- (NSString *)name {
  return @"Singly Firing Fault Test";
}

- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSString *result = @"Singly Firing Fault Test Complete!";
  
  // Fetch all the movies
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  [request release];
  
  // Loop through all the movies
  for (NSManagedObject *movie in results) {
    // Fire a fault just for this movie
    [movie valueForKey:@"name"];
    
    // Loop through all the actors for this movie
    for (NSManagedObject *actor in [movie valueForKey:@"actors"]) {
      // Fire a fault just for this actor
      [actor valueForKey:@"name"];
      
      // Put this actor back in fault so the next movie
      // will have to fire a fault
      // [context refreshObject:actor mergeChanges:NO];
    }
    
    // Loop through all the studios for this movie
    for (NSManagedObject *studio in [movie valueForKey:@"studios"]) {
      // Fire a fault just for this studio
      [studio valueForKey:@"name"];
      
      // Put this studio back in fault so the next movie
      // will have to fire a fault
      // [context refreshObject:studio mergeChanges:NO];
    }
  }
  return result;
}

@end
