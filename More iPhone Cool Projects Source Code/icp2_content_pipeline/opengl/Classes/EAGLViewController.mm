#import "EAGLViewController.h"
#import "EAGLView.h"

@implementation EAGLViewController

@synthesize glView;
@synthesize button;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  static CGRect buttonRect = { 410.0f, 270.0f, 60.0f, 60.0f };

  // Events don't work reliably for UIViews contained inside views using OpenGL,
  // so the events are handled manually here instead.
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint point = [touch locationInView:glView];
  if (CGRectContainsPoint(buttonRect, point))
  {
    button.highlighted = YES;
    [self showInfo];
  }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidAppear:(BOOL)animated
{
  [glView startAnimation];
  [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [glView stopAnimation];
  [super viewDidDisappear:animated];
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller 
{
  button.highlighted = NO;
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction)showInfo 
{
	FlipsideViewController *controller = 
    [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
  controller.modelText = glView.modelText;
  controller.textureText = glView.textureText;
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (void)dealloc 
{
  [glView release];
  [button release];
  [super dealloc];
}

@end
