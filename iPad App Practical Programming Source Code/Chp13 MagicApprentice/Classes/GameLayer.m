//
//  GameLayer.m
//  MagicApprentice
//
//  Created by Chen Li on 12/4/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "GameLayer.h"
#import "GameConfig.h"

@implementation GameLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	// This method will call the init method below
	GameLayer* layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
//		// create and initialize a Label
//		CCLabelTTF *label = [CCLabelTTF labelWithString:@"GameLayer" fontName:@"Marker Felt" fontSize:25];
//		// ask director the the window size
//		CGSize size = [[CCDirector sharedDirector] winSize];
//		// position the label on the center of the screen
//		label.position =  ccp( 900 , 700 );
//		// add the label as a child to this Layer
//		[self addChild: label];

		self.isTouchEnabled = YES;
		arrPSystems = [[NSMutableArray alloc] init];
		
		// init allTouchesOnScreen if it's not initialized yet
		if (!arrAllTouches) {
			arrAllTouches = [[NSMutableArray alloc] init];
		}
		
		// start displaying particles
		[self handle1Finger];
		// show infoSprite
		[self showInfoSprite];
	}
	return self;
}

// update the particle systems, in response to the change in touches
-(void) updateParticleSystems {
	//NSLog(@"updateParticleSystems");
	
	// get number of touches on the screen
	int numOfFingersOnScreen = [arrAllTouches count];
	NSLog(@"numOfFingers: %d",numOfFingersOnScreen);
	
	// if single tap on the following region, the infoSprite will show up
	CGRect rectBL = CGRectMake(0, 0, TapRectWidth, TapRectHeight);
	CGRect rectBR = CGRectMake(1024-TapRectWidth, 0, TapRectWidth, TapRectHeight);
	CGRect rectTL = CGRectMake(0, 768-TapRectHeight, TapRectWidth, TapRectHeight);
	CGRect rectTR = CGRectMake(1024-TapRectWidth, 768-TapRectHeight, TapRectWidth, TapRectHeight);
	
	// go to specific event handler according to the numOfFingersOnScreen
	switch (numOfFingersOnScreen) {
		case 0:
			[self handle1Finger];
			break;
		case 1: {
			CGPoint pos = [self posFromTouch:[arrAllTouches objectAtIndex:0]];
			if (CGRectContainsPoint(rectBL, pos)||CGRectContainsPoint(rectBR, pos)||CGRectContainsPoint(rectTL, pos)||CGRectContainsPoint(rectTR, pos)) {
				[self showInfoSprite];
			}
			else {
				[self handle1Finger];
			}
			break;
		}
		case 2:
			[self handle2Finger];
			break;
		case 3:
			[self handle3Finger];
			break;
		case 4:
			[self handle4Finger];
			break;
		case 5:
			[self handle5Finger];
			break;
		case 6:
			[self handle6Finger];
			break;
		case 7:
			[self handle7Finger];
			break;
		case 8:
			[self handle8Finger];
			break;
		case 9:
			[self handle9Finger];
			break;
		case 10:
			[self handle10Finger];
			break;
		default:
			break;
	}
}

// re-position the particle systems, in response to the move of touches
-(void) posParticleSystems {
	//NSLog(@"posParticleSystems");
	
	// get number of touches on the screen
	int numOfFingersOnScreen = [arrAllTouches count];
	NSLog(@"numOfFingers: %d",numOfFingersOnScreen);
	
	// go to specific event handler according to the numOfFingersOnScreen
	switch (numOfFingersOnScreen) {
		case 1:
			[self pos1Finger];
			break;
		case 2:
			[self pos2Finger];
			break;
		case 3:
			[self pos3Finger];
			break;
		case 4:
			[self pos4Finger];
			break;
		case 5:
			[self pos5Finger];
			break;
		case 6:
			[self pos6Finger];
			break;
		case 7:
			[self pos7Finger];
			break;
		case 8:
			[self pos8Finger];
			break;
		case 9:
			[self pos9Finger];
			break;
		case 10:
			[self pos10Finger];
			break;
		default:
			break;
	}
}

