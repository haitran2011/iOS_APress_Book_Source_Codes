//
//  MapAppAppDelegate.h
//  MapApp
//
//  Created by Chen Li on 1/2/11.
//  Copyright 2011 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MapAppViewController;

@interface MapAppAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MapAppViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MapAppViewController *viewController;

@end

