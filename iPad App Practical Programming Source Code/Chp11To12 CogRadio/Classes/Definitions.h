/*
 *  Definitions.h
 *  CogRadio
 *
 *  Created by Chen Li on 11/18/10.
 *  Copyright 2010 Chen Li. All rights reserved.
 *
 */

#pragma mark Scene Constants
static const int SceneWidth = 1024;
static const int SceneHeight = 682;
static const int NumScene = 6;

#pragma mark Random Number
static const long long int ARC4RANDOM_MAX = 0x100000000;
CG_INLINE float genRandomNum() {
	return (float)arc4random()/ARC4RANDOM_MAX;
}

#pragma mark Probabilities
static const float probPuLane1 = 0.7;
static const float probPuLane2 = 0.5;
static const float probPuLane3 = 0.3;