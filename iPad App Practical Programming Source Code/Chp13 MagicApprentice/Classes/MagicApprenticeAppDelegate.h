//
//  MagicApprenticeAppDelegate.h
//  MagicApprentice
//
//  Created by Chen Li on 12/4/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RootViewController;

@interface MagicApprenticeAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
