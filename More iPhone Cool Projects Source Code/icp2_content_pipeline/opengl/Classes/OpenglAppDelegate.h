#import <UIKit/UIKit.h>

@class EAGLView;
@class EAGLViewController;

@interface OpenglAppDelegate : NSObject <UIApplicationDelegate> 
{
  UIWindow *window;
  EAGLViewController *mainViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) EAGLViewController *mainViewController;

@end

