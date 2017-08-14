//
//  GameLayer.m
//  testCollide
//
//  Created by Chen Li on 12/12/10.
//  Copyright 2010 Chen Li. All rights reserved.
//

#import "GameLayer.h"
#import "GameConfig.h"

const int NumBulletsEachRound = 4;
const int TotalNumBullets = 120;			// =20*NumBulletsEachRound
const float MaxBulletMovingDist = 1280.0;	// =(1024^2+768^2)^0.5
const float SpeedScaler = 800.0;			// the larger, the more sensitive to acceleration

@implementation GameLayer

+(id) scene {
	// 'scene' is an autorelease object
	CCScene* scene = [CCScene node];
	
	// 'layer' is an autorelease object
	GameLayer* layer = [GameLayer node];
	
	// add layer as a child to scene
	[scene addChild:layer];
	
	// return the scene
	return scene;
}

-(id) init{
	if ( (self=[super init]) ) {
		// menu
		CCMenuItemFont* againButton = [CCMenuItemFont itemFromString:@"Again" target:self selector:@selector(again)];
		againButton.position = ccp(512,384);
		menu = [[CCMenu menuWithItems:againButton,nil] retain];
		menu.position = CGPointZero;
		// label
		labelTime = [[CCLabelTTF labelWithString:@"Time: 0.0" fontName:@"Marker Felt" fontSize:25] retain];
		labelTime.position = ccp(920,710);
		[self addChild:labelTime];
		// time
		time = 0.0;
		
		curIndex = 0;
		[self createSprites];
		
		// the following is necessary for using accelerometer
		UIAccelerometer *accelerometer = [UIAccelerometer sharedAccelerometer];
		accelerometer.delegate = self;				// set delegate as self, so that we can receive info of acceleration
		accelerometer.updateInterval =  1.0f/10.0f;	
		
		// main logic
		[self schedule:@selector(update:)];
		// fire bullets
		[self schedule:@selector(fireSomeBullets) interval:0.5];
	}
	
	return self;
}

-(void) createSprites {
	
	// create bullets
	arrayAllBullets = [[NSMutableArray alloc] init];
	for (int i=0; i<TotalNumBullets; i++) {
		CCSprite* bullet = [CCSprite spriteWithFile:@"picBullet.png"];
		bullet.position = ccp(-10,-10);
		[arrayAllBullets addObject:bullet];
		[self addChild:bullet];
	}
	
	// create ship
	ship = [[CCSprite alloc] initWithFile:@"Spaceship.png"];
	ship.position = ccp(512,384);
	[self addChild:ship];
	// ship speed
	shipSpeed = CGPointZero;
}

-(void) placeSprites {
	// clear bullets actions, and place them out of the screen
	for (CCSprite* bullet in arrayAllBullets) {
		[bullet stopAllActions];
		bullet.position = ccp(-10,10);
	}
	
	// place ship
	ship.position = ccp(512,384);
	// ship speed
	shipSpeed = CGPointZero;
}

-(void) fireSomeBullets {
	
	//NSLog(@"fireSomeBullets, curIndex = %d", curIndex);
	for (int i=curIndex; i<(curIndex+NumBulletsEachRound); i++) {
		// the bullet at index
		CCSprite* bullet = [arrayAllBullets objectAtIndex:i];
		// determine the random position of the bullet
		int l = (2*(1024+768)-1)*genRandomNum();
		if (l<(1024-1)) {
			bullet.position = ccp(l,768+10);
		}
		else if (l<(1024+768-1)) {
			bullet.position = ccp(1024+10,l-1024);
		}
		else if (l<(1024+768+1024-1)) {
			bullet.position = ccp(l-1024-768,-10);
		}
		else {
			bullet.position = ccp(-10,l-1024-768-1024);
		}
		// the direction the bullet is going
		CGPoint normalizedDirection = ccpNormalize(ccpSub(ship.position, bullet.position));
		//NSLog(@"%@",NSStringFromCGPoint(normalizedDirection));
		CCMoveBy* moveByAction = [CCMoveBy actionWithDuration:10.0 position:ccpMult(normalizedDirection, MaxBulletMovingDist)];
		[bullet runAction:moveByAction];
	}
	
	curIndex = (curIndex+NumBulletsEachRound)%TotalNumBullets;
}

-(void) update:(ccTime)dt {
	time += dt;
	[labelTime setString:[NSString stringWithFormat:@"Time: %.1f", time]];
	
	// update the position of the ship
	ship.position = ccpAdd(ship.position, ccpMult(shipSpeed, dt));
	// don't go out of the screen
	CGSize shipSize = ship.contentSize;
	if (ship.position.x<shipSize.width/2) {
		ship.position=ccp(shipSize.width/2,ship.position.y);
	}
	else if (ship.position.x>(1024-shipSize.width/2)) {
		ship.position=ccp((1024-shipSize.width/2),ship.position.y);
	}
	if (ship.position.y<shipSize.height/2) {
		ship.position=ccp(ship.position.x,shipSize.height/2);
	}
	else if (ship.position.y>(768-shipSize.height/2)) {
		ship.position=ccp(ship.position.x,(768-shipSize.height/2));
	}
	
	// check for collision
	bool ifCollide = NO;
	for (CCSprite* bullet in arrayAllBullets) {
		if (ccpDistance(bullet.position, ship.position)<15) {
			ifCollide = YES;
			break;
		}
	}
	if (ifCollide) {
		// pause game
		[[CCDirector sharedDirector] pause];
		// add menu
		[self addChild:menu];
	}
}

-(void) again {
	[self placeSprites];
	[self removeChild:menu cleanup:NO];
	time = 0.0;
	[labelTime setString:[NSString stringWithFormat:@"Time: %.1f", time]];
	[[CCDirector sharedDirector] resume];
}

- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration{
	// NSLog(@"accX: %f, accY: %f, accZ: %f", acceleration.x, acceleration.y, acceleration.z);
	shipSpeed = ccpMult(ccp(acceleration.y,-acceleration.x), SpeedScaler);
}

-(void) dealloc {
	[menu release];
	[labelTime release];
	[arrayAllBullets release];
	[ship release];
	
	[UIAccelerometer sharedAccelerometer].delegate = nil;
	
	[super dealloc];
}

@end
