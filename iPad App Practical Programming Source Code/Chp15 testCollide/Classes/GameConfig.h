//
//  GameConfig.h
//  testCollide
//
//  Created by Chen Li on 12/12/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

//
// Supported Autorotations:
//		None,
//		UIViewController,
//		CCDirector
//
#define kGameAutorotationNone 0
#define kGameAutorotationCCDirector 1
#define kGameAutorotationUIViewController 2

//
// Define here the type of autorotation that you want for your game
//
#define GAME_AUTOROTATION kGameAutorotationUIViewController

static const long long int ARC4RANDOM_MAX = 0x100000000;
// genearate a uniformly distributed number between [0,1)
CG_INLINE float genRandomNum() {
	return (float)arc4random()/ARC4RANDOM_MAX;
}


#endif // __GAME_CONFIG_H