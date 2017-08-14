//
//  Pin.m
//  MapApp
//
//  Created by Chen Li on 1/2/11.
//  Copyright 2011 Chen Li. All rights reserved.
//

#import "Pin.h"

@implementation Pin

@synthesize latitude;
@synthesize longitude;


- (CLLocationCoordinate2D)coordinate
{
	CLLocationCoordinate2D coord = {self.latitude, self.longitude};
	return coord;
}

@end
