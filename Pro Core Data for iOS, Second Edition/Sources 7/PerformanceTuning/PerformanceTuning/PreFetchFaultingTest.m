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

#import <CoreData/CoreData.h>
#import "PreFetchFaultingTest.h"

@implementation PreFetchFaultingTest

- (NSString *)name {
  return @"Pre-fetch Faulting Test";
}

- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSString *result = @"Pre-fetch Fault Test Complete!";
  
  // Fetch all the movies
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  
  // Pre-fetch the actors and studios
  [request setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"actors", @"studios", nil]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  
  // Loop through all the movies
  for (NSManagedObject *movie in results) {
    // Fire a fault just for this movie
    [movie valueForKey:@"name"];
    
    // Loop through all the actors for this movie
    for (NSManagedObject *actor in [movie valueForKey:@"actors"]) {
      // Get the name for this actor
      [actor valueForKey:@"name"];
    }
    
    // Loop through all the studios for this movie
    for (NSManagedObject *studio in [movie valueForKey:@"studios"]) {
      // Get the name for this studio
      [studio valueForKey:@"name"];
    }
  }
  return result;
}

@end
