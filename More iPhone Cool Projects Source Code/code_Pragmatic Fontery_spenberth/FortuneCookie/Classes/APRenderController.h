//
//  APRenderController.h
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "APText.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

//
// APRenderController is the workhorse of our Gutenberg pragmatic font system.
//
// The render controller has a single instance of APText, holding the string of
// characters we wish to display.  For the Fortune Cookie app, it chooses this string
// randomly on startup.  
//
// The controller holds a reference to our printing press, the OpenGL *context.
// It also references the current frame buffer, defaultFramebuffer, and the rendering
// buffer of the screen, colorRenderbuffer, swapping these at each iteration.
//
// offset is a little hack that tells us how much to move the text on each iteration.  We 
// this to scroll the fortune along the fortune tape.  When we reach the end of the tape,
// we rewind.
//
// This simple example hopefully provides you with a framwork for much more involved
// fontery in your applications.   I'm always available online if you run into challenges,
// @drjsp173 on Twitter.
//
// Happy hacking!
// -- Scott Penberthy, May 2010
//

@interface APRenderController : NSObject
{
@private
	EAGLContext *context;
	
	// The pixel dimensions of the CAEAGLLayer
	GLint backingWidth;
	GLint backingHeight;
	
	// The OpenGL names for the framebuffer and renderbuffer used to render to this view
	GLuint defaultFramebuffer;
	GLuint colorRenderbuffer;
	
	APText *ourText;
	CGFloat offset;
}

- (void) render;
- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer;

- (void) createContext;
- (void) createObjects;
- (void) createFrameBuffers;
- (void) setupPortraitMode;
- (void) beforeRender;
- (void) renderObjects;
- (void) afterRender;
- (void) releaseContext;
- (void) releaseFrameBuffers;
- (void) releaseObjects;
- (void) dealloc;


@end
