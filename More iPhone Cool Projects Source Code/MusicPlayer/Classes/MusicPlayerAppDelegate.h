//
//  MusicPlayerAppDelegate.h
//  MusicPlayer
//
//  Created by Saul Mora on 4/22/10.
//  Copyright Magical Panda Software, LLC 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MusicPlayerViewController;

@interface MusicPlayerAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    MusicPlayerViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MusicPlayerViewController *viewController;

@end

