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

#import "Circle.h"


@implementation Circle

@dynamic radius;
@dynamic x;
@dynamic y;

+ (Circle *)randomInstance:(CGPoint)origin inContext:(NSManagedObjectContext *)context {
  Circle *circle = [NSEntityDescription insertNewObjectForEntityForName:@"Circle" inManagedObjectContext:context];
  
  float radius = 10 + (arc4random() % 90);
  circle.x = [NSNumber numberWithFloat:origin.x];
  circle.y = [NSNumber numberWithFloat:origin.y];
  circle.radius = [NSNumber numberWithFloat:radius];
  
  return circle;
}

/*
- (BOOL)validateRadius:(id *)ioValue error:(NSError **)outError {
  NSLog(@"Validating radius using custom method");
  
  if ([*ioValue floatValue] < 7.0 || [*ioValue floatValue] > 10.0) {
    // Fill out the error object
    if (outError != NULL) {
      NSString *msg = @"Radius must be between 7.0 and 10.0";
      NSDictionary *dict = [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
      NSError *error = [[NSError alloc] initWithDomain:@"Shapes" code:10 userInfo:
                         dict];
      *outError = error;
    }
    return NO;
  }
  return YES;
}
*/

- (NSError *)errorFromOriginalError:(NSError *)originalError error:(NSError *)secondError
{
  NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
  NSMutableArray *errors = [NSMutableArray arrayWithObject:secondError];
  
  if ([originalError code] == NSValidationMultipleErrorsError) {
    [userInfo addEntriesFromDictionary:[originalError userInfo]];
    [errors addObjectsFromArray:[userInfo objectForKey:NSDetailedErrorsKey]];
  } else {
    [errors addObject:originalError];
  }
  
  [userInfo setObject:errors forKey:NSDetailedErrorsKey];
  
  return [NSError errorWithDomain:NSCocoaErrorDomain
                             code:NSValidationMultipleErrorsError
                         userInfo:userInfo];
}

- (BOOL)validateForInsert:(NSError **)outError {
  BOOL valid = [super validateForInsert:outError];
  
  // x can’t be more than twice as much as y
  float fx = [self.x floatValue], fy = [self.y floatValue];
  if (fx >= (2 * fy)) {
    // Create the error if one was passed
    if (outError != NULL) {
      NSString *msg = @"x can’t be more than twice as much as y";
      NSDictionary *dict = [NSDictionary dictionaryWithObject:msg forKey:NSLocalizedDescriptionKey];
      NSError *error = [[NSError alloc] initWithDomain:@"Shapes" code:30 userInfo:
                         dict];
      
      // Check to see if [super validateForInsert] returned errors
      if (*outError == nil) {
        *outError = error;
      } else {
        // Combine this error with any existing ones
        *outError = [self errorFromOriginalError:*outError error:error];
      }
    }
    valid = NO;
  }
  return valid;
}
@end
