#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

class Geometry;
@class ES1Renderer;

@interface EAGLView : UIView
{    
@private
	ES1Renderer* renderer;
	
	BOOL animating;
	BOOL displayLinkSupported;
	NSInteger animationFrameInterval;
	id displayLink;
  NSTimer *animationTimer;
  
  Geometry* geometry;
  uint32_t textureId;
  
  float currentSpeed;
  float lastTime;
  float rotation;
  CGPoint lastTouch;
  
  NSString *modelText;
  NSString *textureText;
}

@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@property (nonatomic, retain) IBOutlet NSString *modelText;
@property (nonatomic, retain) IBOutlet NSString *textureText;

- (void) startAnimation;
- (void) stopAnimation;
- (void) drawView:(id)sender;

@end
