//
//  Sub.m
//  TestNSOperation
//
//  Created by Chen Li on 10/7/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "Sub.h"


@implementation Sub

@synthesize numberToPrint;

// A simple task: print numberToPrint 1000 times. 
-(void) main {
	for (int i=0; i<1000; i++) {
		NSLog(@"%d",numberToPrint);
	}
}

@end
