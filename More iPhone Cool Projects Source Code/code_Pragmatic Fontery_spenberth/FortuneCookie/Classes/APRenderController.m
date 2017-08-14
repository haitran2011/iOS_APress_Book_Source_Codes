//
//  APRenderController.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "APRenderController.h"
#import "APFortunes.h"

@implementation APRenderController

// Create an ES 1.1 context
- (id) init
{
	if (self = [super init])
	{
		[self createContext];
		if (!context) return nil;
		[self createFrameBuffers];
		[self createObjects];
	}
	
	return self;
}

- (void) createContext
{
	
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	if (!context || ![EAGLContext setCurrentContext:context])
	{
		[self release];
		context = nil;
	}
}

#define randomPercent (((CGFloat)(arc4random() % 40001))/40000.0)

- (void) createObjects
{
	int fortune = round(randomPercent * (kFortuneCount-1));
	int fontid = round(randomPercent * kFontCount);
	NSString *quote = [NSString stringWithUTF8String: kFortunes[fortune]];
	NSString *font = [NSString stringWithFormat: @"font%d", fontid];
	NSLog(@"Showing fortune:\n%@\nin font %@",quote,font);
	
	ourText = [[APText alloc] init];
	[ourText useFont: font];
	[ourText setString: quote];
	ourText.r = 0.7*randomPercent;
	ourText.g = 0.7*randomPercent;
	ourText.b = 0.7*randomPercent;
	offset = 0;
}

- (void) createFrameBuffers
{
	// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
	glGenFramebuffersOES(1, &defaultFramebuffer);
	glGenRenderbuffersOES(1, &colorRenderbuffer);
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, colorRenderbuffer);
}

- (BOOL) resizeFromLayer:(CAEAGLLayer *)layer
{	
	// Allocate color buffer backing based on the current layer size
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
	[self setupPortraitMode];
    return YES;
}

- (void) setupPortraitMode
{
	// This call is redundant, but needed if dealing with multiple framebuffers.
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, defaultFramebuffer);
    glViewport(0, 0, backingWidth, backingHeight);    
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
	glOrthof(-backingWidth/2.0, backingWidth/2.0, -backingHeight/2.0, backingHeight/2.0, -1.0f, 1.0f);
}

- (void) beforeRender
{
	[EAGLContext setCurrentContext:context];	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	glShadeModel (GL_SMOOTH);
	glBlendFunc(GL_ONE, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
    glClearColor(0.9f,0.9f,0.9f,0.6);
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
}

- (void) afterRender
{	
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, colorRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}
	

- (void) renderObjects
{
	offset += 2;
	if (offset > ourText.lineWidth + 160) {
		offset = 0;
		ourText.r = 0.7*randomPercent;
		ourText.g = 0.7*randomPercent;
		ourText.b = 0.7*randomPercent;
	}
	glTranslatef(-offset,0,0);
	ourText.alpha = 0.6+0.2*(cos(offset*3.1415926/180)+1.0);
	[ourText render];
}
	

- (void) render
{
	[self beforeRender];
	[self renderObjects];
	[self afterRender];
}

- (void) releaseFrameBuffers
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
}	

- (void) releaseContext
{	
	// Tear down context
	if ([EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
	
	[context release];
	context = nil;
}

- (void) releaseObjects
{
	[ourText release];
}
	

- (void) dealloc
{
	[self releaseFrameBuffers];
	[self releaseContext];
	[self releaseObjects];
	[super dealloc];
}

@end
