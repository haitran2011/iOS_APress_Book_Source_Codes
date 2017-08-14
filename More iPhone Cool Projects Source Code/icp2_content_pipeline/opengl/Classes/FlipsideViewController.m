#import "FlipsideViewController.h"

@implementation FlipsideViewController

@synthesize delegate;
@synthesize model;
@synthesize texture;
@synthesize modelText;
@synthesize textureText;

- (void)viewDidLoad 
{
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
  self.model.text = modelText;
  self.texture.text = textureText;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
  return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
  NSLog(@"touchesEnded");
}

- (IBAction)done 
{
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (void)dealloc 
{
  [model release];
  [texture release];
  [modelText release];
  [textureText release];
  [super dealloc];
}

@end
