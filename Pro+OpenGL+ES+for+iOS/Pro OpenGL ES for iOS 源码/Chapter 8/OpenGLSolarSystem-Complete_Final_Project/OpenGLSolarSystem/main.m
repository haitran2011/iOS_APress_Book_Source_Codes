//
//  main.m
//  BouncySquare
//
//  Created by mike on 9/10/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OpenGLSolarSystemAppDelegate.h"

int main(int argc, char *argv[])
{
    NSException *exception2;
    
    @try
	{
        @autoreleasepool 
        {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([OpenGLSolarSystemAppDelegate class]));
        }
	}
	@catch(NSException *exception)
	{
		exception2=exception;
        
        NSLog(@"Crash! %@",exception2.reason);		
	}
}
