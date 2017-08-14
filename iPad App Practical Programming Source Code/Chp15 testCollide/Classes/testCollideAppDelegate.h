//
//  testCollideAppDelegate.h
//  testCollide
//
//  Created by Chen Li on 12/12/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface testCollideAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
