//
//  APChar.m
//  FortuneCookie
//
//  Created by Scott Penberthy on 2/7/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "APChar.h"

@implementation APChar

@synthesize r,g,b,a,width,height,baseline,minU,minV,maxU,maxV,x,y;

- (id) init
{
	self = [super init];
	if (self != nil) {
		width = height = baseline = x = y = 0.0;
	}
	return self;
}

@end