// the [touches count] is very sensitive to timing
-(void) ccTouchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	NSLog(@"ccTouchesBegan");
	
	// add the new touch into allTouchesOnScreen
	[arrAllTouches addObjectsFromArray:[touches allObjects]];

	// update particle systems
	[self updateParticleSystems];
}

-(void) ccTouchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	[self posParticleSystems];
}

-(void) ccTouchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	[arrAllTouches removeObjectsInArray:[touches allObjects]];
	
	// update particle systems
	[self updateParticleSystems];
}

// bring up infoSprite
-(void) showInfoSprite {
	NSLog(@"showInfoSprite");
	if (!infoSprite) {
		infoSprite = [[CCSprite alloc] initWithFile:@"picInfoSprite.png"];
		
		CCLabelTTF* label = [CCLabelTTF labelWithString:@"Touch the screen with your fingers for magic; touch any corner to bring this menu back. "\
										 fontName:@"Arial"\
										 fontSize:22.0];
		label.position = ccp(512,40);
		[infoSprite addChild:label];
		
		[CCMenuItemFont setFontSize:20];
		CCMenuItemFont *exitButton = [CCMenuItemFont itemFromString:@"Exit" target:self selector:@selector(hideInfoSprite)];
		exitButton.position = ccp(60,80);
		CCMenu* menu = [CCMenu menuWithItems:exitButton,nil];
		menu.position = CGPointZero;
		[infoSprite addChild:menu];
		
		infoSprite.position = ccp(512,-60);
		[self addChild:infoSprite];
	}
	
	id actionMoveUp = [CCMoveTo actionWithDuration:0.5 position:ccp(512,60)];
	[infoSprite runAction:actionMoveUp];
}

// bring down infoSprite
-(void) hideInfoSprite {
	NSLog(@"hideInfoSprite");
	
	id actionMoveDown = [CCMoveTo actionWithDuration:0.5 position:ccp(512,-60)];
	[infoSprite runAction:actionMoveDown];
}

// return the positions for a set of touches
-(CGPoint) posFromTouch:(UITouch*)touch {
	CGPoint location = [touch locationInView: [touch view]];
	CGPoint convertedLocation = [[CCDirector sharedDirector] convertToGL:location];
	
	return convertedLocation;
}

// stop and remove unnecessary particle systems, reset and add nucessary particle systems
-(void) addAndRemoveSystemsForNeceSystems:(NSArray*)neceSystems {
	for (id pSystem in arrPSystems) {
		// find unnecessary particle systems
		if (![neceSystems containsObject:pSystem]) {
			// if it's active, stop and remove
			if ([pSystem active]) {
				[pSystem stopSystem];
				//[self removeChild:pSystem cleanup:NO];
			}
		}
		// find necessary particle systems
		else {
			// if it's not active, reset and add
			if (![pSystem active]) {
				[pSystem resetSystem];
			}
			if (![[self children] containsObject:pSystem]) {
				[self addChild:pSystem];
			}
		}
	}
}

// find centroid of an array of touches
-(CGPoint) centroidOfArrTouches:(NSMutableArray*)anArray {
	float cumulativeX,cumulativeY;
	cumulativeX = 0;
	cumulativeY = 0;
	for (UITouch* touch in anArray) {
		CGPoint point = [self posFromTouch:touch];
		cumulativeX += point.x;
		cumulativeY += point.y;
	}
	
	CGPoint centroid = ccpMult(ccp(cumulativeX,cumulativeY), 1.0/[anArray count]);
	return centroid;
}

// find the x range
-(float) xRangeOfArrTouches:(NSMutableArray*)anArray {
	float minX = 1024;
	float maxX = 0;
	
	for (UITouch* touch in anArray) {
		CGPoint point = [self posFromTouch:touch];
		if (point.x<minX) {
			minX = point.x;
		}
		if (point.x>maxX) {
			maxX = point.x;
		}
	}
	
	return maxX-minX;
}

// find the y range
-(float) yRangeOfArrTouches:(NSMutableArray*)anArray {
	float minY = 768;
	float maxY = 0;
	
	for (UITouch* touch in anArray) {
		CGPoint point = [self posFromTouch:touch];
		if (point.y<minY) {
			minY = point.y;
		}
		if (point.y>maxY) {
			maxY = point.y;
		}
	}
	
	return maxY-minY;
}

