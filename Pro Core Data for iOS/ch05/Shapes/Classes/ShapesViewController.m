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

#include <stdlib.h>
#import "ShapesViewController.h"

#import "Polygon.h"
#import "Circle.h"
#import "Shape.h"
#import "Canvas.h"
#import "Vertex.h"
#import "Transform.h"

@interface ShapesViewController (private)
- (void)createShapeAt:(CGPoint)point;
- (void)updateAllShapes;
- (void)deleteAllShapes;
- (UIColor *)makeRandomColor;
@end

@implementation ShapesViewController

@synthesize topView;
@synthesize bottomView;
@synthesize managedObjectContext;
@synthesize undoButton, redoButton;

- (void)createShapeAt:(CGPoint)point {
  Shape *shape = nil;
  int type = arc4random() % 2;
  
  if(type == 0) { // Circle
    shape = [Circle randomInstance:point inContext:self.managedObjectContext];
  }
  else {  // Polygon
    shape = [Polygon randomInstance:point inContext:self.managedObjectContext];  }
  // Set the shape’s color
  shape.color = [self makeRandomColor];
  
  // Add the same shape to both canvases
  [[topView.canvas mutableSetValueForKey:@"shapes"] addObject:shape];
  [[bottomView.canvas mutableSetValueForKey:@"shapes"] addObject:shape];
  
  // Save the context
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  // Tell the views to repaint themselves
  [topView setNeedsDisplay];
  [bottomView setNeedsDisplay];
}

- (UIColor *)makeRandomColor {
  // Generate three color values
  float red = (arc4random() % 256) / 255.0;
  float green = (arc4random() % 256) / 255.0;
  float blue = (arc4random() % 256) / 255.0;
  
  return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (void)updateAllShapes {
  // Retrieve all the shapes
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shape" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  NSArray *shapes = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
  [fetchRequest release];
  
  // Go through all the shapes and update their colors randomly
  for (NSManagedObject *shape in shapes) {
    [shape setValue:[self makeRandomColor] forKey:@"color"];
  }
  
  // Save the context
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  // Tell the views to repaint themselves
  [topView setNeedsDisplay];
  [bottomView setNeedsDisplay];
}

- (void)deleteAllShapes {
  // Retrieve all the shapes
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Shape" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  NSArray *shapes = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
  [fetchRequest release];
  
  // Delete each shape.
  for (NSManagedObject *shape in shapes) {
    [managedObjectContext deleteObject:shape];
  }
  
  // Save the context
  NSError *error = nil;
  if (![self.managedObjectContext save:&error]) {
    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  // Tell the views to repaint themselves
  [topView setNeedsDisplay];
  [bottomView setNeedsDisplay];
}

- (void)viewDidLoad {
  Canvas *canvas1 = nil;
  Canvas *canvas2 = nil;
  
  // Load the canvases
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
  NSEntityDescription *entity = [NSEntityDescription entityForName:@"Canvas" inManagedObjectContext:self.managedObjectContext];
  [fetchRequest setEntity:entity];
  
  NSArray *canvases = [managedObjectContext executeFetchRequest:fetchRequest error:nil];
  [fetchRequest release];
  
  if ([canvases count] >= 2) {
    NSLog(@"Loading existing canvases");
    canvas1 = [canvases objectAtIndex:0];
    canvas2 = [canvases objectAtIndex:1];
  } else {
    NSLog(@"Making new canvases");
    // If there aren’t any canvases, then we create them
    Transform *transform1 = [Transform initWithScale:1 inContext:self.managedObjectContext];
    canvas1 = [Canvas initWithTransform:transform1 inContext:self.managedObjectContext];
    
    Transform *transform2 = [Transform initWithScale:0.5 inContext:self.managedObjectContext];
    canvas2 = [Canvas initWithTransform:transform2 inContext:self.managedObjectContext];
    
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
  topView.canvas = canvas1;
  bottomView.canvas = canvas2;
  
  // Register for changes to the managed object context
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self selector:@selector(updateUndoAndRedoButtons:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
  [self updateUndoAndRedoButtons:nil];  
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)dealloc {
  [super dealloc];
}

#pragma mark -
#pragma mark Touch events handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  UITouch *touch = [touches anyObject];
  
  // Where did the view get touched?
  CGPoint location = [touch locationInView: touch.view];
  
  // Scale according to the canvas’ transform
  float scale = [(BasicCanvasUIView *)touch.view scale];    
  location = CGPointMake(location.x / scale, location.y / scale);
  
  // Create the shape
  [self createShapeAt:location];
}

- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
  [self updateAllShapes];
}

- (BOOL)canBecomeFirstResponder {
  return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self becomeFirstResponder];
}

#pragma mark -
#pragma mark Shake events handling

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
  if (event.subtype == UIEventSubtypeMotionShake) {
    [self deleteAllShapes];
  }
}

#pragma mark -
#pragma mark Undo and Redo

- (IBAction)undo:(id)sender {
  [[self.managedObjectContext undoManager] undo];
  [topView setNeedsDisplay];
  [bottomView setNeedsDisplay];
}

- (IBAction)redo:(id)sender {
  [[self.managedObjectContext undoManager] redo];
  [topView setNeedsDisplay];
  [bottomView setNeedsDisplay];
}

- (void)updateUndoAndRedoButtons:(NSNotification *)notification {
  NSUndoManager *undoManager = [self.managedObjectContext undoManager];
  undoButton.hidden = ![undoManager canUndo];
  redoButton.hidden = ![undoManager canRedo];
}

@end
