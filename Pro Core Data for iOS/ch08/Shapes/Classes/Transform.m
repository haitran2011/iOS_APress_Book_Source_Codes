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

#import "Transform.h"


@implementation Transform 

@dynamic scalarValue;
@dynamic canvas;

+ (Transform *)initWithScale:(float)scale inContext:(NSManagedObjectContext *)context {
  Transform *transform = [NSEntityDescription insertNewObjectForEntityForName:@"Transform" inManagedObjectContext:context];
  transform.scalarValue = [NSNumber numberWithFloat:scale];
  return transform;
}

@end