// handle different number of fingers on the screen
-(void) handle1Finger {
	
	// init and change settings of necessary particle systems
	if (!pDream) {
		NSLog(@"init pDream");
		pDream = [CCParticleFlower node];
		[arrPSystems addObject:pDream];
		pDream.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars.png"];
		pDream.totalParticles = 200;
		[pDream stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pDream,nil];
	pDream.speed = 200;
	pDream.speedVar = 40;
	pDream.startSize = 45;
	pDream.startSizeVar = 15;
	pDream.radialAccel = -120;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos1Finger];
}

-(void) pos1Finger {
	if ([arrAllTouches count]>0) {
		pDream.position = [self posFromTouch:[arrAllTouches objectAtIndex:0]];
	}
}

-(void) handle2Finger {
	
	// init necessary particle systems
	if (!pDream) {
		NSLog(@"init pDream");
		pDream = [CCParticleFlower node];
		[arrPSystems addObject:pDream];
		pDream.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars.png"];
		pDream.totalParticles = 200;
		[pDream stopSystem];
	}
	if (!pGalaxy) {
		NSLog(@"init pGalaxy");
		pGalaxy = [CCParticleGalaxy node];
		[arrPSystems addObject:pGalaxy];
		pGalaxy.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"];
		pGalaxy.totalParticles = 200;
		[pGalaxy stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pDream,pGalaxy,nil];
	pDream.speed = 200;
	pDream.speedVar = 40;
	pDream.startSize = 45;
	pDream.startSizeVar = 15;
	pDream.radialAccel = -120;
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	pGalaxy.startColor = startColor;
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	pGalaxy.startColorVar = startColorVar;
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	pGalaxy.endColor = endColor;
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	pGalaxy.endColorVar = endColorVar;
	pGalaxy.startSize = 60.0f;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos2Finger];
}

-(void) pos2Finger {
	pDream.position = [self posFromTouch:[arrAllTouches objectAtIndex:0]];
	pGalaxy.position = [self posFromTouch:[arrAllTouches objectAtIndex:1]];
}

-(void) handle3Finger {
	// init necessary particle systems
	if (!pMeteor1) {
		NSLog(@"init pGalaxy1");
		pMeteor1 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor1];
		pMeteor1.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor1 stopSystem];
	}
	if (!pMeteor2) {
		NSLog(@"init pGalaxy2");
		pMeteor2 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor2];
		pMeteor2.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor2 stopSystem];
	}
	if (!pMeteor3) {
		NSLog(@"init pGalaxy3");
		pMeteor3 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor3];
		pMeteor3.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor3 stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pMeteor1,pMeteor2,pMeteor3,nil];
	ccColor4F colorVar = {0.1,0.1,0.1,1.0};
	pMeteor1.speedVar = 40;
	pMeteor1.startSize = 20;
	pMeteor1.startSizeVar = 8;
	pMeteor1.startColor = genRandomColor();
	pMeteor1.startColorVar = colorVar;
	pMeteor1.endColor = genRandomColor();	
	pMeteor1.endColorVar = colorVar;
	pMeteor2.speedVar = 40;
	pMeteor2.startSize = 20;
	pMeteor2.startSizeVar = 8;
	pMeteor2.startColor = genRandomColor();
	pMeteor2.startColorVar = colorVar;
	pMeteor2.endColor = genRandomColor();	
	pMeteor2.endColorVar = colorVar;
	pMeteor3.speedVar = 40;
	pMeteor3.startSize = 20;
	pMeteor3.startSizeVar = 8;
	pMeteor3.startColor = genRandomColor();
	pMeteor3.startColorVar = colorVar;
	pMeteor3.endColor = genRandomColor();	
	pMeteor3.endColorVar = colorVar;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos2Finger];
}

