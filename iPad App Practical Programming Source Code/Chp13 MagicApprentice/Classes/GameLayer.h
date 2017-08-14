//
//  GameLayer.h
//  MagicApprentice
//
//  Created by Chen Li on 12/4/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer {
	NSMutableArray* arrAllTouches;
	NSMutableArray* arrPSystems;
	
	CCParticleFlower* pDream;
	CCParticleGalaxy* pGalaxy;
	CCParticleMeteor* pMeteor1;
	CCParticleMeteor* pMeteor2;
	CCParticleMeteor* pMeteor3;
	CCParticleMeteor* pMeteor4;
	CCParticleMeteor* pMeteor5;
	CCParticleFire* pFire;
	CCParticleSnow* pSnow;
	CCParticleSystemQuad* pQuad;
	CCParticleRain* pRain;
	CCParticleSystemPoint* pPoint;
	
	CCSprite* infoSprite;
}

// returns a Scene that contains the layer as the only child
+(id) scene;
// update the particle systems, in response to the change in touches
-(void) updateParticleSystems;
// re-position the particle systems, in response to the move of touches
-(void) posParticleSystems;
// return the positions for a set of touches
-(CGPoint) posFromTouch:(UITouch*)touch;
// stop and remove unnecessary particle systems, reset and add nucessary particle systems
-(void) addAndRemoveSystemsForNeceSystems:(NSArray*)neceSystems;
// bring up infoSprite
-(void) showInfoSprite;
// bring down infoSprite
-(void) hideInfoSprite;

// find centroid of an array of touches
-(CGPoint) centroidOfArrTouches:(NSMutableArray*)anArray;
// find the x range
-(float) xRangeOfArrTouches:(NSMutableArray*)anArray;
// find the y range
-(float) yRangeOfArrTouches:(NSMutableArray*)anArray;

// handle different number of fingers on the screen
-(void) handle1Finger;
-(void) handle2Finger;
-(void) handle3Finger;
-(void) handle4Finger;
-(void) handle5Finger;
-(void) handle6Finger;
-(void) handle7Finger;
-(void) handle8Finger;
-(void) handle9Finger;
-(void) handle10Finger;
-(void) pos1Finger;
-(void) pos2Finger;
-(void) pos3Finger;
-(void) pos4Finger;
-(void) pos5Finger;
-(void) pos6Finger;
-(void) pos7Finger;
-(void) pos8Finger;
-(void) pos9Finger;
-(void) pos10Finger;

@end
