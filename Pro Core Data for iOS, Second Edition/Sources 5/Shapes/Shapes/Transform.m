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

#import "Transform.h"
#import "Canvas.h"

@implementation Transform

@dynamic scale;
@dynamic canvas;

+ (Transform *)initWithScale:(float)scale inContext:(NSManagedObjectContext *)context {
  Transform *transform = [NSEntityDescription insertNewObjectForEntityForName:@"Transform" inManagedObjectContext:context];
  transform.scale = [NSNumber numberWithFloat:scale];
  return transform;
}

@end
