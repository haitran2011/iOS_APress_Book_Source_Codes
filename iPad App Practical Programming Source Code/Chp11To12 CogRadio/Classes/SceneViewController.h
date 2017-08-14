//
//  SceneViewController.h
//  CogRadio
//
//  Created by Chen Li on 11/17/10.
//  Copyright 2010 Chen Li. All rights reserved.
//
//	This is a super class of all the scene classes.

#import <UIKit/UIKit.h>
#import "Definitions.h"

// This is the super class for the scene vc's. 
// Another super class, SceneWithRoadsViewController will subclass this one. 

@protocol SceneDelegate

-(void)finishedScene:(id)scene;

@end


@interface SceneViewController : UIViewController {
	bool contentsCreated;
	
	UIView* bkColorView;		// there's a bug with direct applying background color to the view, so we use a subview
	UITextView* textHead;		// on top of the scene, used to display shorter messages
	UITextView* textView;		// in the middle of the scene, used to display longer messages
	UIButton* button;
	
	id delegate;				// Using id is very generic, but also dangerous; using id<SceneDelegate> would be better. 
}

@property bool contentsCreated;
@property (assign) id delegate;

-(void)createContents;
-(void)destroyContents;
-(void)sceneFinished;

@end