-(void) pos3Finger {
	CGPoint point1 = [self posFromTouch:[arrAllTouches objectAtIndex:0]];
	CGPoint point2 = [self posFromTouch:[arrAllTouches objectAtIndex:1]];
	CGPoint point3 = [self posFromTouch:[arrAllTouches objectAtIndex:2]];
	pMeteor1.position = point1;
	pMeteor1.gravity = ccpSub(point2, point1);
	pMeteor2.position = point2;
	pMeteor2.gravity = ccpSub(point3, point2);
	pMeteor3.position = point3;
	pMeteor3.gravity = ccpSub(point1, point3);
}

-(void) handle4Finger {
	
	// init necessary particle systems
	if (!pFire) {
		NSLog(@"init pFire");
		pFire = [CCParticleFire node];
		[arrPSystems addObject:pFire];
		pFire.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"];
		[pFire stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pFire,nil];
	pFire.startSize = 57;
	pFire.startSizeVar = 9;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos4Finger];
}

-(void) pos4Finger {
	CGPoint centroid = [self centroidOfArrTouches:arrAllTouches];
	float xRangePlusYRange = [self xRangeOfArrTouches:arrAllTouches]+[self yRangeOfArrTouches:arrAllTouches];
	
	// modify position of the fire
	pFire.position = centroid;
	
	// modify color of the fire
	float blueComponent = xRangePlusYRange/1700;
	if (blueComponent>0.7) {
		blueComponent=0.7;
	}
	if (blueComponent<0.3) {
		blueComponent=0.3;
	}
	ccColor4F startColor = {0.76,0.25,0.12+blueComponent*0.1,1.0};
	ccColor4F endColor = {0.0,0.0,blueComponent,0.8};
	pFire.startColor = startColor;
	pFire.endColor = endColor;
}

-(void) handle5Finger {
	// init necessary particle systems
	if (!pMeteor1) {
		NSLog(@"init pGalaxy1");
		pMeteor1 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor1];
		pMeteor1.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor1 stopSystem];
	}
	if (!pMeteor2) {
		NSLog(@"init pGalaxy2");
		pMeteor2 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor2];
		pMeteor2.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor2 stopSystem];
	}
	if (!pMeteor3) {
		NSLog(@"init pGalaxy3");
		pMeteor3 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor3];
		pMeteor3.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor3 stopSystem];
	}
	if (!pMeteor4) {
		NSLog(@"init pGalaxy4");
		pMeteor4 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor4];
		pMeteor4.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor4 stopSystem];
	}
	if (!pMeteor5) {
		NSLog(@"init pMeteor5");
		pMeteor5 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor5];
		pMeteor5.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor5 stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pMeteor1,pMeteor2,pMeteor3,pMeteor4,pMeteor5,nil];
	ccColor4F colorVar = {0.1,0.1,0.1,1.0};
	pMeteor1.speedVar = 40;
	pMeteor1.startSize = 20;
	pMeteor1.startSizeVar = 8;
	pMeteor1.startColor = genRandomColor();
	pMeteor1.startColorVar = colorVar;
	pMeteor1.endColor = genRandomColor();	
	pMeteor1.endColorVar = colorVar;
	pMeteor1.gravity = ccp(0,200);
	pMeteor2.speedVar = 40;
	pMeteor2.startSize = 20;
	pMeteor2.startSizeVar = 8;
	pMeteor2.life = 3;
	pMeteor2.startColor = genRandomColor();
	pMeteor2.startColorVar = colorVar;
	pMeteor2.endColor = genRandomColor();	
	pMeteor2.endColorVar = colorVar;
	pMeteor2.gravity = ccp(0,200);
	pMeteor3.speedVar = 40;
	pMeteor3.startSize = 30;
	pMeteor3.startSizeVar = 12;
	pMeteor3.life = 3;
	pMeteor3.startColor = genRandomColor();
	pMeteor3.startColorVar = colorVar;
	pMeteor3.endColor = genRandomColor();	
	pMeteor3.endColorVar = colorVar;
	pMeteor3.gravity = ccp(0,200);
	pMeteor4.speedVar = 40;
	pMeteor4.startSize = 30;
	pMeteor4.startSizeVar = 12;
	pMeteor4.life = 3;
	pMeteor4.startColor = genRandomColor();
	pMeteor4.startColorVar = colorVar;
	pMeteor4.endColor = genRandomColor();	
	pMeteor4.endColorVar = colorVar;
	pMeteor4.gravity = ccp(0,200);
	pMeteor5.speedVar = 40;
	pMeteor5.startSize = 20;
	pMeteor5.startSizeVar = 8;
	pMeteor5.startColor = genRandomColor();
	pMeteor5.startColorVar = colorVar;
	pMeteor5.endColor = genRandomColor();	
	pMeteor5.endColorVar = colorVar;
	pMeteor5.gravity = ccp(0,200);
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos5Finger];
}

