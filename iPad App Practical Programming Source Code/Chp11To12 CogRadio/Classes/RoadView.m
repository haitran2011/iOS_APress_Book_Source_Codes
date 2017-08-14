//
//  RoadView.m
//  CogRadio
//
//  Created by Chen Li on 11/18/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "RoadView.h"
#import "Definitions.h"

const int RoadViewWidth = 800;
const int RoadViewLaneHeight = 100;

@implementation RoadView

-(id)initWithNumOfLane:(int)theNumOfLane {
	if ((self = [super initWithFrame:CGRectMake(0, 0, RoadViewWidth, RoadViewLaneHeight*3)])) {
		backGrndView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RoadViewWidth, RoadViewLaneHeight)];
		backGrndView.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];		// light grey background color
		[self addSubview:backGrndView];
		
		// dolid lines
		upperSolidLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RoadViewWidth, 10)];
		upperSolidLine.backgroundColor = [UIColor whiteColor];
		lowerSolidLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, RoadViewWidth, 10)];
		lowerSolidLine.backgroundColor = [UIColor whiteColor];
		
		// add the upper solid line
		[self addSubview:upperSolidLine];
		// add the dash lines and the lower solid line
		[self changeNumOfLane:theNumOfLane];
		
		timer = [NSTimer scheduledTimerWithTimeInterval:1.8 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
		lane1Transmitting = NO;
		lane2Transmitting = NO;
		lane3Transmitting = NO;
		crTransmittingOnLane1 = NO;
		crTransmittingOnLane2 = NO;
		crTransmittingOnLane3 = NO;	
	}
	return self;
}

-(void)changeNumOfLane:(int)theNumOfLane {
	// remove all the lines, except for upperSolidLine
	[dashline1 removeFromSuperview];
	[dashline2 removeFromSuperview];
	[dashline3 removeFromSuperview];
	[lowerSolidLine removeFromSuperview];
	
	// resize the view
	backGrndView.frame = CGRectMake(0, 0, RoadViewWidth, RoadViewLaneHeight*theNumOfLane);
	//self.center = CGPointMake(SceneWidth/2, SceneHeight/2);
	
	// add the needed lines back
	switch (theNumOfLane) {
		case 1:
			lowerSolidLine.center = CGPointMake(RoadViewWidth/2, 100);
			[self addSubview:lowerSolidLine];
			if (!iconTV)
				iconTV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picTV.png"]];
			CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
			iconTV.transform = transform;
			iconTV.center = CGPointMake(RoadViewWidth-50, 50);
			[self addSubview:iconTV];
			break;
		case 2:
			if (!dashline1)
				dashline1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picDashLane.png"]];
			dashline1.center = CGPointMake(RoadViewWidth/2, 100);
			[self addSubview:dashline1];
			lowerSolidLine.center = CGPointMake(RoadViewWidth/2, 200);
			[self addSubview:lowerSolidLine];
			if (!iconAntenna)
				iconAntenna = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picAntenna.png"]];
			transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
			iconAntenna.transform = transform;
			iconAntenna.center = CGPointMake(RoadViewWidth-50, 150);
			[self addSubview:iconAntenna];
			break;
		case 3:
			NSLog(@"aaa");
			if (!dashline1)
				dashline1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picDashLane.png"]];
			dashline1.center = CGPointMake(RoadViewWidth/2, 100);
			if (!dashline2)
				dashline2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picDashLane.png"]];
			dashline2.center = CGPointMake(RoadViewWidth/2, 200);
			[self addSubview:dashline1];
			[self addSubview:dashline2];
			lowerSolidLine.center = CGPointMake(RoadViewWidth/2, 300);
			[self addSubview:lowerSolidLine];
			if (!iconAntenna)
				iconAntenna = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picAntenna.png"]];
			transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
			iconAntenna.transform = transform;
			iconAntenna.center = CGPointMake(RoadViewWidth-50, 150);
			[self addSubview:iconAntenna];
			if (!iconPhone)
				iconPhone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picPhone.png"]];
			transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.75, 0.75);
			iconPhone.transform = transform;
			iconPhone.center = CGPointMake(RoadViewWidth-50, 250);
			[self addSubview:iconPhone];
			break;
		default:
			break;
	}
}

