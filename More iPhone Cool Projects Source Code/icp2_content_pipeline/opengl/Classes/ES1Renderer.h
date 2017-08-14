#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

class Geometry;
class Image;
@class EAGLContext;
@class CAEAGLLayer;

@interface ES1Renderer : NSObject
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer, colorRenderbuffer;
  GLuint depthRenderbuffer;
}

- (void) attachGeometry: (Geometry *) geometry;
- (void) detachGeometry: (Geometry *) geometry;
- (GLuint) attachTexture: (Image *) image;
- (void) detachTexture: (GLuint) textureId;

- (void) begin;
- (void) renderGeometry: (Geometry *) geometry;
- (void) end;

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

@end
