#import "ES1Renderer.h"

#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>
#import <QuartzCore/QuartzCore.h>

#include <resource/Geometry.h>
#include <resource/Image.h>

@implementation ES1Renderer

// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
    if (!context || ![EAGLContext setCurrentContext:context])
		{
      [self release];
      return nil;
    }
    
    glGenFramebuffersOES(1, &defaultFramebuffer);
		glGenRenderbuffersOES(1, &colorRenderbuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, 
                                 GL_COLOR_ATTACHMENT0_OES, 
                                 GL_RENDERBUFFER_OES, 
                                 colorRenderbuffer);
    
    glGenRenderbuffersOES(1, &depthRenderbuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, 
                                 GL_DEPTH_ATTACHMENT_OES, 
                                 GL_RENDERBUFFER_OES, 
                                 depthRenderbuffer);
	}
	
	return self;
}

- (void)gluPerspective:(float)fovy :(float)aspect :(float)zNear :(float)zFar
{
  float xmin, xmax, ymin, ymax;
  ymax = zNear * tan(fovy * M_PI / 360.0f);
  ymin = -ymax;
  xmin = ymin * aspect;
  xmax = ymax * aspect;
  glFrustumf(xmin, xmax, ymin, ymax, zNear, zFar);
}
    
- (void) attachGeometry: (Geometry *) geometry
{
  // Vertex buffer
  GLuint vboId;
  glGenBuffers(1, &vboId);
  glBindBuffer(GL_ARRAY_BUFFER, vboId);
  glBufferData(GL_ARRAY_BUFFER, 
    geometry->getVertices().size() * sizeof(Geometry::Vertex),
    &geometry->getVertices().begin()[0], GL_STATIC_DRAW);
  geometry->setVertexBufferId(vboId);
  
  // Index buffer
  GLuint iboId;
  glGenBuffers(1, &iboId);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, iboId);
  glBufferData(GL_ELEMENT_ARRAY_BUFFER, 
    geometry->getIndices().size() * sizeof(Geometry::Index),
    &geometry->getIndices()[0], GL_STATIC_DRAW);
  geometry->setIndexBufferId(iboId);
}

- (void) detachGeometry: (Geometry *) geometry
{
  GLuint vboId = geometry->getVertexBufferId();
  glDeleteBuffers(1, &vboId);
  geometry->setVertexBufferId(-1);
  GLuint iboId = geometry->getIndexBufferId();
  glDeleteBuffers(1, &iboId);
  geometry->setIndexBufferId(-1);
}

- (GLuint) attachTexture: (Image *) image
{
  GLuint textureId;
  glGenTextures(1, &textureId);
  glBindTexture(GL_TEXTURE_2D, textureId);
  glCompressedTexImage2D(GL_TEXTURE_2D, 0, GL_COMPRESSED_RGB_PVRTC_4BPPV1_IMG, 
                         image->getWidth(), image->getHeight(), 0, 
                         image->getNumBytes(), image->getData());
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
  glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
  glTexEnvf( GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_DECAL);      
  
  return textureId;
}

- (void) detachTexture: (GLuint) textureId
{
  glDeleteTextures(1, &textureId);
}

- (void) begin
{
  [EAGLContext setCurrentContext:context];
  
  glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
  glViewport(0, 0, backingWidth, backingHeight);
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  [self gluPerspective:45.0f :(float)backingWidth/(float)backingHeight :0.1f :100.0f];
  
  glClearColor(0.0f, 0.0f, 0.0f, 1.0f);
  glEnable(GL_DEPTH_TEST);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void) renderGeometry: (Geometry *) geometry
{
  // Vertex attributes
  glBindBuffer(GL_ARRAY_BUFFER, geometry->getVertexBufferId());
  glEnableClientState(GL_VERTEX_ARRAY);
  glVertexPointer(3, GL_FLOAT, sizeof(Geometry::Vertex), 
    (const GLvoid*)offsetof(Geometry::Vertex, position));
  
  // No lighting
//  glEnableClientState(GL_NORMAL_ARRAY);
//  glVertexPointer(3, GL_FLOAT, sizeof(Geometry::Vertex), 
//    (const GLvoid*)offsetof(Geometry::Vertex, normal));
  
  glEnableClientState(GL_TEXTURE_COORD_ARRAY);
  glClientActiveTexture(GL_TEXTURE0);
  glTexCoordPointer(2, GL_FLOAT, sizeof(Geometry::Vertex), 
    (const GLvoid*)offsetof(Geometry::Vertex, uv0));
  
  // Render mode
  GLuint renderMode = GL_TRIANGLES;
  Geometry::PrimitiveType primitiveType = geometry->getPrimitiveType();
  switch (primitiveType)
  {
    case Geometry::PT_LineList:
      renderMode = GL_LINES;
      break;
    case Geometry::PT_PointList:
      renderMode = GL_POINTS;
      break;
    case Geometry::PT_TriangleList:
      renderMode = GL_TRIANGLES;
  }
  
  // Draw mesh
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, geometry->getIndexBufferId());
  glDrawElements(renderMode, geometry->getNumIndices(), GL_UNSIGNED_SHORT, 0);
  
  // Disable states
  glDisableClientState(GL_VERTEX_ARRAY);
  glDisableClientState(GL_TEXTURE_COORD_ARRAY);
  glDisableClientState(GL_NORMAL_ARRAY);
  glBindBuffer(GL_ARRAY_BUFFER, 0);
  glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, 0);
  glMatrixMode(GL_MODELVIEW);
}

- (void) end
{
  glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
  [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
  glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
  glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
  
  glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
  glRenderbufferStorageOES(GL_RENDERBUFFER_OES, 
                           GL_DEPTH_COMPONENT16_OES, 
                           backingWidth, backingHeight);
  
  if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
    return NO;
  }
    
  return YES;
}

- (void) dealloc
{
	// Tear down GL
	if (defaultFramebuffer)
	{
		glDeleteFramebuffersOES(1, &defaultFramebuffer);
		defaultFramebuffer = 0;
	}

	if (colorRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &colorRenderbuffer);
		colorRenderbuffer = 0;
	}
	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
	
	[super dealloc];
}

@end