-(void) pos5Finger {
	pMeteor1.position = [self posFromTouch:[arrAllTouches objectAtIndex:0]];
	pMeteor2.position = [self posFromTouch:[arrAllTouches objectAtIndex:1]];
	pMeteor3.position = [self posFromTouch:[arrAllTouches objectAtIndex:2]];
	pMeteor4.position = [self posFromTouch:[arrAllTouches objectAtIndex:3]];
	pMeteor5.position = [self posFromTouch:[arrAllTouches objectAtIndex:4]];
}

-(void) handle6Finger {
	// init necessary particle systems
	if (!pQuad) {
		NSLog(@"init pQuad");
		pQuad = [[[CCParticleSystemQuad alloc] initWithTotalParticles:400] autorelease];
		[arrPSystems addObject:pQuad];
		pQuad.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pQuad stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pQuad,nil];
	pQuad.duration = -1;
	pQuad.gravity = CGPointZero;
	pQuad.angle = 90;
	pQuad.angleVar = 360;
	pQuad.speed = 160;
	pQuad.speedVar = 20;
	pQuad.radialAccel = -120;
	pQuad.radialAccelVar = 0;
	pQuad.tangentialAccel = 30;
	pQuad.tangentialAccelVar = 0;
	pQuad.posVar = CGPointZero;
	pQuad.life = 3;
	pQuad.lifeVar = 1;
	pQuad.startSpin = 0;
	pQuad.startSpinVar = 0;
	pQuad.endSpin = 0;
	pQuad.endSpinVar = 2000;
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	pQuad.startColor = startColor;
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	pQuad.startColorVar = startColorVar;
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	pQuad.endColor = endColor;
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	pQuad.endColorVar = endColorVar;
	pQuad.startSize = 23.0f;
	pQuad.startSizeVar = 15.0f;
	pQuad.endSize = kParticleStartSizeEqualToEndSize;
	pQuad.emissionRate = pQuad.totalParticles/pQuad.life;
	pQuad.blendAdditive = NO;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos6Finger];
}

-(void) pos6Finger {
	pQuad.position = [self centroidOfArrTouches:arrAllTouches];
	
	float xRangePlusYRange = [self xRangeOfArrTouches:arrAllTouches]+[self yRangeOfArrTouches:arrAllTouches];
	float speedScale = xRangePlusYRange/900.0;
	if (speedScale<1.0) {
		speedScale = 1.0;
	}
	if (speedScale>1.7) {
		speedScale = 1.7;
	}
	pQuad.speed = speedScale*160;
}

-(void) handle7Finger {
	// init necessary particle systems
	if (!pRain) {
		NSLog(@"init pRain");
		pRain = [CCParticleRain node];
		[arrPSystems addObject:pRain];
		pRain.texture = [[CCTextureCache sharedTextureCache] addImage: @"coin2.png"];
		[pRain stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pRain,nil];
	pRain.life = 12;
	pRain.speed = 80;
	pRain.startSize = 20;
	pRain.startSizeVar = 13;
	ccColor4F startColorVar = {0.5,0.5,0.5,1.0};
	pRain.startColorVar = startColorVar;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos7Finger];
}

-(void) pos7Finger {
	pRain.position = [self centroidOfArrTouches:arrAllTouches];
	pRain.posVar = ccp([self xRangeOfArrTouches:arrAllTouches]/2,30);
	pRain.speed = [self yRangeOfArrTouches:arrAllTouches]/6.0;
}