-(void)startPuTxOnLane:(int)laneNum {
	switch (laneNum) {
		case 1: {			// the bracket is important, otherwise we can't declare variables inside the switch-case
			NSLog(@"PU tx on lane 1");
			if (!arrayTvImages) {
				arrayTvImages = [[NSMutableArray alloc] init];
				for (int i=1; i<=12; i++) {
					NSString* picName = [NSString stringWithFormat:@"picTVcar%d.png",i];
					[arrayTvImages addObject:[UIImage imageNamed:picName]];
				}
			}
			lane1Transmitting = YES;
			break;
		}
		case 2: {			// the bracket is important, otherwise we can't declare variables inside the switch-case
			NSLog(@"PU tx on lane 2");
			lane2Transmitting = YES;
			break;
		}
		case 3: {			// the bracket is important, otherwise we can't declare variables inside the switch-case
			NSLog(@"PU tx on lane 3");
			lane3Transmitting = YES;
			break;
		}
		default:
			break;
	}
}

-(void)startCrTx:(int)laneNum {
	NSLog(@"startCrTx:%d",laneNum);
	switch (laneNum) {
		case 1:
			crTransmittingOnLane1 = YES;
			break;
		case 2:
			crTransmittingOnLane2 = YES;
			break;
		case 3:
			crTransmittingOnLane3 = YES;
			break;
		default:
			break;
	}
}

-(void)moveObj:(UIView*)object forDuration:(float)time {
	// calculate new center
	CGPoint newCenter = CGPointMake(RoadViewWidth-120, object.center.y);
	
	// animation
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:time];
	object.center = newCenter;
	[UIView commitAnimations];
	
	// fade after a certain time delay
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelay:(time-1)];
	[UIView setAnimationDuration:1.3];
	object.alpha = 0.0;
	[UIView commitAnimations];
	
}

-(void)timerFired {
	NSLog(@"timerFired");
	if (lane1Transmitting) {
		if (genRandomNum()<probPuLane1) {
			[self createTV];
		}
		else if (crTransmittingOnLane1) {
			[self createLaptop:1];
		}
	}
	if (lane2Transmitting) {
		if (genRandomNum()<probPuLane2) {
			[self createAntenna];
		}
		else if (crTransmittingOnLane2) {
			[self createLaptop:2];
		}
	}
	if (lane3Transmitting) {
		if (genRandomNum()<probPuLane3) {
			[self createPhone];
		}
		else if (crTransmittingOnLane3) {
			[self createLaptop:3];
		}
	}
}

-(void)createTV {
	UIImageView* imageTV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
	imageTV.animationImages = arrayTvImages;
	imageTV.animationDuration = 1.0;
	CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
	imageTV.transform = transform;
	imageTV.center = CGPointMake(50, 50);
	[self addSubview:imageTV];
	[imageTV startAnimating];		// without this line, you can't see any image
	[self moveObj:imageTV forDuration:8.0];
	[imageTV release];
}

-(void)createAntenna {
	UIImageView* imageAntenna = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picAntenna.png"]];
	CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
	imageAntenna.transform = transform;
	imageAntenna.center = CGPointMake(50, 150);
	[self addSubview:imageAntenna];
	[self moveObj:imageAntenna forDuration:8.0];
	[imageAntenna release];
}

-(void)createPhone {
	UIImageView* imagePhone = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picPhone.png"]];
	CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
	imagePhone.transform = transform;
	imagePhone.center = CGPointMake(50, 250);
	[self addSubview:imagePhone];
	[self moveObj:imagePhone forDuration:8.0];
	[imagePhone release];
}

-(void)createLaptop:(int)laneNum {
	UIImageView* imageLaptop = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picLaptop.png"]];
	CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.6, 0.6);
	imageLaptop.transform = transform;
	imageLaptop.center = CGPointMake(50, 250);
	if (laneNum==1) {
		imageLaptop.center = CGPointMake(50, 50);
	}
	else if (laneNum==2) {
		imageLaptop.center = CGPointMake(50, 150);
	}
	else if (laneNum==3) {
		imageLaptop.center = CGPointMake(50, 250);
	}
	[self addSubview:imageLaptop];
	[self moveObj:imageLaptop forDuration:8.0];
	[imageLaptop release];
}

-(void)clearRoad {
	lane1Transmitting = NO;
	lane2Transmitting = NO;
	lane3Transmitting = NO;
	crTransmittingOnLane1 = NO;
	crTransmittingOnLane2 = NO;
	crTransmittingOnLane3 = NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)dealloc {
	[backGrndView release];
	[upperSolidLine release];
	[lowerSolidLine release];
	[dashline1 release];
	[dashline2 release];
	[dashline3 release];
	[iconTV release];
	[iconAntenna release];
	[iconPhone release];
	[iconLaptop release];
	[arrayTvImages release];
	[timer invalidate];
    [super dealloc];
}


@end
