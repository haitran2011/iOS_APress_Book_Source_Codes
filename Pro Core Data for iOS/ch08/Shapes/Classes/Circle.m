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

#import "Circle.h"


@implementation Circle 

@dynamic x;
@dynamic y;
@dynamic radius;

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
      NSError *error = [[[NSError alloc] initWithDomain:@"Shapes" code:10 userInfo:dict] autorelease];
      *outError = error;
    }
    return NO;
  }
  return YES;
}
*/

@end
