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

#import "Canvas.h"
#import "Shape.h"
#import "Transform.h"


@implementation Canvas

@dynamic transform;
@dynamic shapes;

+ (Canvas *)initWithTransform:(Transform *)transform inContext:(NSManagedObjectContext*)context {
  Canvas *canvas = [NSEntityDescription insertNewObjectForEntityForName:@"Canvas" inManagedObjectContext:context];
  canvas.transform = transform;
  return canvas;
}

@end
