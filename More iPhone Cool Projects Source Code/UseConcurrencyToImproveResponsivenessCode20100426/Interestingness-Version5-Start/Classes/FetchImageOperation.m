//
//  FetchImageOperation.m
//  Interestingness - Version 5
//
//  Created by Danton Chin on 3/29/10.
//  Copyright 2010  http://iphonedeveloperjournal.com/. All rights reserved.
//

#import "FetchImageOperation.h"


@implementation FetchImageOperation

-(id)initWithImageURL:(NSURL *)url target:(id)targClass targetMethod:(SEL)targClassMethod
{
	if (self = [super init]) {
		imageURL = [url retain];
		targetObject = targClass;
		targetMethod = targClassMethod;
	}
	return self;
}

-(void)main
{
	NSAutoreleasePool *localPool;
	
	@try {
		// create the autorelease pool
		localPool  = [[NSAutoreleasePool alloc] init];
		
		// see if we have been cancelled
		
		if ([self isCancelled]) return;
		
		// fetch the image
		
		NSData	*imageData	= [[NSData alloc] initWithContentsOfURL:imageURL];
		
		// create the image from the image data
		
		UIImage *image		= [[UIImage alloc] initWithData:imageData];
		
		// store the image and url in a dictionary to return
		
		NSDictionary *result = [[NSDictionary alloc] initWithObjectsAndKeys:image,@"image",imageURL,@"url",nil];
		
		// send it back

		[targetObject performSelectorOnMainThread:targetMethod withObject:result waitUntilDone:NO];
		
		[imageData release];
		
		[image release];
		
		[result release];
	}
	@catch (NSException * exception) {
		// log exception
		NSLog(@"Exception: %@", [exception reason]);
	}
	@finally {
		[localPool release];
	}
}
  
-(void)dealloc
{
	[imageURL release];
	[super dealloc];
}
@end
