//
//  JobUnit.m
//  HelloOperationQueues
//
//  Created by Danton Chin on 3/29/10.
//  Copyright 2010  http://iphonedeveloperjournal.com/. All rights reserved.
//

#import "JobUnit.h"


@implementation JobUnit
@synthesize workMsg;

-(id)initWithMsg:(NSString *)msg dependency:(id)obj
{
	if ( self = [super init]) {
		[self setWorkMsg:msg];
		
		if (obj != nil) {
			//
			[self addDependency:obj];
		}
		
		
	}
	return self;
}

-(void)main
{
	/*
	 *		create an autorelease pool for objects released
	 *			during a long running task
	 */
	
	NSAutoreleasePool *localPool;
	
	@try {
		
		localPool = [[NSAutoreleasePool alloc] init];
		
		/*
		 *	check if operation has been cancelled
		 */
		
		if ([self isCancelled]) return;
		
		/*
		 *		perform a long running task
		 */
		
		NSLog(@"performing work for %@", [self workMsg]);
		
	}
	@catch (NSException * e) {
		// handle the exception but do not rethrow the exception
	}
	@finally {
		[localPool release];

	}
	
	
	
}

-(void)dealloc
{
	
	[workMsg release];
	
	[super dealloc];
}

@end
