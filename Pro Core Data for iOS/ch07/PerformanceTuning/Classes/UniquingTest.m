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
#import "UniquingTest.h"

@implementation UniquingTest

- (NSString *)name {
  return @"Uniquing test";
}

// Pull all the movies and verify that each of their actor objects are pointing to the same actors
- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSString *result = @"Uniquing test passed";
  
  // Array to hold the actors for comparison purposes
  NSMutableArray *referenceActors = nil;
  
  // Sorting for the actors
  NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
  NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
  [sortDescriptor release];
  
  // Fetch all the movies
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  [request release];
  
  // Go through each movie
  for (NSManagedObject *movie in results) {
    // Get the actors
    NSSet *actors = [movie mutableSetValueForKey:@"actors"];
    NSArray *sortedActors = [actors sortedArrayUsingDescriptors:sortDescriptors];
    
    if (referenceActors == nil) {
      // First time through; store the references
      referenceActors = [[NSArray alloc] initWithArray:sortedActors];
    } else {
      for (int i = 0, n = [sortedActors count]; i < n; i++) {
        if ([sortedActors objectAtIndex:i] != [referenceActors objectAtIndex:i]) {
          result = [NSString stringWithFormat:@"Uniquing test failed; %@ != %@", [sortedActors objectAtIndex:i], [referenceActors objectAtIndex:i]];
          break;
        }
      }
    }
  }
  [referenceActors release];
  [sortDescriptors release];
  return result;
}

@end

