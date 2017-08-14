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

#import "Polygon.h"
#import "Vertex.h"

@implementation Polygon

@dynamic vertices;

+ (Polygon *)randomInstance:(CGPoint)origin inContext:(NSManagedObjectContext *)context {
  Polygon *polygon = [NSEntityDescription insertNewObjectForEntityForName:@"Polygon" inManagedObjectContext:context];
  
  // Set the vertices
  int nVertices = 3 + (arc4random() % 20);
  float angleIncrement = (2 * M_PI) / nVertices;
  int index = 0;
  for (float i = 0; i < nVertices; i++) {
    float a = i * angleIncrement;
    float radius = 10 + (arc4random() % 90);
    float x = origin.x + (radius * cos(a));
    float y = origin.y + (radius * sin(a));
    
    Vertex *vertex = [NSEntityDescription insertNewObjectForEntityForName:@"Point" inManagedObjectContext:context];
    vertex.x = [NSNumber numberWithFloat:x];
    vertex.y = [NSNumber numberWithFloat:y];
    vertex.index = [NSNumber numberWithFloat:index++];
    
    [polygon addVerticesObject:vertex];
  }
  return polygon;
}

@end
