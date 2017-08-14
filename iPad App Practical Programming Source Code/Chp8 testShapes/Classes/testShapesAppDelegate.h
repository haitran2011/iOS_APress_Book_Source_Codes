//
//  testShapesAppDelegate.h
//  testShapes
//
//  Created by Chen Li on 10/10/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class testShapesViewController;

@interface testShapesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    testShapesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet testShapesViewController *viewController;

@end

