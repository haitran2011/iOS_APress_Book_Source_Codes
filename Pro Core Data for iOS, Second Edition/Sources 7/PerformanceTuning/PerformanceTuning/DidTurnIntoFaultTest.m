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

#import "DidTurnIntoFaultTest.h"
#import <CoreData/CoreData.h>
#import "Actor.h"

@implementation DidTurnIntoFaultTest

- (NSString *)name {
  return @"Did Turn Into Fault Test";
}

// Pull all the movies and verify that each of their actor objects are pointing to the same actors
- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSString *result = nil;
  
  // Fetch the first movie
  NSFetchRequest *request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Movie 1"];
  [request setPredicate:predicate];
  NSArray *results = [context executeFetchRequest:request error:nil];
  
  if ([results count] == 1) {
    NSManagedObject *movie = (NSManagedObject *)[results objectAtIndex:0];
    NSSet *actors = [movie valueForKey:@"actors"];
    if ([actors count] != 200) {
      result = @"Failed to find the 200 actors for the first movie";
    } else {
      // Get an actor
      Actor *actor = (Actor *)[actors anyObject];
      
      // Check if it's a fault
      result = [actor isFault] ? @"Actor is a fault.\n" : @"Actor is NOT a fault.\n";
      
      // Get its name and rating
      result = [result stringByAppendingFormat:@"Actor is named %@\n", actor.name];
      result = [result stringByAppendingFormat:@"Actor has rating %d\n", [actor.rating integerValue]];
      
      // Check if it's a fault
      result = [result stringByAppendingString:[actor isFault] ? 
                @"Actor is a fault.\n" : @"Actor is NOT a fault.\n"];
      
      // Turn actor back into a fault
      result = [result stringByAppendingString:@"Turning actor back into a fault.\n"];
      [context refreshObject:actor mergeChanges:NO];
      
      // Check if it's a fault
      result = [result stringByAppendingString:[actor isFault] ? 
                @"Actor is a fault.\n" : @"Actor is NOT a fault.\n"];
    }
  } else {
    result = @"Failed to fetch the first movie";
  }
  return result;
}

@end