-(void) handle8Finger {
	// init necessary particle systems
	if (!pPoint) {
		NSLog(@"init pPoint");
		pPoint = [[[CCParticleSystemPoint alloc] initWithTotalParticles:1000] autorelease];
		[arrPSystems addObject:pPoint];
		[pPoint stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pPoint,nil];// duration
	pPoint.duration = -1;
	pPoint.gravity = ccp(0,0);
	pPoint.angle = 0;
	pPoint.angleVar = 360;
	pPoint.radialAccel = 70;
	pPoint.radialAccelVar = 10;
	pPoint.tangentialAccel = 80;
	pPoint.tangentialAccelVar = 0;
	pPoint.speed = 50;
	pPoint.speedVar = 10;
	pPoint.posVar = CGPointZero;
	pPoint.life = 2.0f;
	pPoint.lifeVar = 0.3f;
	pPoint.emissionRate = pPoint.totalParticles/pPoint.life;
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	pPoint.startColor = startColor;
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	pPoint.startColorVar = startColorVar;
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	pPoint.endColor = endColor;
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	pPoint.endColorVar = endColorVar;
	pPoint.startSize = 1.0f;
	pPoint.startSizeVar = 1.0f;
	pPoint.endSize = 30.0f;
	pPoint.endSizeVar = 12.0f;
	
	// texture
	//	emitter.texture = [[CCTextureCache sharedTextureCache] addImage:@"fire.png"];
	
	// additive
	pPoint.blendAdditive = NO;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos8Finger];
}

-(void) pos8Finger {
	pPoint.position = [self centroidOfArrTouches:arrAllTouches];
}

-(void) handle9Finger {
	// init necessary particle systems
	if (!pSnow) {
		NSLog(@"init pSnow");
		pSnow = [CCParticleSnow node];
		[arrPSystems addObject:pSnow];
		pSnow.texture = [[CCTextureCache sharedTextureCache] addImage: @"snow2.png"];
		[pSnow stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pSnow,nil];
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos9Finger];
}

-(void) pos9Finger {
	pSnow.position = [self centroidOfArrTouches:arrAllTouches];
	pSnow.posVar = ccp([self xRangeOfArrTouches:arrAllTouches]/2,30);
	pSnow.speed = [self yRangeOfArrTouches:arrAllTouches]/10.0;
}

