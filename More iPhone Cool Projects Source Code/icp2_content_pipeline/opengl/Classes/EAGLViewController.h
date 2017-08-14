#import "FlipsideViewController.h"

@class EAGLView;

@interface EAGLViewController : UIViewController <FlipsideViewControllerDelegate> 
{
  EAGLView *glView;
  UIButton *button;
}

@property (nonatomic, retain) IBOutlet EAGLView *glView;
@property (nonatomic, retain) IBOutlet UIButton *button;

- (IBAction)showInfo;

@end
