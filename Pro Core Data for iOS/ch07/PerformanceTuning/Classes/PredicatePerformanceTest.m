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

#import "PredicatePerformanceTest.h"

@implementation PredicatePerformanceTest
- (NSString *)name {
  return @"Predicate Performance Test";
}

- (NSString *)runWithContext:(NSManagedObjectContext *)context {
  NSMutableString *result = [NSMutableString string];
  
  NSFetchRequest *request;
  
  NSDate *startTest1 = [NSDate date];
  for(int i=0; i<1000; i++) {
    [context reset];  
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(name LIKE %@) OR (rating < %d)", @"*c*or*", 5]];
    [context executeFetchRequest:request error:nil];
    [request release];
  }
  NSDate *endTest1 = [NSDate date];
  
  NSTimeInterval test1 = [endTest1 timeIntervalSinceDate:startTest1];
  [result appendFormat:@"Slow predicate: %.2f s\n", test1];
  
  NSDate *startTest2 = [NSDate date];
  for(int i=0; i<1000; i++) {
    [context reset];
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Movie" inManagedObjectContext:context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"(rating < %d) OR (name like %@)", 5, @"*c*or*"]];
    [context executeFetchRequest:request error:nil];
    [request release];  
  }
  NSDate *endTest2 = [NSDate date];
  
  NSTimeInterval test2 = [endTest2 timeIntervalSinceDate:startTest2];
  [result appendFormat:@"Fast predicate: %.2f s\n", test2];
  
  return result;
}

@end
