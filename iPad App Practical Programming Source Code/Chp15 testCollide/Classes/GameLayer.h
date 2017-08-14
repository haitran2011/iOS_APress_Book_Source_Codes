//
//  GameLayer.h
//  testCollide
//
//  Created by Chen Li on 12/12/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface GameLayer : CCLayer <UIAccelerometerDelegate> {
	// menu
	CCMenu* menu;
	// label to display time
	CCLabelTTF* labelTime;
	// time played in the current game
	float time;
	
	// we create all the bullets together, and re-use them
	NSMutableArray* arrayAllBullets;
	// index of the next bullet available to use
	int curIndex;
	
	// the ship
	CCSprite* ship;
	// speed of the ship, will be proportional to the acc.x and acc.y
	CGPoint shipSpeed;
}

+(id) scene;
-(void) createSprites;
-(void) fireSomeBullets;
-(void) placeSprites;
-(void) again;

@end
