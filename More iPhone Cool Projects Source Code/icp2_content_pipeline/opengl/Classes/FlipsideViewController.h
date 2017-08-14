@protocol FlipsideViewControllerDelegate;

@interface FlipsideViewController : UIViewController 
{
	id <FlipsideViewControllerDelegate> delegate;
  UILabel *model;
  UILabel *texture;
  NSString *modelText;
  NSString *textureText;
}

@property (nonatomic, assign) id <FlipsideViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UILabel *model;
@property (nonatomic, retain) IBOutlet UILabel *texture;
@property (nonatomic, retain) IBOutlet NSString *modelText;
@property (nonatomic, retain) IBOutlet NSString *textureText;
- (IBAction)done;

@end

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

