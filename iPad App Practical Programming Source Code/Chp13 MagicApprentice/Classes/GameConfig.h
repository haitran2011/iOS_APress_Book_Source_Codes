//
//  GameConfig.h
//  MagicApprentice
//
//  Created by Chen Li on 12/4/10.
//  Copyright Chen Li 2010. All rights reserved.
//

#ifndef __GAME_CONFIG_H
#define __GAME_CONFIG_H

// the following is so important to avoid doing NSLog in a release build
// If it's a debug build, then __OPTIMIZE__ is not defined, then NSLog does the normal job;
// if it's a release build, then NSLog will do nothing, thus won't slow down the app
#ifndef __OPTIMIZE__
#    define NSLog(...) NSLog(__VA_ARGS__)
#	define IsInReleaseMode 0
#else
#    define NSLog(...) {}
#	define IsInReleaseMode 1
#endif

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
// generate a random color
CG_INLINE ccColor4F genRandomColor() {
	ccColor4F color = {genRandomNum(),genRandomNum(),genRandomNum(),1.0};
	return color;
}

// size of the tap cornier
#define TapRectWidth 140
#define TapRectHeight 100

#endif // __GAME_CONFIG_H