-(void) handle10Finger {
	// init necessary particle systems
	if (!pMeteor1) {
		NSLog(@"init pGalaxy1");
		pMeteor1 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor1];
		pMeteor1.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor1 stopSystem];
	}
	if (!pMeteor2) {
		NSLog(@"init pGalaxy2");
		pMeteor2 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor2];
		pMeteor2.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor2 stopSystem];
	}
	if (!pMeteor3) {
		NSLog(@"init pGalaxy3");
		pMeteor3 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor3];
		pMeteor3.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor3 stopSystem];
	}
	if (!pMeteor4) {
		NSLog(@"init pGalaxy4");
		pMeteor4 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor4];
		pMeteor4.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor4 stopSystem];
	}
	if (!pMeteor5) {
		NSLog(@"init pMeteor5");
		pMeteor5 = [[[CCParticleMeteor alloc] initWithTotalParticles:150] autorelease];
		[arrPSystems addObject:pMeteor5];
		pMeteor5.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars2.png"];
		[pMeteor5 stopSystem];
	}
	if (!pDream) {
		NSLog(@"init pDream");
		pDream = [CCParticleFlower node];
		[arrPSystems addObject:pDream];
		pDream.texture = [[CCTextureCache sharedTextureCache] addImage: @"stars.png"];
		pDream.totalParticles = 200;
		[pDream stopSystem];
	}
	if (!pGalaxy) {
		NSLog(@"init pGalaxy");
		pGalaxy = [CCParticleGalaxy node];
		[arrPSystems addObject:pGalaxy];
		pGalaxy.texture = [[CCTextureCache sharedTextureCache] addImage: @"fire.pvr"];
		pGalaxy.totalParticles = 200;
		[pGalaxy stopSystem];
	}
	// necessary particle systems
	NSArray* arrNecePSystems = [NSArray arrayWithObjects:pMeteor1,pMeteor2,pMeteor3,pMeteor4,pMeteor5,pDream,pGalaxy,nil];
	ccColor4F colorVar = {0.1,0.1,0.1,1.0};
	pMeteor1.speedVar = 40;
	pMeteor1.startSize = 20;
	pMeteor1.startSizeVar = 8;
	pMeteor1.startColor = genRandomColor();
	pMeteor1.startColorVar = colorVar;
	pMeteor1.endColor = genRandomColor();	
	pMeteor1.endColorVar = colorVar;
	pMeteor1.gravity = ccp(0,200);
	pMeteor2.speedVar = 40;
	pMeteor2.startSize = 20;
	pMeteor2.startSizeVar = 8;
	pMeteor2.life = 3;
	pMeteor2.startColor = genRandomColor();
	pMeteor2.startColorVar = colorVar;
	pMeteor2.endColor = genRandomColor();	
	pMeteor2.endColorVar = colorVar;
	pMeteor2.gravity = ccp(0,200);
	pMeteor3.speedVar = 40;
	pMeteor3.startSize = 30;
	pMeteor3.startSizeVar = 12;
	pMeteor3.life = 3;
	pMeteor3.startColor = genRandomColor();
	pMeteor3.startColorVar = colorVar;
	pMeteor3.endColor = genRandomColor();	
	pMeteor3.endColorVar = colorVar;
	pMeteor3.gravity = ccp(0,200);
	pMeteor4.speedVar = 40;
	pMeteor4.startSize = 30;
	pMeteor4.startSizeVar = 12;
	pMeteor4.life = 3;
	pMeteor4.startColor = genRandomColor();
	pMeteor4.startColorVar = colorVar;
	pMeteor4.endColor = genRandomColor();	
	pMeteor4.endColorVar = colorVar;
	pMeteor4.gravity = ccp(0,200);
	pMeteor5.speedVar = 40;
	pMeteor5.startSize = 20;
	pMeteor5.startSizeVar = 8;
	pMeteor5.startColor = genRandomColor();
	pMeteor5.startColorVar = colorVar;
	pMeteor5.endColor = genRandomColor();	
	pMeteor5.endColorVar = colorVar;
	pMeteor5.gravity = ccp(0,200);
	pDream.speed = 200;
	pDream.speedVar = 40;
	pDream.startSize = 45;
	pDream.startSizeVar = 15;
	pDream.radialAccel = -120;
	ccColor4F startColor = {0.5f, 0.5f, 0.5f, 1.0f};
	pGalaxy.startColor = startColor;
	ccColor4F startColorVar = {0.5f, 0.5f, 0.5f, 1.0f};
	pGalaxy.startColorVar = startColorVar;
	ccColor4F endColor = {0.1f, 0.1f, 0.1f, 0.2f};
	pGalaxy.endColor = endColor;
	ccColor4F endColorVar = {0.1f, 0.1f, 0.1f, 0.2f};	
	pGalaxy.endColorVar = endColorVar;
	pGalaxy.startSize = 60.0f;
	// stop and remove unnecessary particle systems, reset and add nucessary particle systems
	[self addAndRemoveSystemsForNeceSystems:arrNecePSystems];
	
	// position the particle systems
	[self pos10Finger];
}

-(void) pos10Finger {
	pMeteor1.position = [self posFromTouch:[arrAllTouches objectAtIndex:0]];
	pMeteor2.position = [self posFromTouch:[arrAllTouches objectAtIndex:2]];
	pMeteor3.position = [self posFromTouch:[arrAllTouches objectAtIndex:4]];
	pMeteor4.position = [self posFromTouch:[arrAllTouches objectAtIndex:6]];
	pMeteor5.position = [self posFromTouch:[arrAllTouches objectAtIndex:8]];
	pDream.position = ccpSub([self centroidOfArrTouches:arrAllTouches],ccp(-100,0));
	pGalaxy.position = ccpSub([self centroidOfArrTouches:arrAllTouches],ccp(100,0));
}

-(void) dealloc {
	[arrPSystems release];
	[arrAllTouches release];
	[infoSprite release];
	[super dealloc];
}

@end
