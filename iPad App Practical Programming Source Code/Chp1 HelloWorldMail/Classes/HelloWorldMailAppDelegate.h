//
//  HelloWorldMailAppDelegate.h
//  HelloWorldMail
//
//  Created by Chen Li on 8/1/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelloWorldMailViewController;

@interface HelloWorldMailAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HelloWorldMailViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HelloWorldMailViewController *viewController;

@end

