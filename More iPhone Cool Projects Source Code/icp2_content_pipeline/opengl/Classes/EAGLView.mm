#import "EAGLView.h"

#import "ES1Renderer.h"
#import "FlipsideViewController.h"

#include <resource/Geometry.h>
#include <resource/pvrtc/PvrtcResourceReader.h>
#include <resource/geometry/GeometryResourceReader.h>
#include <mach/mach_time.h>

@interface EAGLView()
  - (double) getTimeBaseSeconds;
  - (float) getSeconds;
  - (CGFloat) distanceBetweenFirstPoint:(CGPoint) first secondPoint:(CGPoint) second;
@end

@implementation EAGLView

@synthesize animating;
@synthesize modelText;
@synthesize textureText;
@dynamic animationFrameInterval;

+ (Class) layerClass
{
    return [CAEAGLLayer class];
}

- (id) initWithCoder:(NSCoder*)coder
{    
  if ((self = [super initWithCoder:coder]))
  {
    // Get the layer
    CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;

    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
		renderer = [[ES1Renderer alloc] init];
        
		animating = FALSE;
		displayLinkSupported = FALSE;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
    
    currentSpeed = 0.0f;
    lastTime = [self getSeconds];
    rotation = -50.0f;
		
    // A system version of 3.1 or greater is required to use CADisplayLink. The NSTimer
    // class is used as fallback when it isn't available.
    NSString *reqSysVer = @"3.1";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] != NSOrderedAscending)
      displayLinkSupported = TRUE;
  }

  // Model geometry (custom mesh format)
  NSString *filePath = [[NSBundle mainBundle] pathForResource:@"converted" ofType:nil];
  GeometryResourceReader reader;
  bool isOpen = reader.open(filePath.UTF8String);
  if (isOpen)
  {
    // Read geometry.
    geometry = new Geometry();
    reader.read(*geometry, 0x00000000);   // converted/geometry/00000000
    
    // Setup geometry (OpenGL creates a copy).
    [renderer attachGeometry:geometry];
    
    // Free original geometry data.
    self.modelText = [NSString stringWithFormat:@"%d triangles", geometry->getNumIndices() / 3];
    geometry->freeMemory();
  }

  // Model texture (PVRTC)
  NSString *textureFile = [filePath stringByAppendingPathComponent:@"/texture/00000000.pvr"];
  PvrtcResourceReader pvrtcReader;
  isOpen = pvrtcReader.open(textureFile.UTF8String);
  if (isOpen)
  {
    // Read PVRTC texture. Image data will be released automatically when 
    // image falls out of scope.
    Image image(Image::PVRTC_4BPP, pvrtcReader.getWidth(), pvrtcReader.getHeight());
    pvrtcReader.read(image);              // converted/texture/00000000.pvr
    
    // Setup texture (OpenGL creates a copy).
    textureId = [renderer attachTexture:&image];
    
    // Enable texture.
    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, textureId);
    self.textureText = [NSString stringWithFormat:@"%dx%d %@", 
                        image.getWidth(), image.getHeight(), @"PVRTC 4bpp"];
    
    glDisable(GL_LIGHTING);
  }

  return self;
}

- (void) dealloc
{
  [renderer detachTexture:textureId];
  [renderer detachGeometry:geometry];
  
  [renderer release];
  [modelText release];
  [textureText release];
  
  [super dealloc];
}

- (double) getTimeBaseSeconds
{
  struct mach_timebase_info timeBaseInfo;
  mach_timebase_info(&timeBaseInfo);
  return (static_cast<double>(timeBaseInfo.numer) / 
          static_cast<double>(timeBaseInfo.denom) * 1.0e-9);
}

- (float) getSeconds
{
  static double timeBase = [self getTimeBaseSeconds];
  static double startTime = static_cast<double>(mach_absolute_time());
	double time = static_cast<double>(mach_absolute_time());
	return static_cast<float>((time - startTime) * timeBase);
}

- (CGFloat) distanceBetweenFirstPoint:(CGPoint) first secondPoint:(CGPoint) second
{
  CGFloat deltaX = second.x - first.x;
  CGFloat deltaY = second.y - first.y;
  if (deltaX > 0.0f)
  {
    return sqrt(deltaX*deltaX + deltaY*deltaY );
  }
  else 
  {
    return -sqrt(deltaX*deltaX + deltaY*deltaY );
  }
  
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  lastTouch = [touch locationInView:self];
  currentSpeed = 0.0f;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
  UITouch *touch = [[touches allObjects] objectAtIndex:0];
  CGPoint currentTouch = [touch locationInView:self];
  float distance = [self distanceBetweenFirstPoint:lastTouch secondPoint:currentTouch];
  currentSpeed = distance * 30.0f;
  lastTouch = currentTouch;
}

- (void) drawView:(id)sender
{
  [renderer begin];
  
  float currentTime = [self getSeconds];
  float delta = currentTime - lastTime;
  lastTime = currentTime;
  
  static const float friction = 0.96f;
  currentSpeed *= friction;
  rotation += currentSpeed * delta;
  rotation = fmod(rotation, 360.0f);
  
  // Transform geometry into world space.
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();
  glTranslatef(0.0f, 0.0f, -8.0f);
  glRotatef(rotation, 0.0f, 1.0f, 0.0f);
  glRotatef(-90.0f, 1.0f, 0.0f, 0.0f);
  glScalef(0.01f, 0.01f, 0.01f);
  
  // Render geometry.
  [renderer renderGeometry:geometry];
  
  [renderer end];
}

- (void) layoutSubviews
{
	[renderer resizeFromLayer:(CAEAGLLayer*)self.layer];
  [self drawView:nil];
}

- (NSInteger) animationFrameInterval
{
	return animationFrameInterval;
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval
{
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
	if (frameInterval >= 1)
	{
		animationFrameInterval = frameInterval;
		
		if (animating)
		{
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

- (void) startAnimation
{
	if (!animating)
	{
		if (displayLinkSupported)
		{
			// CADisplayLink is API new to iPhone SDK 3.1. Compiling against earlier versions will result in a warning, but can be dismissed
			// if the system version runtime check for CADisplayLink exists in -initWithCoder:. The runtime check ensures this code will
			// not be called in system versions earlier than 3.1.

			displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView:)];
			[displayLink setFrameInterval:animationFrameInterval];
			[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
		}
		else
    {
			animationTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)((1.0 / 60.0) * animationFrameInterval) target:self selector:@selector(drawView:) userInfo:nil repeats:TRUE];
    }
		
		animating = TRUE;
	}
}

- (void)stopAnimation
{
	if (animating)
	{
		if (displayLinkSupported)
		{
			[displayLink invalidate];
			displayLink = nil;
		}
		else
		{
			[animationTimer invalidate];
			animationTimer = nil;
		}
		
		animating = FALSE;
	}
}

@end
