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

#import "FetchAllMoviesActorsAndStudiosTest.h"
#import <CoreData/CoreData.h>

@implementation FetchAllMoviesActorsAndStudiosTest

- (NSString *)name {
  return @"Fetch all test";
}

- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  NSArray *results = [context executeFetchRequest:request error:nil];
  
  int actorsRead = 0, studiosRead = 0;
  for (NSManagedObject *movie in results) {
    actorsRead += [[movie valueForKey:@"actors"] count];
    studiosRead += [[movie valueForKey:@"studios"] count];
    [context refreshObject:movie mergeChanges:NO];
  }
  return [NSString stringWithFormat:@"Fetched %d actors and %d studios", actorsRead, studiosRead];
}

@end
