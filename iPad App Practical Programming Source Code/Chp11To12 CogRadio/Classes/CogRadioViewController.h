//
//  CogRadioViewController.h
//  CogRadio
//
//  Created by Chen Li on 11/16/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SceneViewController.h"

@class TradViewController, SensingViewController, AccessViewController, InterferenceViewController, GroupViewController, VideoViewController, AboutViewController;

@interface CogRadioViewController : UIViewController <UIScrollViewDelegate,SceneDelegate> {
	NSArray* arrayButtons;
	NSArray* arrayVCs;
	int iVC;						// the viewcontroller currently in view
	
	IBOutlet UIButton* btnTrad;
	IBOutlet UIButton* btnSensing;
	IBOutlet UIButton* btnAccess;
	IBOutlet UIButton* btnInterference;
	IBOutlet UIButton* btnVideo;
	IBOutlet UIButton* btnGroups;
	IBOutlet UIButton* btnAbout;
	
	TradViewController* tradVC;
	SensingViewController* sensingVC;
	AccessViewController* accessVC;
	GroupViewController* groupVC;
	VideoViewController* videoVC;
	AboutViewController* aboutVC;
	
	IBOutlet UIScrollView* scrollView;
}

@property (nonatomic,retain) IBOutlet UIButton* btnTrad;
@property (nonatomic,retain) IBOutlet UIButton* btnSensing;
@property (nonatomic,retain) IBOutlet UIButton* btnAccess;
@property (nonatomic,retain) IBOutlet UIButton* btnVideo;
@property (nonatomic,retain) IBOutlet UIButton* btnGroups;
@property (nonatomic,retain) IBOutlet UIButton* btnAbout;
@property (nonatomic,retain) IBOutlet UIScrollView* scrollView;

-(IBAction) clicked:(UIButton*)sender;

-(void) scrollToViewAtIndex:(int)index;
-(void) createContentsInViewAtIndex:(int)index;
-(void) destroyContentsInViewAtIndex:(int)index;

@end

