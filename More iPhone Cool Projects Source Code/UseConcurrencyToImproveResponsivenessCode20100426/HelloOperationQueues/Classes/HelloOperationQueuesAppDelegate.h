//
//  HelloOperationQueuesAppDelegate.h
//  HelloOperationQueues
//
//  Created by Danton Chin on 3/28/10.
//  Copyright  http://iphonedeveloperjournal.com/ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HelloOperationQueuesViewController;

@interface HelloOperationQueuesAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    HelloOperationQueuesViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet HelloOperationQueuesViewController *viewController;

@end

