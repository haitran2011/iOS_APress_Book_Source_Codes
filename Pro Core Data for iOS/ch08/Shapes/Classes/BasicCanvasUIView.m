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

#import "BasicCanvasUIView.h"
#import "Shape.h"
#import "Ellipse.h"
#import "Polygon.h"
#import "Vertex.h"

@implementation BasicCanvasUIView

@synthesize canvas;

- (float)scale {
  NSManagedObject *transform = [canvas valueForKey:@"transform"];
  return [[transform valueForKey:@"scalarValue"] floatValue];
}

- (void)drawRect:(CGRect)rect {
  if (canvas == nil) return;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  float scale = self.scale;
  CGContextScaleCTM(context, scale, scale);    
  
  NSSet* shapes = [canvas valueForKey:@"shapes"];
  for (Shape *shape in shapes) {
    NSString *entityName = [[shape entity] name];
    
    const CGFloat *rgb = CGColorGetComponents(shape.color.CGColor);        
    CGContextSetRGBFillColor(context, rgb[0], rgb[1], rgb[2], 1.0);        
    
    if ([entityName compare:@"Ellipse"] == NSOrderedSame) {
      Ellipse *ellipse = (Ellipse *)shape;
      float x = [ellipse.x floatValue];
      float y = [ellipse.y floatValue];
      float width = [ellipse.width floatValue];
      float height = [ellipse.height floatValue];
      
      CGContextFillEllipseInRect(context, CGRectMake(x - (width / 2), y - (height / 2), width, height));      
    } else if ([entityName compare:@"Polygon"] == NSOrderedSame) {
      Polygon *polygon = (Polygon *)shape;
      // Use a sort descriptor to order the vertices using the index value
      NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"index" ascending:YES];
      NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
      
      NSArray* vertices = [polygon.vertices sortedArrayUsingDescriptors:sortDescriptors];
      
      CGContextBeginPath(UIGraphicsGetCurrentContext());
      
      // Place the current graphic context point on the last vertex
      Vertex *lastVertex = [vertices lastObject];
      CGContextMoveToPoint(context, [lastVertex.x floatValue], [lastVertex.y floatValue]);
      
      // Iterate through the vertices and link them together
      for(Vertex *vertex in vertices) {
        CGContextAddLineToPoint(context, [vertex.x floatValue], [vertex.y floatValue]);
      }
      
      CGContextFillPath(context);
      
      [sortDescriptors release];
      [sortDescriptor release];
    }
  }
}

@end
