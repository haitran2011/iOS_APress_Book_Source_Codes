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

#import "BasicCanvasUIView.h"

#import "Polygon.h"
#import "Circle.h"
#import "Shape.h"
#import "Vertex.h"
@implementation BasicCanvasUIView

@synthesize canvas;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (float)scale {
  NSManagedObject *transform = [canvas valueForKey:@"transform"];
  return [[transform valueForKey:@"scale"] floatValue];
}

- (void)drawRect:(CGRect)rect {
  // Check to make sure we have data
  if (canvas == nil) {
    return;
  }
  
  // Get the current graphics context for drawing
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // Store the scale in a local variable so we don’t hit the data store twice
  float scale = self.scale;
  
  // Scale the context according to the stored value
  CGContextScaleCTM(context, scale, scale);    
  
  // Retrieve all the shapes that relate to this canvas and iterate through them
  NSSet* shapes = [canvas valueForKey:@"shapes"];
  for (Shape *shape in shapes) {
    // Get the entity name to determine whether this is a Circle or a Polygon
    NSString *entityName = [[shape entity] name];
    
    // Get the color, stored as RGB values in a comma-separated string, and set it into the context
    const CGFloat *rgb = CGColorGetComponents(shape.color.CGColor);
    CGContextSetRGBFillColor(context, rgb[0], rgb[1], rgb[2], 1.0);
    
    // If this shape is a circle . . .
    if ([entityName compare:@"Circle"] == NSOrderedSame) {
      Circle *circle = (Circle *)shape;
      float x = [circle.x floatValue]; 
      float y = [circle.y floatValue]; 
      float radius = [circle.radius floatValue];

      CGContextFillEllipseInRect(context, CGRectMake(x-radius, y-radius, 2*radius, 2*radius));
    } else if ([entityName compare:@"Polygon"] == NSOrderedSame) {
      Polygon *polygon = (Polygon *)shape;
      
      // This is a polygon
      // Use a sort descriptor to order the vertices using the index value
      NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:
                                          @"index" ascending:YES];
      NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
      NSArray* vertices = [polygon.vertices sortedArrayUsingDescriptors:sortDescriptors];
      
      // Begin drawing the polygon
      CGContextBeginPath(context);
      
      // Place the current graphic context point on the last vertex
      Vertex *lastVertex = [vertices lastObject];
      CGContextMoveToPoint(context, [lastVertex.x floatValue], [lastVertex.y floatValue]);
      
      // Iterate through the vertices and link them together
      for (Vertex *vertex in vertices) {
        CGContextAddLineToPoint(context, [vertex.x floatValue], [vertex.y floatValue]);
      }

      // Fill the polygon
      CGContextFillPath(context);
    }
  }
}

@end
