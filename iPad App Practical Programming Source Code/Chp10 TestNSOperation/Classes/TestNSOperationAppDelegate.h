//
//  TestNSOperationAppDelegate.h
//  TestNSOperation
//
//  Created by Chen Li on 10/7/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TestNSOperationViewController;

@interface TestNSOperationAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TestNSOperationViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TestNSOperationViewController *viewController;

@end

