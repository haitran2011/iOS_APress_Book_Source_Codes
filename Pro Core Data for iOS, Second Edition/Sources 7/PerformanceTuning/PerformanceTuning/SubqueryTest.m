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
#import "SubqueryTest.h"

@implementation SubqueryTest

- (NSString *)name {
  return @"Subquery Performance Test";
}

- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSMutableString *result = [NSMutableString string];
  
  NSFetchRequest *request;
  
  int count = 0;
  
  [context reset];
  NSDate *startTest1 = [NSDate date];
  NSMutableDictionary *actorsMap = [NSMutableDictionary dictionary];
  request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"(rating < %d) OR (name LIKE %@)", 5, @"*c*or*"]];
  NSArray *movies = [context executeFetchRequest:request error:nil];
  
  for (NSManagedObject *movie in movies) {
    NSSet *actorSet = [movie valueForKey:@"actors"];
    for (NSManagedObject *actor in actorSet) {
      [actorsMap setValue:actor forKey:[[[actor objectID] URIRepresentation] description]];
    }
  }
  
  count = [actorsMap count];
  
  NSDate *endTest1 = [NSDate date];
  
  NSTimeInterval test1 = [endTest1 timeIntervalSinceDate:startTest1];
  [result appendFormat:@"No subquery: %.2f s\n", test1];
  [result appendFormat:@"Actors retrieved: %d\n", count];
  
  [context reset];
  NSDate *startTest2 = [NSDate date];
  request = [[NSFetchRequest alloc] init];
  [request setEntity:[NSEntityDescription entityForName:@"Actor" inManagedObjectContext:context]];
  [request setPredicate:[NSPredicate predicateWithFormat:@"(SUBQUERY(movies, $x, ($x.rating < %d) OR ($x.name LIKE %@)).@count > 0)", 5, @"*c*or*"]];
  
  NSArray *actors = [context executeFetchRequest:request error:nil];
  count = [actors count];
  NSDate *endTest2 = [NSDate date];
  
  NSTimeInterval test2 = [endTest2 timeIntervalSinceDate:startTest2];
  [result appendFormat:@"Subquery: %.2f s\n", test2];
  [result appendFormat:@"Actors retrieved: %d\n", count];
  
  return result;
}

@end
