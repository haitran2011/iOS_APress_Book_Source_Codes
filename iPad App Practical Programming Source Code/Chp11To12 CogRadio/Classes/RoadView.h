//
//  RoadView.h
//  CogRadio
//
//  Created by Chen Li on 11/18/10.
//  Copyright 2010 Chen Li. All rights reserved.
//
//	This class is used to generate a 800*400's road background, with up to 4 lanes

#import <UIKit/UIKit.h>


@interface RoadView : UIView {
	UIView* backGrndView;
	UIView* upperSolidLine;
	UIView* lowerSolidLine;
	UIImageView* dashline1;
	UIImageView* dashline2;
	UIImageView* dashline3;
	
	UIImageView* iconTV;
	UIImageView* iconAntenna;
	UIImageView* iconPhone;
	UIImageView* iconLaptop;
	
	NSMutableArray* arrayTvImages;
	NSTimer* timer;
	bool lane1Transmitting;
	bool lane2Transmitting;
	bool lane3Transmitting;
	bool crTransmittingOnLane1;
	bool crTransmittingOnLane2;
	bool crTransmittingOnLane3;
}

-(id)initWithNumOfLane:(int)theNumOfLane;
-(void)changeNumOfLane:(int)theNumOfLane;

-(void)startPuTxOnLane:(int)laneNum;
-(void)startCrTx:(int)laneNum;
-(void)moveObj:(UIView*)object forDuration:(float)time;

-(void)timerFired;

-(void)createTV;
-(void)createAntenna;
-(void)createPhone;
-(void)createLaptop:(int)laneNum;

-(void)clearRoad;

@end
