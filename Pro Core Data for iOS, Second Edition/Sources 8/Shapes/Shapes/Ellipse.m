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

#import "Ellipse.h"

@implementation Ellipse

@dynamic height;
@dynamic width;
@dynamic x;
@dynamic y;

+ (Ellipse *)randomInstance:(CGPoint)origin inContext:(NSManagedObjectContext *)context {
  Ellipse *ellipse = [NSEntityDescription insertNewObjectForEntityForName:@"Ellipse" inManagedObjectContext:context];
  
  float width = 10 + (arc4random() % 90);
  float height = 10 + (arc4random() % 90);
  ellipse.x = [NSNumber numberWithFloat:origin.x];
  ellipse.y = [NSNumber numberWithFloat:origin.y];
  ellipse.width = [NSNumber numberWithFloat:width];
  ellipse.height = [NSNumber numberWithFloat:height];
  
  return ellipse;
}

@end
