//
//  Canvas.m
//  testShapes
//
//  Created by Chen Li on 10/10/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "Canvas.h"


@implementation Canvas


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        // Initialization code
    }
    return self;
}

// We're drawing some simple shapes here. Can you draw a beautiful image here?
- (void)drawRect:(CGRect)rect {
    // color space
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	// get the context
	CGContextRef context = UIGraphicsGetCurrentContext();
	// prepare to set color
	CGContextSetStrokeColorSpace(context, colorSpace);		// this line is necessary, otherwise we fail with stroke color
	// generate a path
	CGContextBeginPath(context);
	
	//----------------draw line------------------//
	// generate line
	CGContextMoveToPoint(context, 100, 50);
	CGContextAddLineToPoint(context, 100, 100);
	// stroke
	CGFloat redColor[4]    = {1.0,0.0,0.0,1.0};
	CGContextSetStrokeColor(context, redColor);
	CGContextSetLineWidth(context, 10);
	CGContextStrokePath(context);
	
	//----------------draw arc------------------//
	// draw an arc
	CGContextMoveToPoint(context, 100, 100);
	CGContextAddArcToPoint(context, 100, 150, 150, 150, 20);
	// stroke	
	CGFloat yellowColor[4]    = {1.0,1.0,0.0,1.0};
	CGContextSetStrokeColor(context, yellowColor);
	CGContextSetLineWidth(context, 4);
	CGContextStrokePath(context);						// this will clear the current path
	
	//----------------draw rect-----------------//
	// draw a rect
	CGContextAddRect(context, CGRectMake(200, 50, 100, 50));
	// fill
	CGFloat blueColor[4] = {0.0,0.0,1.0,1.0};
	CGContextSetFillColor(context, blueColor);
	CGContextFillPath(context);
	
	//----------------draw eclipse--------------//
	// add a eclipse
	CGContextAddEllipseInRect(context, CGRectMake(200, 250, 100, 50));
	// stroke with dashed lines
	float dashLengths[] = {10,5};
	CGContextSetFillColor(context, redColor);
	CGContextSetLineDash(context, 5, dashLengths, 4);
	CGContextStrokePath(context);
	
	//-----------------draw text----------------//
	CGContextSetLineWidth(context, 1);
	CGContextSelectFont(context, "Helvetica", 40, kCGEncodingMacRoman);
	CGContextSetTextDrawingMode (context, kCGTextFillStroke); 
	CGContextSetStrokeColor(context, redColor); 
	CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0));
	CGContextShowTextAtPoint(context, 100,200,[@"Hello!" fileSystemRepresentation], 6);
	
	// release color space
	CGColorSpaceRelease(colorSpace);
}


- (void)dealloc {
    [super dealloc];
}


@end
