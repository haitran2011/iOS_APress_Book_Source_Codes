//
//  InterestingnessAppDelegate.h
//  Interestingness - Version 3
//
//  Created by Danton Chin on 3/24/10.
//  Copyright  http://iphonedeveloperjournal.com/ 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InterestingnessTableViewController;

@interface InterestingnessAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	InterestingnessTableViewController *tableViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end

